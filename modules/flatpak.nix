# modules/flatpak.nix
{ pkgs,lib, ... }:  # 只用到 pkgs
{
  environment.systemPackages = [ pkgs.flatpak ];
  services.flatpak.enable = true;

  # 必须启用 XDG Portal，满足 flatpak 依赖
  xdg.portal.enable = true;

  xdg.portal.extraPortals = [
    pkgs.kdePackages.xdg-desktop-portal-kde
  ];

  # 修复警告
  xdg.portal.config = {
    common.default = "*";
  };
}
