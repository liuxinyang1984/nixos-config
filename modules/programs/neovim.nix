{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number
      set relativenumber
      syntax enable
    '';
  };
}
