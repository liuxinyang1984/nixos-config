{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withPython3 = true;
    withNodeJs = true;
    withRuby = false;
  };

  home.file = {
    ".config/nvim/init.vim".source = ./init.vim;
    ".config/nvim/autoload/plug.vim".source = ./autoload/plug.vim;
  };
}
