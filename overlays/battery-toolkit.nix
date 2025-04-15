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
    version = "1.6";
    sourceRoot = "Battery Toolkit.app";
    src = super.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://github.com/mhaeuser/Battery-Toolkit/releases/download/${version}/Battery-Toolkit-${version}.zip";
      sha256 = "0gypn3adkk18hdn9z64lhdjf399gibg87mr6ymjr9dj9bssrjk8s";
    };
    description = "Monitor Battery Charging.";
    homepage = "https://github.com/mhaeuser/Battery-Toolkit/";
  };
}
