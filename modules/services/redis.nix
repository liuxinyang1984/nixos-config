# modules/services/redis.nix
{
  services.redis = {
    enable = true;
    package = pkgs.redis;
    password = "xmlxzl";
    bindAddress = "0.0.0.0";  # 监听所有网卡
  };
}

