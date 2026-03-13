{ lib, config, ... }:
let
  inherit (lib) mkDefault mkOption types;
in
{
  imports = [
    ./stylix.nix
  ];

  /* options.common.theme = {
    wallpaper = mkOption {
      type = types.path;
      default = "";
      example = lib.literalExpression ''./ressources/wallpaper.png'';
      description = "Wallpaper";
    };
    colors = mkOption {
      type = types.attrs;
      default = { };
      description = "Global color palette";
    };
  };

  options.darwin.theme = {
    enclosureNumber = mkOption {
      type = types.int;
      default = 0;
      description = "Set the macos enclosureNumber (0 will act as not set)";
    };
  };

  config = {
    stylix.enable = mkDefault true;
    stylix.image = mkDefault config.common.theme.wallpaper;
  }; */
}
