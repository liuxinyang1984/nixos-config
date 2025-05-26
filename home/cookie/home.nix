# home/cookie/home.nix
{ config, pkgs, ... }:

let
  neovimCfg = import ../../modules/programs/neovim/neovim.nix { inherit config pkgs; };
  mpdCfg = import ../../modules/programs/music/mpd.nix { inherit config pkgs; };
  ncmpcppCfg = import ../../modules/programs/music/ncmpcpp.nix { inherit config pkgs; };
  musicTools = import ../../modules/programs/music/tools.nix { inherit pkgs; };
in {
  home.username = "cookie";
  home.homeDirectory = "/home/cookie";

  programs.home-manager.enable = true;

  # 合并 neovim 配置
  programs.neovim = neovimCfg.programs.neovim;
  home.file = neovimCfg.home.file;

  # 合并 MPD 和 ncmpcpp 配置
  services.mpd = mpdCfg.services.mpd;
  programs.ncmpcpp = ncmpcppCfg.programs.ncmpcpp;

  # 合并音乐工具配置
  home.packages = musicTools.home.packages;

  home.stateVersion = "23.11";
}

