{ config, pkgs, ... }:

{
  # 安装 JetBrainsMono Nerd Font 和 Noto Sans CJK SC 字体
  environment.systemPackages = with pkgs; [
    fontconfig
    # 安装 JetBrainsMono Nerd Font
    nerd-fonts-jetbrains-mono
    # 安装 Noto Sans CJK SC 字体
    noto-fonts-cjk
  ];

  # 启用字体配置
  fonts.fontconfig.enable = true;
}

