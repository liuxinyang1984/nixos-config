## 分区
```shell
fdisk /dev/vda
n
+256M
n
w
mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda2
```

## 挂载
```shell
mount /dev/vda2 /mnt
mkdir -p /mnt/boot/efi
mount /dev/vda1 /mnt/boot/efi
```

## 安装
```shell
sudo nixos-install --root /mnt --flake /home/nixos/nixos-config#NixOs
```

