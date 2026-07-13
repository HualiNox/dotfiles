{
  lib,
  appimageTools,
  fetchurl,
  fontconfig,
  libxshmfence,
  makeFontsConf,
  noto-fonts,
  noto-fonts-color-emoji,
  runCommand,
  source-han-sans,
  wqy_microhei,
  writeText,
}:

let
  pname = "YesPlayMusic";
  version = "0.4.10";

  fontPackages = [
    noto-fonts
    noto-fonts-color-emoji
    source-han-sans
    wqy_microhei
  ];

  fontPreferences = writeText "yesplaymusic-font-preferences.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <match target="pattern">
        <test qual="any" name="family">
          <string>ui-sans-serif</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Source Han Sans SC</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>system-ui</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Source Han Sans SC</string>
        </edit>
      </match>

      <match target="pattern">
        <test qual="any" name="family">
          <string>sans-serif</string>
        </test>
        <edit name="family" mode="prepend" binding="strong">
          <string>Source Han Sans SC</string>
        </edit>
      </match>

      <alias>
        <family>ui-sans-serif</family>
        <prefer>
          <family>Source Han Sans SC</family>
          <family>WenQuanYi Micro Hei</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>

      <alias>
        <family>system-ui</family>
        <prefer>
          <family>Source Han Sans SC</family>
          <family>WenQuanYi Micro Hei</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>

      <alias>
        <family>sans-serif</family>
        <prefer>
          <family>Source Han Sans SC</family>
          <family>WenQuanYi Micro Hei</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Sans</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  fontsConf = runCommand "yesplaymusic-fonts.conf" { } ''
    cp ${
      makeFontsConf {
        fontDirectories = fontPackages;
        includes = [
          "/etc/fonts/conf.d"
          fontPreferences
        ];
      }
    } $out
  '';

  src = fetchurl {
    url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-${version}.AppImage";
    hash = "sha256-Qj9ZQbHqzKX2QBlXWtey/j/4PqrCJCObdvOans79KW4=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs:
    [
      fontconfig
      libxshmfence
    ]
    ++ fontPackages;

  profile = ''
    export FONTCONFIG_FILE=${fontsConf}
  '';

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/yesplaymusic.desktop \
      $out/share/applications/yesplaymusic.desktop
    substituteInPlace $out/share/applications/yesplaymusic.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=YesPlayMusic %U'

    mkdir -p $out/share
    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "A third party music application for Netease Music";
    homepage = "https://github.com/qier222/YesPlayMusic";
    license = lib.licenses.mit;
    mainProgram = "YesPlayMusic";
    platforms = [ "x86_64-linux" ];
  };
}
