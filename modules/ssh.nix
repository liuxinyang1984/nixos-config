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

  networking.firewall.allowedTCPPorts = [ 22 ]; # 开放 SSH 端口
}

