# /packages/fonts.nix
{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    font-awesome
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = ["JetBrainsMono Nerd Font" "Noto Sans Mono CJK SC"];
    sansSerif = ["Noto Sans" "Noto Sans CJK SC"];
    serif = ["Noto Serif" "Noto Serif CJK SC"];
  };
}
