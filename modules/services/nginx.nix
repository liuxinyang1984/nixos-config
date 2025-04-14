# modules/services/nginx.nix
{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "example.com" = {
        root = "/var/www/example";
        index = "index.html";
      };
    };
    package = pkgs.nginxMainline;
  };
}

