# Add Package
self: super:
let
  packageHelper = import ./utils/app-install.nix {
    pkgs = super;
    lib = super.lib;
  };
in
{
  krita-mac = packageHelper.installMacApp rec {
    name = "krita-mac";
    appname = "Krita";
    version = "5.2.11";
    sourceRoot = "Krita.app";
    src = super.fetchurl {
      url = "https://download.kde.org/stable/krita/${version}/krita-${version}.dmg";
      sha256 = "0ix1ffcrc3qab8rdlns7n5iwlapryh8rsg27cj92jzh1dijl7163";
    };
    description = "Free and open source painting application";
    homepage = "https://krita.org/";
  };
}
