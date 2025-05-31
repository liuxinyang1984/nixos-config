# modules/keyd.nix
{ config, pkgs, lib, ... }:

{
  # 确保启用 keyd 服务
  services.keyd.enable = true;

  # 设置配置文件路径
  environment.etc."keyd/config".source = ../etc/keyd/config;
}

