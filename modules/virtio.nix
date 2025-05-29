#modules/virtio.nix
{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [
    "virtio_pci"
    "virtio_blk"
    "ext4"
    "vfat"
  ];
}
