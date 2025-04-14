{ config, pkgs, ... }:

{
  # 启用 Hyprland 作为窗口管理器
  services.xserver.windowManager.hyprland.enable = true;

  # 配置 Hyprland 默认的启动命令
  services.xserver.windowManager.hyprland.extraConfig = ''
    # 这里可以加入一些 Hyprland 的配置
    # 例如屏幕分辨率、键盘布局、窗口行为等
    exec hyprland
  '';
}

