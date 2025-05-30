#packages/desktop/hyprland.nix
{ pkgs, ... }:

{
  # 引入基础和字体主题配置
  imports = [
    ./base.nix
    ../../modules/fonts.nix
    ../../modules/themes.nix
    ../../modules/media.nix
  ];

  environment.systemPackages = with pkgs; [
    hyprland
    foot           # 终端
    waybar         # 状态栏
    wofi           # 启动器
    grim           # 截图
    mako           # 通知
    swaybg         # 壁纸
    swappy         # 截图处理
    hyprlock       # 屏幕锁定
    hyprpolkitagent # 身份验证代理
    wl-clipboard   # 剪切板管理
    brightnessctl  # 亮度调节（笔记本）
    networkmanagerapplet  # 网络管理小程序
    xwayland  # X11 兼容层
    # 其它和Hyprland桌面环境相关的软件包...
  ];


  # 可设置环境变量，字体和主题通常在主题模块中设置，这里示范示例
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
  };
}

