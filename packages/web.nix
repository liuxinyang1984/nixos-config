#packages/web.nix
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

  php74conf = pkgs.writeText "php74.conf" ''
    location ~ \.php$ {
      fastcgi_pass unix:/run/phpfpm/php74.sock;
      include ${pkgs.nginx}/conf/fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
  '';

  php82conf = pkgs.writeText "php82.conf" ''
    location ~ \.php$ {
      fastcgi_pass unix:/run/phpfpm/php82.sock;
      include ${pkgs.nginx}/conf/fastcgi_params;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
  '';
in {
  environment.systemPackages = [
    pkgs.nginx pkgs.mariadb pkgs.redis pkgs.rabbitmq-server
    php74 php82 composer74 composer82 pkgs.git pkgs.curl pkgs.wget
  ];

  environment.shellAliases = {
    php74 = "${php74}/bin/php";
    php82 = "${php82}/bin/php";
    composer74 = "${composer74}/bin/composer74";
    composer82 = "${composer82}/bin/composer82";
  };

  services.nginx = {
    enable = true;

    appendHttpConfig = ''
      include /etc/nginx/sites-enabled/*.conf;
    '';

    virtualHosts."localhost" = {
      locations."/" = { root = "/var/www/html"; };
      locations."~ \.php$" = {
        extraConfig = ''
          fastcgi_pass unix:/run/phpfpm/php74.sock;
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
      };
    };
  };

  # mariadb数据库服务
    services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/var/lib/mysql";

    initialScript = pkgs.writeText "init.sql" ''
      ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'xmlxzl';
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';

    ensureDatabases = [ "app_db" ];
    settings.mysqld = {
      bind-address = "127.0.0.1";
      pid-file = "/run/mysqld/mysqld.pid";
      socket = "/run/mysqld/mysqld.sock";
    };
  };

    
  # redis服务
  services.redis.servers."" = {
    enable = true;
  };

  services.rabbitmq = {
    enable = true;
    plugins = [ "rabbitmq_management" ];
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
      };
      phpOptions = ''
        memory_limit = 2G
        opcache.enable = 1
      '';
    };
  };

  users.users.nginx = {
    isSystemUser = true;
    group = "nginx";
  };

  users.groups.nginx = {};

  system.activationScripts.setup-www-dir = lib.stringAfter [ "users" ] ''
    mkdir -p /var/www/html
    chown nginx:nginx /var/www/html
    chmod 755 /var/www/html

    mkdir -p /etc/nginx/sites-available
    mkdir -p /etc/nginx/sites-enabled

    cp ${php74conf} /etc/nginx/php74.conf
    cp ${php82conf} /etc/nginx/php82.conf
  '';

  systemd.services = {
    nginx.serviceConfig.Type = "simple";
    mariadb.enable = true;
    redis.enable = true;
    rabbitmq.enable = true;
    phpfpm-php74.enable = true;
    phpfpm-php82.enable = true;
  };

  systemd.targets.multi-user.requires = [
    "nginx.service"
    "mariadb.service"
    "redis.service"
    "rabbitmq.service"
    "phpfpm-php74.service"
    "phpfpm-php82.service"
  ];
}

