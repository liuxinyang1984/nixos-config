{ config, pkgs, ... }:

{
  programs.ncmpcpp = {
    enable = true;
    extraConfig = ''
      # 配置 NCMPCPP 相关设置
      audioOutput = "alsa";
    '';
  };
}
