#packages/web.nix
{ config, pkgs, lib, inputs, ... }:
let
  # 1. 获取 nix-phps 源
  nix-phps = inputs.nix-phps.packages.${pkgs.system};
  
  # 2. Laravel/ThinkPHP 常用扩展列表
  commonPhpExtensions = all: with all; [
    bcmath
    curl
    exif
    fileinfo
    gd
    intl
    mbstring
    mysqli
    opcache
    openssl
    pdo
    pdo_mysql
    redis
    sockets
    zip
    memcached
    imagick
    xdebug
  ];
  
  # 3. PHP 7.4 环境
  php74 = nix-phps.php74.buildEnv {
    extensions = ({ all, enabled }: 
      enabled ++ commonPhpExtensions all
    );
    extraConfig = ''
      memory_limit = 2G
      opcache.enable = 1
      xdebug.mode = debug
    '';
  };
  
  # 4. PHP 8.2 环境
  php82 = pkgs.php82.buildEnv {
    extensions = ({ all, enabled }: 
      enabled ++ commonPhpExtensions all
    );
    extraConfig = ''
      memory_limit = 2G
      opcache.enable = 1
      xdebug.mode = debug
    '';
  };
  
  # 5. 版本化 Composer 包装器
  composer74 = pkgs.writeShellScriptBin "composer74" ''
    ${php74}/bin/php ${pkgs.phpPackages.composer}/bin/composer "$@"
  '';
  
  composer82 = pkgs.writeShellScriptBin "composer82" ''
    ${php82}/bin/php ${pkgs.phpPackages.composer}/bin/composer "$@"
  '';
in 
{
  # 6. 将组件添加到系统环境
  environment.systemPackages = [
    pkgs.nginx
    pkgs.mariadb
    pkgs.redis
    pkgs.rabbitmq-server
    php74
    php82
    composer74
    composer82
    pkgs.git
    pkgs.curl
    pkgs.wget
  ];
  
  # 7. 创建命令别名
  environment.shellAliases = {
    php74 = "${php74}/bin/php";
    php82 = "${php82}/bin/php";
    composer74 = "${composer74}/bin/composer74";
    composer82 = "${composer82}/bin/composer82";
  };
  
  # 8. 服务配置
  services.nginx = {
    enable = true;
    # 基本虚拟主机配置
    virtualHosts."localhost" = {
      locations."/" = {
        root = "/var/www/html";
      };
      locations."~ \.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.php74.socket};
          include ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        '';
      };
    };
  };
  
  # mysql数据库
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    
    # 关键修复：添加初始设置
    initialScript = pkgs.writeText "mariadb-init.sql" ''
      CREATE USER IF NOT EXISTS 'admin'@'localhost';
      GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';
    
    # 确保数据目录存在
    dataDir = "/var/lib/mysql";
    
    # 添加基本设置
    settings = {
      mysqld = {
        bind-address = "127.0.0.1";
        # 确保 systemd 能正确识别服务类型
        pid-file = "/run/mysqld/mysqld.pid";
        socket = "/run/mysqld/mysqld.sock";
      };
    };
    
    # 确保数据库和用户存在
    ensureDatabases = [ "app_db" ];
    ensureUsers = [{
      name = "admin";
      ensurePermissions = { "app_db.*" = "ALL PRIVILEGES"; };
    }];
  };
  
  services.redis.servers."" = {
    enable = true;
    # 可选：添加其他配置
    # bind = "127.0.0.1";
    # port = 6379;
  };
 
  services.rabbitmq = {
    enable = true;
    plugins = [ "rabbitmq_management" ];  # 启用管理界面
  };
  
  # 9. PHP-FPM 配置
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
  
  # 10. 系统用户和目录设置
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
  
  # 11. 确保服务在启动时运行
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
