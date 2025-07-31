{ pkgs, lib, ... }:
{
  installMacApp = # Works Both with DMG and ZIPS
    {
      name,
      appname ? name,
      version,
      src,
      description,
      homepage,
      postInstall ? "",
      sourceRoot ? ".",
      ...
    }:
    with pkgs;
    stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      src = src;
      buildInputs = [
        unzip
      ];
      sourceRoot = sourceRoot;
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      unpackCmd = ''
        echo "File to unpack: $curSrc"
        if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
        mnt=$(mktemp -d -t ci-XXXXXXXXXX)

        function finish {
          echo "Detaching $mnt"
          /usr/bin/hdiutil detach $mnt -force
          rm -rf $mnt
        }
        trap finish EXIT

        echo "Attaching $mnt"
        /usr/bin/hdiutil attach -nobrowse -readonly $src -mountpoint $mnt

        echo "What's in the mount dir"?
        ls -la $mnt/

        echo "Copying contents"
        shopt -s extglob
        DEST="$PWD"
        (cd "$mnt"; cp -a !(Applications) "$DEST/")
      '';
      installPhase =
        ''
          mkdir -p "$out/Applications/${appname}.app"
          cp -pR * "$out/Applications/${appname}.app"
        ''
        + postInstall;
      meta = with lib; {
        description = description;
        homepage = homepage;
        maintainers = with maintainers; [ Kcraft059 ];
        platforms = platforms.darwin;
      };
    };

}
