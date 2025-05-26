{ config, pkgs, ... }:

let
  phpExtensions = with pkgs.phpExtensions; [
    mbstring
    pdo_mysql
    tokenizer
    xml
    bcmath
    curl
    json
    fileinfo
    gd
    openssl
    zip
  ];

  php56WithExt = pkgs.php56.override {
    extensions = phpExtensions;
  };

  php74WithExt = pkgs.php74.override {
    extensions = phpExtensions;
  };

  php82WithExt = pkgs.php82.override {
    extensions = phpExtensions;
  };
in {
  services.phpfpm = {
    enable = true;

    poolConfigs = {
      php56 = {
        package = php56WithExt;
        user = "nginx";
        group = "nginx";
        listen = "/run/php-fpm56.sock";
        listenOwner = "nginx";
        listenGroup = "nginx";
        phpOptions = ''
          pm = dynamic
          pm.max_children = 5
          pm.start_servers = 2
          pm.min_spare_servers = 1
          pm.max_spare_servers = 3
        '';
      };

      php74 = {
        package = php74WithExt;
        user = "nginx";
        group = "nginx";
        listen = "/run/php-fpm74.sock";
        listenOwner = "nginx";
        listenGroup = "nginx";
        phpOptions = ''
          pm = dynamic
          pm.max_children = 10
          pm.start_servers = 4
          pm.min_spare_servers = 2
          pm.max_spare_servers = 6
        '';
      };

      php82 = {
        package = php82WithExt;
        user = "nginx";
        group = "nginx";
        listen = "/run/php-fpm82.sock";
        listenOwner = "nginx";
        listenGroup = "nginx";
        phpOptions = ''
          pm = dynamic
          pm.max_children = 20
          pm.start_servers = 8
          pm.min_spare_servers = 4
          pm.max_spare_servers = 12
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    php56WithExt.composer
    php74WithExt.composer
    php82WithExt.composer
  ];
}

