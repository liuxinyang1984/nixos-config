# modules/programs/music/tools.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    metaflac
    shntool
    # 可在此处添加更多音乐相关工具
  ];
}

