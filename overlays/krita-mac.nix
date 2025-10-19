{ pkgs, lib, ... }:
let
  packageHelper = import ./utils/app-install.nix { inherit pkgs lib; };
in
packageHelper.installMacApp rec {
  name = "krita-mac";
  appname = "Krita";
  version = "5.2.11";
  sourceRoot = "Krita.app";
  src = pkgs.fetchurl {
    url = "https://download.kde.org/stable/krita/${version}/krita-${version}.dmg";
    sha256 = "0ix1ffcrc3qab8rdlns7n5iwlapryh8rsg27cj92jzh1dijl7163";
  };
  description = "Free and open source painting application";
  homepage = "https://krita.org/";
}
