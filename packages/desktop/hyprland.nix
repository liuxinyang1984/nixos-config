#packages/desktop/hyprland.nix
{ pkgs, ... }:

{
  # 引入基础和字体主题配置
  imports = [
    ./base.nix
    ../../modules/fonts.nix
    ../../modules/themes.nix
    ../../modules/media.nix
    ../../modules/fcitx.nix
  ];

  environment.systemPackages = with pkgs; [
    hyprland
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    jq             # Json数据操作
    cliphist       # 剪贴板历史
    foot           # 终端
    swww           # 壁纸
    waybar         # 状态栏
    wofi           # 启动器
    grim           # 截图
    mako           # 通知
    swaybg         # 壁纸
    swaylock       # 锁屏
    swappy         # 截图处理
    slurp          # 交互式选择区域
    libnotify      # 发送桌面通知
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
    
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __NV_PRIME_RENDER_OFFLOAD = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
  };
}

