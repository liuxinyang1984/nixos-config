#packages/desktop/plasma6.nix
{ pkgs, lib, ... }:

{
  # 安装 fcitx5 和 fcitx5-wubi
  environment.systemPackages = with pkgs; [
    fcitx5
    fcitx5-wubi
  ];

  # 启用 fcitx5 输入法框架
  i18n.inputMethod.enabled = "fcitx5";

  # 启用 fcitx5 输入法管理器
  services.xserver.desktopManager.fcitx5.enable = true;

  # 设置输入法环境变量
  environment.variables = {
    "GTK_IM_MODULE" = "fcitx";
    "QT_IM_MODULE" = "fcitx";
    "XMODIFIERS" = "@im=fcitx";
  };
}

