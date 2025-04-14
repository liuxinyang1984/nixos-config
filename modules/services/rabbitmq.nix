# modules/services/rabbitmq.nix
{ config, pkgs, ... }:

{
  services.rabbitmq = {
    enable = true;
    package = pkgs.rabbitmq;
    managementPlugin = true;
    cookie = "secret_cookie";  # 设置 RabbitMQ 的 Cookie
  };
}
