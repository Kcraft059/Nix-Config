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

  # [THEME DEPENDENT]
  config = lib.mkIf config.common.stylix.enable {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    stylix.image = config.common.stylix.wallpaper;
  };
}
/* Base 16 Scheme (for auto-generation)
system: "base16"
name: "Rosé Pine Moon"
author: "Emilia Dunfelt <edun@dunfelt.se>"
slug: "rose-pine-moon"
variant: "dark"
palette:
  base00: "#232136"
  base01: "#2a273f"
  base02: "#393552"
  base03: "#6e6a86"
  base04: "#908caa"
  base05: "#e0def4"
  base06: "#e0def4"
  base07: "#56526e"
  base08: "#eb6f92"
  base09: "#f6c177"
  base0A: "#ea9a97"
  base0B: "#3e8fb0"
  base0C: "#9ccfd8"
  base0D: "#c4a7e7"
  base0E: "#f6c177"
  base0F: "#56526e"
*/