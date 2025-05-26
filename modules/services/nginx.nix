{ config, pkgs, ... }:

let
  phpConfigs = {
    php56 = ''
      location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm56.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      }
    '';
    php74 = ''
      location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm74.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      }
    '';
    php82 = ''
      location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm82.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      }
    '';
  };
in {
  services.nginx = {
    enable = true;
    package = pkgs.nginxMainline;

    # 关闭默认虚拟主机
    defaultServer = false;

    # 创建 php 配置文件
    extraConfig = ''
      # 让 nginx 支持 include /etc/nginx/php*.conf
    '';

    # 用 environment.etc 创建目录和配置文件
  };

  environment.etc = {
    "nginx/php56.conf".text = phpConfigs.php56;
    "nginx/php74.conf".text = phpConfigs.php74;
    "nginx/php82.conf".text = phpConfigs.php82;

    "nginx/sites-available/example.com".text = ''
      server {
        listen 80;
        server_name example.com;

        root /var/www/example;
        index index.php index.html;

        include /etc/nginx/php74.conf;

        location / {
          try_files $uri $uri/ =404;
        }
      }
    '';
  };

  # 激活 sites-enabled 目录和软链（用 activationScript）
  system.activationScripts.nginxSites = {
    text = ''
      mkdir -p /etc/nginx/sites-enabled
      ln -sf /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/example.com
    '';
    deps = [ "network.target" ];
  };

  services.nginx.extraConfig = ''
    include /etc/nginx/sites-enabled/*;
  '';
}

