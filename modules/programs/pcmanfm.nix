{ config, pkgs, ... }:

{
  programs.pcmanfm = {
    enable = true;
    extraConfig = ''
      # PCManFM 文件管理器相关设置
      startupApplications = [
        "terminator"
      ];
    '';
  };
}

