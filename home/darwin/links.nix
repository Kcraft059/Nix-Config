{
  pkgs,
  lib,
  config,
  ...
}:
let
  external-drive = config.home-config.external-drive;

  directLinkedDirs = [
    # Directly links ${diskPath}/camille/${file} to ~/${file}
    "Developper"
    "Documents"
    "Movies"
    "Nix-Config"
    "Pictures"
  ];

  linkedDirs = {
    "Library/Containers/com.isaacmarovitz.Whisky" = "camille/Apps-Data/Whisky";
    "Library/Application Support/PrismLauncher" = "camille/Apps-Data/Prism";
  };

  linkedHomeFiles =
    lib.genAttrs directLinkedDirs (name: {
      source = config.lib.file.mkOutOfStoreSymlink "${external-drive.path}/camille/${name}";
    })
    // lib.mapAttrs' (
      name: value:
      lib.nameValuePair (name) {
        source = config.lib.file.mkOutOfStoreSymlink "${external-drive.path}/${value}";
      }
    ) linkedDirs;
in
{
  options = {
    home-config.external-drive.enable = lib.mkEnableOption "Enable linking of outside ressources";
    home-config.external-drive.path = lib.mkOption {
      type = lib.types.str;
      default = "/Volumes/Data";
      example = lib.literalExpression '''';
      description = ''
        Mount point for the shared disk
      '';
    };
  };
  
  config = {
    home.file = {
      "Library/Developer/Xcode/UserData/FontAndColorThemes".source =
        ../../ressources/XcodeThemes;
      "Library/Group Containers/UBF8T346G9.Office/User Content.localized/Themes.localized/Default Theme.potm".source =
        ../../ressources/Excel_Default.potm;
    } // lib.optionals external-drive.enable linkedHomeFiles;
  };
}
