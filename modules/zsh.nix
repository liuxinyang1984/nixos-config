#modules/zsh.nix
{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    
    # 使用 Powerlevel10k 主题
    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git" "sudo" "z" 
        "docker" "kubectl" "history"
      ];
    };
    
    # 自定义配置文件
    initExtra = builtins.readFile ./../home-manager/zsh/.zshrc;
  };
  
  # 部署 Powerlevel10k 配置文件
  home.file.".p10k.zsh".source = ./../home-manager/zsh/.p10k.zsh;
  
  # 部署别名文件
  home.file.".zsh_aliases".source = ./../home-manager/zsh/aliases.zsh;
  
  # 设置默认 shell
  programs.zsh.shellAliases = {
    vim = "nvim";
    ls = "exa --icons --group-directories-first";
    ll = "exa -l --icons --group-directories-first --git";
    lt = "exa --tree --icons --group-directories-first";
    cat = "bat";
  };
}
