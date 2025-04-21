{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nixos-system.stylix.enable = mkEnableOption ''Desktop manager wide theme'';
  };

  config = {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    stylix.image = ../../ressources/ign_colorful.png;
  };
}
