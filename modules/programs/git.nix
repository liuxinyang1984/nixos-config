# modules/programs/git.nix
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Mr.Cookie";
    userEmail = "liuxinyang1984@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
        trustctime = false;
        fileMode = false;
        whitespace = "-trailing-space,-space-before-tab";
      };
      user = {
        email = "liuxinyang1984@gmail.com";
        name = "Mr.Cookie";
      };
      alias.tree = "log --graph --date-order -C -M --pretty=format:'<%h> %ad [%an] %Cgreen%d%Creset %s' --date=short";
      apply.whitespace = "nowarn";
      diff = {
        ignoreSpaceChange = true;
        ignoreSubmodules = "dirty";
      };
      merge.ignoreWhitespace = true;
    };
  };
}

