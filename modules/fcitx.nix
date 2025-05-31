#packages/desktop/fcitx5
{ pkgs, config, lib, ... }:

{
  # 配置输入法系统
  programs.i18n.inputMethod = {
    enable = true;
    # 启用 fcitx5 输入法框架
    fcitx5.enable = true;
    # 设置默认的五笔输入法
    fcitx5.default = "rime.five_stroke";  # 或者其他五笔输入法
    # 启用 Wayland 支持（如果使用 Wayland）
    fcitx5.enableWayland = true;
  };

  # 安装必要的软件包
  environment.systemPackages = with pkgs; [
    fcitx5          # fcitx5 框架
    fcitx5-rime     # rime 输入法（五笔、拼音等）
  ];


}

