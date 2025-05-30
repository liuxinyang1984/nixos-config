#modules/media.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pipewire
    pavucontrol
    pamixer        # 命令行音量控制工具
    playerctl      # 媒体播放器控制快捷键绑定
  ];
}
