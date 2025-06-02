# packages/base.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    unzip
    git
    curl
    wget
    fzf
    eza
    bat
    btop
    xorg.xinput
    busybox
    pulsemixer
  ];

  # 其它软件引用
  imports = [
    ../modules/ssh.nix
    ../modules/v2ray.nix
    ../modules/keyd.nix
    ../modules/flatpak.nix
  ];
}
