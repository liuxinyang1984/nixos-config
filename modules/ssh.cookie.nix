{ config, lib, pkgs, ... }:

{
  users.users.cookie.openssh.authorizedKeys.keyFiles = [
    ../etc/ssh/authorized_keys
  ];
}
