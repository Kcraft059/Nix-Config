{ pkgs, lib, ... }:
pkgs.stdenv.mkDerivation {

  name = "palera1n";
  version = "1.0";

  src = pkgs.fetchurl {
    url = "https://github.com/palera1n/palera1n/releases/download/v2.3/palera1n-macos-arm64";
    hash = "sha256-8hSkaXjO07ZqslVf9RaB8hvxP9l9W2kqpCCkumpx0mM=";
  }; # Or fetchFromGitHub if remote

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/palera1n
    chmod +x $out/bin/palera1n
  '';

  meta.platforms = lib.platforms.darwin;
}
