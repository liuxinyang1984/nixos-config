# home-manager/users/cookie.nix
{ pkgs, lib, ... }:  # Add 'lib' here

{
  imports = [
    ../../modules/neovim.nix  # Neovim 配置
    ../../modules/zsh.nix     # Zsh 配置
  ];

  # 用户专属设置
  home.username = "cookie";
  home.homeDirectory = "/home/cookie";

  home.stateVersion = "25.11";  # 必须设置，匹配你NixOS版本
  # 个人软件包
  home.packages = with pkgs; [
    # 开发工具
    nodejs python3 go rustc mycli yazi
    android-studio
    # androidenv.androidPkgs.emulator
    # androidenv.androidPkgs.all.packages.emulator.v36
    # androidenv.androidPkgs.all.packages.emulator.v35_5_8
    
    # 系统工具
    duf dust procs transmission_4-qt
    
    # 图形应用
    firefox vscode google-chrome
    # 微信
    wechat-uos steam
    
  ];

  # 鼠标指针主题
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };


  # flatpak 环境变量
  #home.sessionVariables = {
  #  # 这里直接用系统默认的 XDG_DATA_DIRS，加上 Flatpak 的路径
  #  # 注意不能用 builtins.getEnv，因为 nix 语言阶段读不到外部环境变量，
  #  # 所以这里写了常用的系统默认路径，后面追加 flatpak 路径。
  #  XDG_DATA_DIRS = lib.concatStringsSep ":" [
  #    "/usr/share"
  #    "/usr/local/share"
  #    "/var/lib/flatpak/exports/share"
  #    "/home/cookie/.local/share/flatpak/exports/share"
  #  ];
  #};
  programs.zsh = {
    initContent = ''
      # 动态追加 Flatpak 路径到 XDG_DATA_DIRS，避免覆盖系统默认值
      export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    '';
  };
}
