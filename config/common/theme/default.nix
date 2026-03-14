{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkOption types;
in
{
  # Feature list:
  # Colors (including accent), name, theme (dark/light), wallpaper, vs-extension

  options.common.theme = {
    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = lib.literalExpression "./ressources/wallpaper.png";
      description = "Wallpaper";
    };

    theme = mkOption {
      type = types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = "System global theme";
    };

    name = mkOption {
      type = types.str;
      default = "Custom Theme";
      description = "Theme name";
    };

    colors = mkOption {
      type = types.submodule {
        options = {
          accent = mkOption { type = types.str; };
          text = mkOption {
            type = types.submodule {
              options = {
                primary = mkOption { type = types.str; };
                subtle = mkOption { type = types.str; };
                muted = mkOption { type = types.str; };
              };
            };
          };
          colors = mkOption {
            type = types.submodule {
              options = {
                # Primarly based on ainsi 16-bit colors
                red = mkOption { type = types.str; };
                green = mkOption { type = types.str; };
                yellow = mkOption { type = types.str; };
                blue = mkOption { type = types.str; };
                purple = mkOption { type = types.str; };
                cyan = mkOption { type = types.str; };
              };
            };
          };
          colors_variant = mkOption {
            type = types.submodule {
              options = {
                # Primarly based on ainsi 16-bit colors
                red = mkOption { type = types.str; };
                green = mkOption { type = types.str; };
                yellow = mkOption { type = types.str; };
                blue = mkOption { type = types.str; };
                purple = mkOption { type = types.str; };
                cyan = mkOption { type = types.str; };
              };
            };
          };
          backgrounds = mkOption {
            type = types.submodule {
              options = {
                # In increasing order of brightness
                base = mkOption { type = types.str; };
                surface = mkOption { type = types.str; };
                overlay = mkOption { type = types.str; };
                highlight_low = mkOption { type = types.str; };
                highlight_med = mkOption { type = types.str; };
                highlight_high = mkOption { type = types.str; };
              };
            };
          };
        };
      };
    };

    vs-theme = mkOption {
      type = types.nullOr types.package;
      default = null;
      description = "VSCode theme package";
    };

    darwin = mkOption {
      type = types.submodule {
        options = {
          accent = mkOption {
            type = types.int;
            default = 0;
            description = "macOS Color accent >=9 will be custom hardware accent, see ref in readme";
          };
        };
      };
    };
  };

  config =
    let
      cfg = config.common.theme;

      base16_scheme = {
        system = "base16";
        name = cfg.name;

        base00 = cfg.colors.backgrounds.base;
        base01 = cfg.colors.backgrounds.surface;
        base02 = cfg.colors.backgrounds.overlay;
        base03 = cfg.colors.text.muted;
        base04 = cfg.colors.text.subtle;
        base05 = cfg.colors.text.primary;
        base06 = cfg.colors.text.primary;
        base07 = cfg.colors.backgrounds.highlight_high;
        base08 = cfg.colors.colors.red;
        base09 = cfg.colors.colors.yellow;
        base0A = cfg.colors.colors.cyan;
        base0B = cfg.colors.colors.blue;
        base0C = cfg.colors.colors.green;
        base0D = cfg.colors.colors.purple;
        base0E = cfg.colors.colors.yellow;
        base0F = cfg.colors.backgrounds.highlight_low;
      };
    in
    {
      stylix.enable = mkDefault true;
      stylix.base16Scheme = mkDefault base16_scheme; # "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
      stylix.image = mkDefault config.common.theme.wallpaper;

      _module.args.themeUtils = {
        is_light = config.common.theme.theme == "light";
        debug = value: passdown: builtins.trace "${toString value}" passdown;
      };
    };

}
