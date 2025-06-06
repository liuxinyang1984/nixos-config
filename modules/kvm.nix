{ config, pkgs, lib, ... }:

{
  options.kvm.enable = lib.mkEnableOption "Enable KVM/QEMU/libvirt virtualization stack";

  config = lib.mkIf config.kvm.enable {
    # 安装系统级虚拟化工具
    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      spice-gtk
      dnsmasq
      libguestfs
    ];

    # 启用 libvirt 服务（提供虚拟化 API）
    virtualisation.libvirtd.enable = true;

    # 启用系统所需权限服务
    services.dbus.enable = true;
    security.polkit.enable = true;
  };
}

