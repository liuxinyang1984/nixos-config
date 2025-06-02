# modules/edge.nix
{ config, lib, pkgs, ... }:

let
  # 更新为实际的 .deb URL 和 SHA256 哈希值
  debUrl = "https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_137.0.3296.52-1_amd64.deb";
  debSha256 = "0drxv3hdzj979qsrnxdvllxfbraq4hyacrbmxhq6a30xwrsiq15j";
in
{
  options = {
    edge.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "是否启用 Microsoft Edge 安装";
    };
  };

  config = lib.mkIf config.edge.enable {
    nixpkgs.overlays = [
      (self: super: {
        microsoft-edge = super.stdenv.mkDerivation rec {
          pname = "microsoft-edge";
          version = "stable";

          src = super.fetchurl {
            url = debUrl;
            sha256 = debSha256;
          };

          nativeBuildInputs = [
            super.dpkg
            super.autoPatchelfHook
            super.makeWrapper
          ];

          # 使用 super.xorg 访问 X11 相关库
          buildInputs = [
            super.gtk3
            super.nss
            super.alsa-lib
            super.libdrm
            super.libxkbcommon
            super.xorg.libX11
            super.xorg.libXcomposite
            super.xorg.libXdamage
            super.xorg.libXext
            super.xorg.libXfixes
            super.xorg.libXrandr
            super.xorg.libxshmfence
            super.nspr
            super.cups
            super.xorg.libxcb

            # 新增补充依赖
            super.mesa
            super.libsecret

            # qt5
            super.qt5.qtbase
            super.qt5.qttools
            super.qt5.qtsvg

            # qt6
            #super.qt6.qtbase
            #super.qt6.qtsvg
            #super.qt6.qtwayland
            #super.qt6.qt5compat
            super.kdePackages.wrapQtAppsHook
          ];

          # 修复 1: 修改解压阶段，避免设置 setuid 权限
          unpackPhase = ''
            # 使用 ar 提取 .deb 文件，避免 dpkg-deb 的权限问题
            ar p "$src" data.tar.xz | tar xJ --no-same-owner --no-same-permissions
          '';

          # 修复 2: 修改安装阶段
          installPhase = ''
            mkdir -p $out
            cp -R usr/* $out
            cp -R opt $out
            
            # 创建 bin 目录的符号链接
            mkdir -p $out/bin
            ln -s $out/opt/microsoft/msedge/msedge $out/bin/microsoft-edge
            
            # 修复库路径
            ln -s ${super.gtk3}/lib/gdk-pixbuf-2.0 $out/lib/gdk-pixbuf-2.0 || true
            
            # 修复 3: 修改包装命令
            makeWrapper $out/opt/microsoft/msedge/msedge $out/bin/.edge-wrapped \
              --prefix LD_LIBRARY_PATH : "${super.lib.makeLibraryPath buildInputs}" \
              --prefix PATH : "${super.lib.makeBinPath [ super.glib super.zenity ]}"
            
            # 覆盖原始符号链接
            ln -sf $out/bin/.edge-wrapped $out/bin/microsoft-edge
          '';

          # 修复 4: 更新 postFixup 阶段
          postFixup = ''
            # 修复桌面文件
            substituteInPlace $out/share/applications/microsoft-edge.desktop \
              --replace /usr/bin/microsoft-edge $out/bin/microsoft-edge
            
            # 修复图标
            sed -i 's|Icon=.*|Icon=microsoft-edge|' $out/share/applications/microsoft-edge.desktop
            mkdir -p $out/share/icons/hicolor/256x256/apps
            ln -s $out/share/icons/hicolor/default/apps/microsoft-edge.png $out/share/icons/hicolor/256x256/apps/ || true
            
            # 修复 5: 修复 sandbox 权限问题（Nix 安全限制）
            chmod 4755 $out/opt/microsoft/msedge/msedge-sandbox || true
          '';

          meta = with lib; {
            homepage = "https://www.microsoft.com/edge";
            description = "Microsoft Edge 浏览器";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
            maintainers = [];
          };
        };
      })
    ];

    environment.systemPackages = [ pkgs.microsoft-edge ];

    # 添加必要的环境变量
    environment.variables = {
      NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.stdenv.cc.cc.lib
        pkgs.libxkbcommon
        pkgs.libdrm
        pkgs.xorg.libxshmfence
      ];
      NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    };
  };
}
