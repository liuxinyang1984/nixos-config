{ config, lib, pkgs, ... }:

{
  # 启用 X11/Wayland 输入法支持
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-chinese-addons
    fcitx5-configtool
    fcitx5-gtk
    fcitx5-qt
  ];

  # 可选：用于 Wayland 下 GTK/Qt 应用的输入法环境变量（更保险）
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    INPUT_METHOD = "fcitx";
  };
}

