{ pkgs, ... }:
pkgs.stdenv.mkDerivation {

  name = "libresprite-app";
  version = pkgs.libresprite.version;

  src = pkgs.emptyDirectory;
  nativeBuildInputs = [ ]; # or gcc if needed

  buildPhase =
    let
      wrapper = pkgs.libresprite.name + "-wrapper";
    in
    ''
      app_path=Applications/LibreSprite.app
      plutil=/usr/bin/plutil
      sips=/usr/bin/sips

      mkdir -p $app_path/Contents/MacOS
      mkdir -p $app_path/Contents/Resources

      ln -s ${pkgs.writeShellScriptBin "${wrapper}" ''
        ${pkgs.libresprite}/bin/libresprite
      ''}/bin/${wrapper} $app_path/Contents/MacOS/
      $sips -s format icns ${pkgs.libresprite}/share/libresprite/data/icons/ase64.png -z 128 128 \
        --out $app_path/Contents/Resources/AppIcon.icns

      $plutil -create xml1 $app_path/Contents/Info.plist
      $plutil -insert CFBundleName -string "${pkgs.libresprite.name}" $app_path/Contents/Info.plist
      $plutil -insert CFBundleDisplayName -string "${pkgs.libresprite.name}" $app_path/Contents/Info.plist
      $plutil -insert CFBundleIdentifier -string "org.nixos.${pkgs.libresprite.name}" $app_path/Contents/Info.plist
      $plutil -insert CFBundleVersion -string "${pkgs.libresprite.version}" $app_path/Contents/Info.plist
      $plutil -insert CFBundleExecutable -string "${wrapper}" $app_path/Contents/Info.plist
      $plutil -insert CFBundleIconFile -string "AppIcon" $app_path/Contents/Info.plist
      $plutil -insert CFBundlePackageType -string "APPL" $app_path/Contents/Info.plist
      $plutil -insert NSPrincipalClass -string "NSApplication" $app_path/Contents/Info.plist
    '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r Applications/ $out/
  '';
}
