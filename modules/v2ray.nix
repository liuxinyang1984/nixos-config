# modules/zsh.nix
{ config, pkgs,lib, ... }:

{
  services.v2ray = {
    enable = true;
    configFile = "/etc/v2ray/config.json";  # 指定配置文件路径
  };

  environment.etc."v2ray/config.json".source = lib.mkForce ../etc/v2ray/config.json;
}
