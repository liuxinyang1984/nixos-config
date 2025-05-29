#home-manager/common.nix
{ pkgs, ... }:

{
  # 通用配置
  home.stateVersion = "23.11";
  
  # 基础软件包
  home.packages = with pkgs; [
    git curl wget
    ripgrep fzf exa bat
    htop btop ncdu
  ];

  # 基础 Git 配置
  programs.git = {
    enable = true;
    userName = "Cookie";
    userEmail = "cookie@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };
}
