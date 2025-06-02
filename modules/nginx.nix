# modules/nginx.nix
{ self,config, pkgs, lib, ... }:

let
  # nginxConf = "${self}/etc/nginx/nginx.conf";
  customNginxConf = builtins.readFile "${self}/etc/nginx/nginx.conf";
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
  services.nginx = {
    enable = true;
    
    # 直接让 NixOS 用你写好的 nginx.conf：
    httpConfig = ''
    include /etc/nginx/sites-enabled/*.conf;
  '';
  };
  # environment.etc."nginx/nginx.conf".source = nginxConf;

  systemd.services.nginx.serviceConfig = {
    ProtectHome = lib.mkForce "no";
    ProtectSystem = lib.mkForce "off";
    ReadWritePaths = lib.mkForce "/www";
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
}

