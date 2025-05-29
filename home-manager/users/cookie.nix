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
    # 添加自定义脚本
    ".local/bin/cookie-script".text = ''
      #!/bin/zsh
      echo "Hello, Cookie!"
    '';
  };
     # 引用外部 authorized_keys 文件
    ".ssh/authorized_keys".source = ../../ssh/authorized_keys;

    ".ssh".directory = {
      recursive = true;
      permissions = "0700";
    };

}
