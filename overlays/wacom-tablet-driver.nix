{ pkgs, lib, ... }:
pkgs.stdenv.mkDerivation {
  pname = "wacom-tablet-driver";
  version = "5.3.7-6";

  src = pkgs.fetchurl {
    url = "https://github.com/thenickdude/wacom-driver-fix/releases/download/patch-10-bamboo/Install.Wacom.Tablet-5.3.7-6-patched.pkg";
    sha256 = "sha256-NSuGUcTYndz459UjTZEs+SlO3W6nDXVVbV6bWXnSVFI=";
  };

  unpackPhase = ''
    /usr/sbin/pkgutil --expand-full $src ./pkg
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mkdir -p $out/Library

    cp -r ./pkg/content.pkg/Payload/Applications/Pen\ Tablet.localized/Pen\ Tablet\ Utility.app/ $out/Applications/
    cp -r ./pkg/content.pkg/Payload/Library $out/
  '';

  meta.platforms = lib.platforms.darwin;
}
