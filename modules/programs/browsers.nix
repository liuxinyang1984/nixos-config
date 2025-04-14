{ config, pkgs, ... }:

{
  programs.qutebrowser = {
    enable = true;
    extraConfig = ''
      # 设置 Qutebrowser 配置
    '';
  };

  programs.firefox = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
  };

  programs.microsoft-edge = {
    enable = true;
  };
}
