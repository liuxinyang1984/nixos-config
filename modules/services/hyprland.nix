# modules/services/hyprland.nix
{ config, pkgs, ... }:

{
  services.xserver.windowManager.hyprland.enable = true;

  # 这里可以添加自定义的 Hyprland 配置
  # 例如，调整主题、窗口设置等
  services.xserver.windowManager.hyprland.config = ''
    # 配置文件的内容
    hyprland.conf
  '';
}
