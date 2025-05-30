# /packages/themes.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
    qogir-theme
    bibata-cursors
  ];

  # GTK configuration (optional, usually managed in home.nix if using home-manager)
  environment.sessionVariables = {
    GTK_THEME = "Qogir-dark";
    XCURSOR_THEME = "Bibata-Modern-Ice";
  };
}
