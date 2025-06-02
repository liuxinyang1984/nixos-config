# modules/php.nix
{ config, pkgs, lib, inputs, ... }:
let
  nix-phps = inputs.nix-phps.packages.${pkgs.system};

  commonPhpExtensions = all: with all; [
    bcmath curl exif fileinfo gd intl mbstring mysqli
    opcache openssl pdo pdo_mysql redis sockets zip
    memcached imagick xdebug
  ];

  php74 = nix-phps.php74.buildEnv {
    extensions = ({ all, enabled }: enabled ++ commonPhpExtensions all);
    extraConfig = ''
      memory_limit = 2G
      opcache.enable = 1
      xdebug.mode = debug
    '';
  };

  php82 = pkgs.php82.buildEnv {
    extensions = ({ all, enabled }: enabled ++ commonPhpExtensions all);
    extraConfig = ''
      memory_limit = 2G
      opcache.enable = 1
      xdebug.mode = debug
    '';
  };

  composer74 = pkgs.writeShellScriptBin "composer74" ''
    ${php74}/bin/php ${pkgs.phpPackages.composer}/bin/composer "$@"
  '';

  composer82 = pkgs.writeShellScriptBin "composer82" ''
    ${php82}/bin/php ${pkgs.phpPackages.composer}/bin/composer "$@"
  '';
in {
  environment.systemPackages = [
    php74 php82 composer74 composer82
  ];

  environment.shellAliases = {
    php74 = "${php74}/bin/php";
    php82 = "${php82}/bin/php";
    composer74 = "${composer74}/bin/composer74";
    composer82 = "${composer82}/bin/composer82";
  };

  services.phpfpm.pools = {
    php74 = {
      user = "nginx";
      phpPackage = php74;
      settings = {
        "listen" = "/run/phpfpm/php74.sock";
        "pm" = "dynamic";
        "pm.max_children" = 10;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 5;
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0660";
      };
      phpOptions = ''
        memory_limit = 2G
        upload_max_filesize = 128M
        post_max_size = 128M
      '';
    };

    php82 = {
      user = "nginx";
      phpPackage = php82;
      settings = {
        "listen" = "/run/phpfpm/php82.sock";
        "pm" = "ondemand";
        "pm.max_children" = 25;
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0660";
      };
      phpOptions = ''
        memory_limit = 2G
        opcache.enable = 1
      '';
    };
  };

  systemd.services = {
    phpfpm-php74.enable = true;
    phpfpm-php82.enable = true;
  };
}

