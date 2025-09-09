{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    common.stylix.enable = lib.mkEnableOption ''Desktop manager wide theme'';
  };

  config = lib.mkIf config.common.stylix.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    stylix.image = ../../ressources/Lake_Aurora.png;
  };
}
