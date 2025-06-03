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
    iwd
  ];

# 在 NixOS 配置中启用 IWD 服务
# networking.wireless.enable = true;
# networking.iwd.enable = true;

networking.wireless.iwd.enable = true;  # 启用 iwd
networking.networkmanager.enable = false; # 确保 NetworkManager 已禁用（若存在）
  # 其它软件引用
  imports = [
    ../modules/ssh.nix
    ../modules/v2ray.nix
    ../modules/keyd.nix
    ../modules/flatpak.nix
  ];
}
