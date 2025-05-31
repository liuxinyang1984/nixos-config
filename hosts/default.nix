#hosts/default.nix
{ config, pkgs, ... }:

{
  # 基础系统配置
  networking.hostName = "NixOs";
  system.stateVersion = "23.11";

 # 文件系统
  fileSystems."/" = {
    device = "/dev/disk/by-label/nix-root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };

  # 引导加载器设置
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

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
    zsh
    # 可以移除 oh-my-zsh
  ];

  # 设置 Zsh 为默认 shell
  programs.zsh = {
    enable = true;
  };
}

