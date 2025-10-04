{ inputs }:
self: super:
{
  wifi-unredactor =
    with super;
    stdenv.mkDerivation rec {
      name = "wifi-unredactor";
      appname = "wifi-unredactor";
      version = "1.0";
      sourceRoot = ".";
      src = inputs.wifi-unredactor;
      description = "Workaround for redacted wifi-ssid";
      homepage = "https://github.com/noperator/wifi-unredactor/";

      nativeBuildInputs = [ swift ];

      phases = [
        "unpackPhase" # Necessary to deploy $src in ./source
        "buildPhase"
        "installPhase"
      ];

      buildPhase = ''
        APP_NAME="wifi-unredactor"
        APP_DIR="$APP_NAME.app"
        MACOS_DIR="$APP_DIR/Contents/MacOS"
        SOURCE_FILE="$MACOS_DIR/$APP_NAME.swift"
        EXECUTABLE="$MACOS_DIR/$APP_NAME"

        cd ./source

        /usr/bin/swiftc -o "$EXECUTABLE" "$SOURCE_FILE" -framework Cocoa -framework CoreLocation -framework CoreWLAN

        if [ $? != 0 ]; then 
          exit 1
        fi
        
        rm "$MACOS_DIR/wifi-unredactor.swift"

        cd ..

      '';

      installPhase = ''
        mkdir -p "$out/Applications/"
        mkdir -p "$out/bin/"
        cp -pR ./source/${appname}.app "$out/Applications/"
        
        cat <<EOF > "$out/bin/wifi-unredactor"
        #!/bin/bash
        $out/Applications/${appname}.app/Contents/MacOS/wifi-unredactor
        EOF

        chmod +x "$out/bin/wifi-unredactor"
      '';

      meta = with lib; {
        description = description;
        homepage = homepage;
        maintainers = with maintainers; [ Kcraft059 ];
        platforms = platforms.darwin;
      };
    };
}
