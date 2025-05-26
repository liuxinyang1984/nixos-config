# modules/programs/music/mpd.nix
{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.home.homeDirectory}/.config/mpd/playlists";
    dbFile = "${config.xdg.dataHome}/mpd/db";
    logFile = "${config.xdg.dataHome}/mpd/log";
    pidFile = "${config.xdg.runtimeDir}/mpd/pid";
    stateFile = "${config.xdg.dataHome}/mpd/state";
    stickerFile = "${config.xdg.dataHome}/mpd/sticker.sql";
  };
}

