#packages/web.nix
{ inputs, pkgs, config, lib, ... }:

{
  imports = [
    ../modules/php.nix
    ../modules/nginx.nix
    ../modules/redis.nix
    ../modules/rabbitmq.nix
  ];

  # 如有需要，统一定义 service 依赖
  systemd.targets.multi-user.requires = [
    "nginx.service"
    "redis.service"
    "rabbitmq.service"
    "phpfpm-php74.service"
    "phpfpm-php82.service"
  ];
}

