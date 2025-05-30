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
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # 加载 sites-enabled 下的所有 conf 文件
    configFile = pkgs.writeText "nginx.conf" ''
      user nginx;
      worker_processes auto;
      error_log /var/log/nginx/error.log warn;
      pid /run/nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        include       ${pkgs.nginx}/conf/mime.types;
        default_type  application/octet-stream;

        sendfile        on;
        keepalive_timeout  65;

        include /etc/nginx/sites-enabled/*.conf;
      }
    '';
  };

  system.activationScripts.setup-nginx-sites = lib.stringAfter [ "users" ] ''
    mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
    mkdir -p /etc/nginx
    ln -sf /etc/nginx/sites-available /etc/nginx/sites-enabled
    cat > /etc/nginx/php74.conf <<EOF
fastcgi_pass unix:${config.services.phpfpm.pools.php74.settings.listen};
include ${pkgs.nginx}/conf/fastcgi_params;
fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
EOF

    cat > /etc/nginx/php82.conf <<EOF
fastcgi_pass unix:${config.services.phpfpm.pools.php82.settings.listen};
include ${pkgs.nginx}/conf/fastcgi_params;
fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
EOF
  '';

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = pkgs.writeText "mariadb-init.sql" ''
      CREATE USER IF NOT EXISTS 'admin'@'localhost';
      GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';
    dataDir = "/var/lib/mysql";
    settings.mysqld = {
      bind-address = "127.0.0.1";
      pid-file = "/run/mysqld/mysqld.pid";
      socket = "/run/mysqld/mysqld.sock";
    };
    ensureDatabases = [ "app_db" ];
    ensureUsers = [{
      name = "admin";
      ensurePermissions = { "app_db.*" = "ALL PRIVILEGES"; };
    }];
  };

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
        listen = "/run/phpfpm/php74.sock";
        pm = "dynamic";
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
        listen = "/run/phpfpm/php82.sock";
        pm = "ondemand";
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

