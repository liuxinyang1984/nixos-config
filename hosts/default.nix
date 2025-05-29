#hosts/default.nix
{ config, pkgs, ... }:

{
  # 基础系统配置
  networking.hostName = "cookie-pc";
  system.stateVersion = "23.11";

  # 用户账户
  users.users.cookie = {
    isNormalUser = true;
    description = "Cookie User";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;
  };

  # 启用 flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # 允许非自由软件
  nixpkgs.config.allowUnfree = true;

  # 系统级软件包
  environment.systemPackages = with pkgs; [
    git neovim wget curl
    zsh oh-my-zsh
  ];

  # 设置 Zsh 为默认 shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
