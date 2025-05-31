#packages/desktop/plasma6.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.plasma-workspace 
    kdePackages.konsole 
    kdePackages.dolphin 
    kdePackages.kdeplasma-addons 
    kdePackages.xdg-desktop-portal-kde 
  ];

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  i18n.inputMethod.enabled = "fcitx5";
}
