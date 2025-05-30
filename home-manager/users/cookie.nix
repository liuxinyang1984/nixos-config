#home-manager/users/cookie.nix
{ pkgs, lib, ... }:  # Add 'lib' here

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
  # 正确设置 authorized_keys
  home.file.".ssh/authorized_keys".text = ''
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCp77mmBodrgy0DZ3aTAC9pQmBJIZYLAM0NmsTFmRxSkXd7PWQKwWCVrQevVo7mCZ5zDWN/Um26VpbCEoML3Boa7S3IKdL9N3wReQ7IIqZ0F2pAL8lPREsnLmlBu50+aDR1HlWdOuUO6bbbLnAbvvVEnyhX/AJOJRcfK2E9EcFoILOvXkjHtWW6/zXiDljeEn2BD4tJvYLWsj8rfR1c81qf1znjHgX7kxpqKUS+vvcw1y4MPDpkRQkhnwf/rFxb8eFd027bVrwfWHNkV6bc0HyganUbTCQZC92KG7o5XUJ29jwgWiUtC86WqJGFxEd8FMWBFQuLGZS52/5hoqCbSdi8wkp15zwzUkrR2QQl2NXCjwnnGRikVLD+Sj2BXuZm8/hNxc53ZMoT3xJcj4q1aEMdes0oEVMMUlAtwYbmYFR0OXQOAnxWEmq5Q4D7kW3OtgwE0DlDaczbuXIKqI9BRvW6Ldm6yz5O/kQPPJi62VGJbpcKs0Qmh8hhOYlw3R+2f38= Mr.Cookie@Arch.ZerbarBox
'';
home.file.".testfile".text = "hello\n";

# 更新文件权限
home.activation.fixSshPerms = lib.hm.dag.entryAfter ["writeBoundary"] ''
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
'';
}
