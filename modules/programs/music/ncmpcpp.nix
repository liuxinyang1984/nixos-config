# modules/programs/music/ncmpcpp.nix
{ config, pkgs, ... }:

{
  programs.ncmpcpp = {
    enable = true;
    settings = {
      mpd_host = "localhost";
      mpd_port = "6600";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      user_interface = "classic";
    };
  };
}

