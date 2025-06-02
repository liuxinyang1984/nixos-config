# /packages/desktop/base.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xrandr
    xdg-utils
    xdg-user-dirs
    networkmanagerapplet
    file-roller
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    
    # 添加 Microsoft Edge（如果已启用）
  ];
}
