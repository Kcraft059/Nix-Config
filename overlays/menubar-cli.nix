{ pkgs, lib, ... }:
pkgs.stdenv.mkDerivation rec {

  name = "menubar-cli";
  version = "1.0";

  src = ./src/menubar-cli; # Or fetchFromGitHub if remote

  nativeBuildInputs = [ pkgs.clang ]; # or gcc if needed

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/menubar $out/bin/
  '';
}
