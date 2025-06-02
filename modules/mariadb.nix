# modules/mariadb.nix
{pkgs,... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings = {
      mysqld = {
        bind-address = "127.0.0.1";
      };
    };
    initialScript = ../etc/mariadb/init.sql;
  };
}
