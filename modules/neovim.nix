#modules/neovim.nix
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    # 自定义配置文件
    extraConfig = builtins.readFile ./../home-manager/neovim/init.vim;
    
    # 插件管理
    plugins = [ pkgs.vimPlugins.vim-plug ];

  };

  # 部署自定义配置文件
  home.file = {
    # Neovim 主配置
    ".config/nvim/init.vim".source = ./../home-manager/neovim/init.vim;
  };
  # 确保 Neovim 是默认编辑器
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
