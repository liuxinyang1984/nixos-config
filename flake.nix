# flake.nix
{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in rec {
    nixosConfigurations.NixOS = pkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./hosts/NixOS/configuration.nix
        # 动态加载 modules 目录下所有的 .nix 文件
        (builtins.attrNames (builtins.readDir ./modules) // map (name: ./modules/${name}) (builtins.attrNames (builtins.readDir ./modules)))
      ];
    };
  });
}

