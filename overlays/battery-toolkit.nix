# Add Package
self: super:
let
  packageHelper = import ./utils/app-install.nix {
    pkgs = super;
    lib = super.lib;
  };
in
{
  battery-toolkit = packageHelper.installMacApp rec {
    name = "battery-toolkit";
    appname = "Battery Toolkit";
    version = "1.7";
    sourceRoot = "Battery Toolkit.app";
    src = super.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://github.com/mhaeuser/Battery-Toolkit/releases/download/${version}/Battery-Toolkit-${version}.zip";
      sha256 = "0lgrmw8gnbfcancn40z67h05r3qh14d6lyj2h8mw9nbv8sg7yn45";
    };
    description = "Monitor Battery Charging.";
    homepage = "https://github.com/mhaeuser/Battery-Toolkit/";
  };
}
