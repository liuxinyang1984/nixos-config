# modules/system/timezone.nix
{ config, pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";  # 设置时区为北京时间
}
