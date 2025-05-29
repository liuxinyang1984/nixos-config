#modules/zsh.nix
{ config, pkgs, ... }:

{
  services.v2ray = {
    enable = true;
    configFile = "/etc/v2ray/config.json";
  };

  environment.etc."v2ray/config.json".source = ../etc/v2ray/config.json;
}
