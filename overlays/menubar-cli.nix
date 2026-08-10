{ pkgs, lib, ... }:
pkgs.stdenv.mkDerivation {

  name = "menubar-cli";
  version = "2.2";

  src = ./src/menubar-cli; # Or fetchFromGitHub if remote

  nativeBuildInputs = [ pkgs.clang ]; # or gcc if needed

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/menubar $out/bin/
  '';

  meta.platforms = lib.platforms.darwin;
}
