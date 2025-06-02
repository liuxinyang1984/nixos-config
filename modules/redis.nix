# modules/redis.nix
{ config, lib, pkgs, ... }:

{
  services.redis.servers."".enable = true;

  systemd.services.redis.serviceConfig = {
    # 如有特殊配置可加在这里
  };
}

