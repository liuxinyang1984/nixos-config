# flake.nix
{
  description = "Cookie's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";  # 继承主 nixpkgs 版本
    };
  };

  outputs = { nixpkgs, home-manager, self, ... }@inputs: {
    nixosConfigurations = {
        cookie-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # 关键：传递 inputs 给所有模块
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          ./hosts/default.nix
          ./modules/nvidia.nix
          ./packages/base.nix
          ./packages/desktop/hyprland.nix
          ./packages/desktop/plasma6.nix
          ./packages/web.nix
          ./modules/mariadb.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.cookie = import ./home-manager/users/cookie.nix;
            };
          }
        ];
      };
      cookie-kvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # 关键：传递 inputs 给所有模块
        specialArgs = {
          inherit self;
          inherit inputs;
        };
        modules = [
          ./hosts/default.nix
          ./modules/virtio.nix
          ./packages/base.nix
          ./packages/desktop/hyprland.nix
          ./packages/web.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.cookie = import ./home-manager/users/cookie.nix;
            };
          }
        ];
      };
    };
  };
}
