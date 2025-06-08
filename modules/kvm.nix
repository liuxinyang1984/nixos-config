{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    spice-gtk
    dnsmasq
    libguestfs
  ];

  virtualisation.libvirtd.enable = true;

  services.dbus.enable = true;

  security.polkit.enable = true;
}

