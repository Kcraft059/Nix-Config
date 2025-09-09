self: super:
let
  packageHelper = import ./utils/app-install.nix {
    pkgs = super;
    lib = super.lib;
  };
in
{
  backdrop-app = packageHelper.installMacApp rec {
    name = "backdrop-app";
    appname = "Backdrop";
    version = "1.0";
    sourceRoot = "Backdrop.app";
    src = super.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://cdn.cindori.com/apps/backdrop/Backdrop.dmg";
      sha256 = "1bm1d7gqrkwyf823xm1d80b7wksfcyvw905wc9n1m77mq633nvgh";
    };
    description = "Wallpapper engine for macos.";
    homepage = "https://cindori.com/backdrop";
  };
}