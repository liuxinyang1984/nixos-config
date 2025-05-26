# modules/services/mariadb.nix
{ config, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;  # 使用 MariaDB 代替 MySQL
    rootPassword = "xmlxzl"; # 设置 root 密码
    bindAddress = "0.0.0.0"; # 监听所有地址
  };
}

