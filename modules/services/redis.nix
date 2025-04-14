# modules/services/redis.nix
{ config, pkgs, ... }:

{
  services.redis = {
    enable = true;
    package = pkgs.redis;
    password = "xmlxzl"; # 设置密码
  };
}
