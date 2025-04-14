{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "liuxinyang1984";
    userEmail = "liuxinyang1984@gmail.com";
    extraConfig = ''
      core.editor = "nvim"
    '';
  };
}

