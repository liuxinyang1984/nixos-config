# modules/ssh.nix
{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";         # 允许 root 登录
    passwordAuthentication = false;  # 禁止密码登录（建议使用密钥）
  };

  networking.firewall.allowedTCPPorts = [ 22 ]; # 开放 SSH 端口
}
