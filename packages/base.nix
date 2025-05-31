{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    fzf
    eza
    bat
    btop
  ];

  # 其它软件引用
  imports = [
    ../modules/ssh.nix
    ../modules/v2ray.nix
    ../modules/keyd.nix
  ];
}
