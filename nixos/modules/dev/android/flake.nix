/**
  Android / LineageOS / TWRP FHS 开发环境。

  提供接近传统发行版的构建 shell，兼容 Android 老分支常见的硬编码路径与工具需求。
*/
{
  description = "Android / LineageOS / TWRP FHS build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Android 11/12 时代分支仍常用 JDK 11，避免默认 JDK 过新导致构建失败。
      java = pkgs.jdk11;

      # nixpkgs 中 repo 包名历史上出现过差异，这里兼容两种命名。
      repo =
        if pkgs ? git-repo then
          pkgs.git-repo
        else if pkgs ? gitRepo then
          pkgs.gitRepo
        else
          throw "git-repo/gitRepo not found in nixpkgs";

      # 老分支依赖的包在新 nixpkgs 中可能消失，用 null 过滤保持环境可构建。
      optionalPkgs = xs: builtins.filter (x: x != null) xs;

      # buildFHSEnv 提供 /usr、/bin 等传统路径，适配 AOSP/LineageOS 构建脚本。
      androidEnv = pkgs.buildFHSEnv {
        name = "android-env";

        targetPkgs =
          pkgs:
          with pkgs;
          optionalPkgs [
            bashInteractive
            coreutils
            findutils
            diffutils
            file
            which
            gawk
            gnused
            gnugrep

            git
            git-lfs
            repo
            gnupg
            curl
            wget
            rsync

            python3
            perl
            libxcrypt-legacy

            bc
            binutils
            bison
            flex
            gcc
            gnumake
            gperf
            m4
            pkg-config

            ccache
            schedtool
            procps
            util-linux
            nettools

            openssl
            openssl.dev
            libxml2
            libxslt
            xml2

            zip
            unzip
            lz4
            lzop
            xz
            zstd
            squashfsTools

            android-tools

            fontconfig
            freetype

            java

            # 老 Android 分支可能需要，nixpkgs 没有就自动跳过
            (if pkgs ? ncurses5 then pkgs.ncurses5 else null)
          ];

        multiPkgs =
          pkgs: with pkgs; [
            zlib
            ncurses5
          ];

        runScript = "bash";

        profile = ''
          # 允许部分 Android 构建脚本向 ninja 透传环境变量。
          export ALLOW_NINJA_ENV=true
          export ALLOW_MISSING_DEPENDENCIES=true

          export USE_CCACHE=1
          export CCACHE_DIR="$HOME/.cache/ccache-android"
          export CCACHE_EXEC=/usr/bin/ccache

          export JAVA_HOME=${java.home}
          export ANDROID_JAVA_HOME=${java.home}

        '';
      };
    in
    {
      # 同时暴露 package、app 和 devShell，兼容 nix run / nix develop 两种入口。
      packages.${system} = {
        android-env = androidEnv;
        default = androidEnv;
      };

      apps.${system} = {
        android-env = {
          type = "app";
          program = "${androidEnv}/bin/android-env";
        };

        default = {
          type = "app";
          program = "${androidEnv}/bin/android-env";
        };
      };

      devShells.${system} = {
        android = androidEnv.env;
        default = androidEnv.env;
      };
    };
}
