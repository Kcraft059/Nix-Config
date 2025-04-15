self: super:
let
  packageHelper = import ./utils/app-install.nix {
    pkgs = super;
    lib = super.lib;
  };
in
{
  fancyfolder = packageHelper.installMacApp rec {
    name = "fancyfolder";
    appname = "Fancy Folder";
    version = "2.0";
    sourceRoot = "Fancy Folders.app";
    src = super.fetchurl {
      # `nix-prefetch-url https://github.com/kfreitag1/FancyFolders/releases/download/v2.0/FancyFolders.dmg`
      url = "https://github.com/kfreitag1/FancyFolders/releases/download/v${version}/FancyFolders.dmg";
      sha256 = "0idjsc5wn9rijxizyyanrg3nw4a76wdfj6ycxxzxs59phssg9wxp";
    };
    description = "A little utility to create macOS folder icons.";
    homepage = "https://github.com/kfreitag1/FancyFolders/";
  };
}
