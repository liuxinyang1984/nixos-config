# modules/services/php.nix
{ config, pkgs, ... }:

{
  services.phpfpm = {
    enable = true;
    phpPackages = [ pkgs.php56 pkgs.php74 pkgs.php80 ];
  };
}
