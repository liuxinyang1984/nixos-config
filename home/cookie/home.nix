# home/cookie/home.nix
{ config, pkgs, ... }:

{
  # 创建用户级别的字体配置文件
  home.file.".config/fontconfig/fonts.conf".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <!-- 设置 JetBrainsMono Nerd Font 为默认字体 -->
      <match target="pattern">
        <test name="family" qual="any">
          <string>JetBrainsMono Nerd Font</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>JetBrainsMono Nerd Font</string>
        </edit>
      </match>

      <!-- 配置中文字体为 Noto Sans Mono CJK SC -->
      <match target="pattern">
        <test name="family" qual="any">
          <string>serif</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Noto Sans Mono CJK SC</string>
        </edit>
      </match>
    </fontconfig>
  '';

  # 确保字体缓存更新
  home.sessionCommands = [
    "fc-cache -f -v"
  ];

  # 用户个性化设置（如环境变量）
  home.sessionVariables = {
    # 设置用户环境变量
    LANG = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}

