#hosts/default.nix
{ config, pkgs, ... }:

{
  # 基础系统配置
  networking.hostName = "NixOs";
  system.stateVersion = "24.05";

 # 文件系统
  fileSystems."/" = {
    device = "/dev/disk/by-label/nix-root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/nix-home";
    fsType = "ext4";
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
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "kvm" "libvirtd" "input" ];
    shell = pkgs.zsh;
  };

  # 启用 flakes
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-cache/"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "nixos.org-1:Zy6IWH2qLgjAyf23n70hZFXVYZn4OH1W+iViZpx4txQ="
      "cache.nixos.org-1:..."  # 这个你保留原来的，不用删
    ];
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

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

