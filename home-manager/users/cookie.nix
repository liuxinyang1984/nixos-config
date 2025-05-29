#home-manager/users/cookie.nix
{ pkgs, ... }:

{
  imports = [
    ../../modules/neovim.nix  # Neovim 配置
    ../../modules/zsh.nix     # Zsh 配置
  ];

  # 用户专属设置
  home.username = "cookie";
  home.homeDirectory = "/home/cookie";

  home.stateVersion = "23.05";  # 必须设置，匹配你NixOS版本
  # 个人软件包
  home.packages = with pkgs; [
    # 开发工具
    nodejs python3 go rustc
    
    # 系统工具
    duf dust procs
    
    # 图形应用
    firefox vscode
  ];
  
  # 自定义文件
  home.file = {
    ".ssh/authorized_keys".source = ../ssh/authorized_keys;
  };
}
