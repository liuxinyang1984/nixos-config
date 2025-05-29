#home-manager/core.nix
{ pkgs, ... }:

{
  # 基础 Home Manager 配置
  home.stateVersion = "23.11";
  home.username = "cookie";
  home.homeDirectory = "/home/cookie";

  # 通用软件包
  home.packages = with pkgs; [
    bat exa fzf ripgrep
    nodejs python3
  ];
}
