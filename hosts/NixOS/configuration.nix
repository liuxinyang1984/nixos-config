{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/system/base.nix
    ../../modules/system/networking.nix
    ../../modules/system/users.nix
    ../../modules/services/nginx.nix
    ../../modules/services/php.nix
    ../../modules/services/mysql.nix
    ../../modules/services/redis.nix
    ../../modules/services/rabbitmq.nix
    ../../modules/services/mpd.nix
    ../../modules/gui/hyprland.nix
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry.nixpkgs.flake = pkgs;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11";
}

