{
  pkgs,
  lib,
  config,
  ...
}:
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
  config =
    let
      diskPath = config.home-config.external-drive.path;
      diskEnable = config.home-config.external-drive.enable;

      linkedDirs = [
        "Developper"
        "Documents"
        "Movies"
        "Nix-Config"
        "Pictures"
      ];

      linkedHomeFiles =
        lib.genAttrs linkedDirs (name: {
          source = config.lib.file.mkOutOfStoreSymlink "${diskPath}/camille/${name}";
        })
        // {
          "Library/Containers/com.isaacmarovitz.Whisky".source = config.lib.file.mkOutOfStoreSymlink "${diskPath}/camille/Apps-Data/Whisky";
          "Library/Application Support/PrismLauncher".source = config.lib.file.mkOutOfStoreSymlink "${diskPath}/camille/Apps-Data/Prism";
        };
    in
    lib.mkIf diskEnable {
      home.file = linkedHomeFiles;
    };
}
