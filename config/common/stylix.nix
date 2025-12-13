{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    common.stylix.enable = lib.mkEnableOption ''Desktop manager wide theme'';
    common.stylix.wallpaper = lib.mkOption {
      type = lib.types.path;
      default = "";
      example = lib.literalExpression ''/ressources/wallpaper.png'';
      description = ''
        Set the default wallpaper
      '';
    };
  };

  config = lib.mkIf config.common.stylix.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    stylix.image = config.common.stylix.wallpaper;
  };
}
