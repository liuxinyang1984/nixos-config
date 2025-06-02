# modules/rabbitmq.nix
{ config, lib, pkgs, ... }:

{
  services.rabbitmq = {
    enable = true;
    plugins = [ "rabbitmq_management" ];
  };

  systemd.services.rabbitmq.serviceConfig = {
    # 可自定义 service 参数
  };
}

