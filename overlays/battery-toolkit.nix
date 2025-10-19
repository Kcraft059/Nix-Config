{ pkgs, lib, ... }:
let
  packageHelper = import ./utils/app-install.nix { inherit pkgs lib; };
in
packageHelper.installMacApp rec {
    name = "battery-toolkit";
    appname = "Battery Toolkit";
    version = "1.8";
    sourceRoot = "Battery Toolkit.app";
    src = pkgs.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://github.com/mhaeuser/Battery-Toolkit/releases/download/${version}/Battery-Toolkit-${version}.zip";
      sha256 = "0152g9g255g1byqar8xsd27lkz7gdmccg8hnzcwfahb2p6hh1szk";
    };
    description = "Monitor Battery Charging.";
    homepage = "https://github.com/mhaeuser/Battery-Toolkit/";
  }
