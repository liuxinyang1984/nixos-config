# hosts/NixOS/configuration.nix

# NixOS 主机配置入口文件
# - 自动导入 home-manager 配置
# - 启用 nix flakes 和 nix-command
# - 允许非自由软件（如 Chrome、NVIDIA 驱动）
# - 设置系统状态版本（影响默认行为）

{ config, lib, pkgs, ... }:

{
  # 自动加载 modules 下的所有模块，flake.nix 中已处理，无需手动 imports
  # 如果要添加 home-manager 的配置，在这里引入 home.nix
  imports = [
    # 用户 home-manager 配置路径
    ../../home/cookie/home.nix
  ];

  # 启用 nix flakes 和 nix-command
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    registry.nixpkgs.flake = pkgs;
  };

  # 允许使用非自由软件（如 Google Chrome、微软字体等）
  nixpkgs.config.allowUnfree = true;

  # 指定系统状态版本（用于决定系统服务、行为的默认值）
  system.stateVersion = "23.11";
}

