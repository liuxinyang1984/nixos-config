{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    # 👇 引入 home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }:
    flake-utils.lib.eachSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # 递归列出所有 modules 下的 .nix 文件
        listNixFiles = dir: let
          entries = builtins.attrNames (builtins.readDir dir);
          files = builtins.filter (f: builtins.match "\\.nix$" f != null) entries;
          dirs = builtins.filter (f: builtins.pathType (dir + "/" + f) == "directory") entries;
        in
          (map (f: dir + "/" + f) files)
          ++ builtins.concatLists (map (d: listNixFiles (dir + "/" + d)) dirs);

        modules = [
          # 引入主机配置
          ./hosts/NixOS/configuration.nix

          # 👇 引入 home-manager 的 NixOS 模块
          home-manager.nixosModules.home-manager
        ] ++ listNixFiles ./modules;

      in {
        nixosConfigurations.NixOS = pkgs.lib.nixosSystem {
          system = system;
          modules = modules;
        };
      }
    );
}

