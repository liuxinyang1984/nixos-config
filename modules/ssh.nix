# modules/ssh.nix
{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "yes";         # 允许 root 登录
      PasswordAuthentication = false;  # 禁止密码登录（建议使用密钥）
    };
  };

  # root用户公钥文件
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./../etc/ssh/authorized_keys
  ];
  # cookie用户公钥文件
  users.users.cookie.openssh.authorizedKeys.keyFiles = [
    ./../etc/ssh/authorized_keys
  ];

  networking.firewall.allowedTCPPorts = [ 22 ]; # 开放 SSH 端口
}

