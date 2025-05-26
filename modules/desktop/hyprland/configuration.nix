{ config, pkgs, ... }:

{
  # 启用 X11 支持（尽管 Hyprland 是 Wayland，也需要它启用基本组件）
  services.xserver.enable = true;

  # 使用 startx 手动启动窗口管理器
  services.xserver.displayManager.startx.enable = true;

  # 启用 Hyprland 支持
  services.xserver.windowManager.hyprland.enable = true;

  # 确保 Hyprland 可用
  environment.systemPackages = with pkgs; [
    hyprland
    xwayland          # 若你要兼容 X11 应用
    wayland-utils     # wayland-info、wayland-scanner 等
  ];
}

