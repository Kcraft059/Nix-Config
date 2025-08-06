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
    version = "1.8";
    sourceRoot = "Battery Toolkit.app";
    src = super.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://github.com/user-attachments/files/21618156/Battery-Toolkit-1.8-beta.zip";
      #url = "https://github.com/mhaeuser/Battery-Toolkit/releases/download/${version}/Battery-Toolkit-${version}.zip";
      sha256 = "06ng2hzzhd74qav0ip0zyq03dn3qgi1qyr8258ibgdcwmbkya9i0";
    };
    description = "Monitor Battery Charging.";
    homepage = "https://github.com/mhaeuser/Battery-Toolkit/";
  };
}
