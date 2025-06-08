# modules/nvidia.nix
{ config, pkgs, ... }:

{
  # 修复Steam启动失败的关键配置
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # 关键：32位程序支持
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [  # 关键：32位OpenGL库
      libva
      nvidia-vaapi-driver
    ];
  };

  # 环境变量修复
  environment.variables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # 修复Vulkan加载问题
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";
  };

  # NVIDIA基础配置
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 内核参数
  boot.kernelParams = ["nvidia-drm.modeset=1"];

  # 添加必要的工具包
  environment.systemPackages = with pkgs; [
    vulkan-tools
    vulkan-loader
    libva-utils
  ];

  # 修复Steam运行时问题
  hardware.steam-hardware.enable = true;
}
