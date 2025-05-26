{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fontconfig
    nerd-fonts-jetbrains-mono
    noto-fonts-cjk
    noto-fonts-cjk-serif
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig.enable = true;

    # 可选：在这里定义 fallback 字体，应用于一些环境（不依赖自定义 fonts.conf）
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans CJK SC" ];
      sansSerif = [ "Noto Sans CJK SC" ];
      serif = [ "Noto Serif CJK SC" ];
    };
  };

  # 自动将你自定义的 fonts.conf 挂载为 /etc/fonts/local.conf
  # 假设 fonts.conf 和 font.nix 在同一目录
  environment.etc."fonts/local.conf".source = ./fonts.conf;
}
