{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    extraConfig = ''
      # 设置字体、透明度等
      font = "monospace:size=10";
      background = "transparent";
    '';
  };
}

