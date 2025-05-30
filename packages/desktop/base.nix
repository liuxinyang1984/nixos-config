# /packages/desktop/base.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-utils
    xdg-user-dirs
    networkmanagerapplet
    file-roller
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
  ];
}
