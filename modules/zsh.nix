#modules/zsh.nix
{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # 设置默认 shell 的别名
    shellAliases = {
      vim = "nvim";
      ls = "exa --icons --group-directories-first";
      ll = "exa -l --icons --group-directories-first --git";
      lt = "exa --tree --icons --group-directories-first";
      cat = "bat";
    };

    # 使用 powerlevel10k 主题（不依赖 oh-my-zsh）
    initContent = ''
      # 启用 powerlevel10k
      if [[ -r "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme" ]]; then
        source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"
      fi

      # 引入 p10k 的配置文件
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # 自定义额外配置
      source ~/.zsh_aliases
    '';
  };

  # 安装 powerlevel10k 主题包
  home.packages = [ pkgs.zsh-powerlevel10k ];

  # 部署 p10k 配置文件
  home.file.".p10k.zsh".source = ./../home-manager/zsh/.p10k.zsh;

  # 部署自定义 alias 文件
  home.file.".zsh_aliases".source = ./../home-manager/zsh/aliases.zsh;
}

