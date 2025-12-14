{ pkgs, lib, ... }:
pkgs.stdenv.mkDerivation rec {

  name = "ft-haptic";
  version = "1.0";

  src = ./src/ft-haptic; # Or fetchFromGitHub if remote

  nativeBuildInputs = [ pkgs.clang ]; # or gcc if needed

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ft-haptic $out/bin/
  '';
}
