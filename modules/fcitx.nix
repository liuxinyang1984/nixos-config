# modules/fcitx.nix
{ config, pkgs, ... }:

{
  # 启用 Fcitx5 输入法框架
  i18n.inputMethod = {
    enable = true;  # 启用输入法
    type = "fcitx5";  # 设置输入法类型为 fcitx5
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons  # 中文输入支持 (拼音、五笔等)
      #fcitx5-rime             # Rime 输入引擎 (中州韵)
      #fcitx5-gtk              # GTK 程序支持
    ];
  };

  # 可选：配置默认输入法 (例如设置为拼音)
  environment.variables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}
