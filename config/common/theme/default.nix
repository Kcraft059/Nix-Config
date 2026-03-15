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
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable common theming support";
    };

    wallpaper = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = lib.literalExpression "./resources/wallpaper.png";
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
                orange = mkOption { type = types.nullOr types.str; }; # Orange being non-standard, it is nullable
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
                orange = mkOption { type = types.nullOr types.str; }; # Orange being non-standard, it is nullable
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
      type = types.submodule {
        options = {
          package = mkOption {
            type = types.nullOr types.package;
            default = null;
            description = "VSCode theme package";
          };
          name = mkOption {
            type = types.str;
            default = "";
            description = "VSCode theme name";
          };
        };
      };
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

      hexToDecMap = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };

      pow =
        base: exponent:
        let
          inherit (lib) mod;
        in
        if exponent > 1 then
          let
            x = pow base (exponent / 2);
            odd_exp = mod exponent 2 == 1;
          in
          x * x * (if odd_exp then base else 1)
        else if exponent == 1 then
          base
        else if exponent == 0 && base == 0 then
          throw "undefined"
        else if exponent == 0 then
          1
        else
          throw "undefined";

      base16To10 = exponent: scalar: scalar * pow 16 exponent;

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
      stylix = {
        enable = mkDefault config.common.theme.enable;
      }
      // lib.optionalAttrs config.common.theme.enable {
        base16Scheme = mkDefault base16_scheme; # "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
        image = mkDefault config.common.theme.wallpaper;
      };

      ## Helpers
      _module.args.themeUtils = rec {
        hexCharToDec =
          hex:
          let
            inherit (lib) toLower;
            lowerHex = toLower hex;
          in
          if builtins.stringLength hex != 1 then
            throw "Function only accepts a single character."
          else if hexToDecMap ? ${lowerHex} then
            hexToDecMap."${lowerHex}"
          else
            throw "Character ${hex} is not a hexadecimal value.";

        hexToDec =
          hex:
          let
            inherit (lib)
              stringToCharacters
              reverseList
              imap0
              foldl
              ;
            decimals = builtins.map hexCharToDec (stringToCharacters hex);
            decimalsAscending = reverseList decimals;
            decimalsPowered = imap0 base16To10 decimalsAscending;
          in
          foldl builtins.add 0 decimalsPowered;

        hexColorToHexValue = hex: builtins.substring 1 6 hex;

        hexToRGB =
          hex:
          let
            hexvalue = hexColorToHexValue hex;
          in
          [
            (hexToDec (builtins.substring 0 2 hexvalue))
            (hexToDec (builtins.substring 2 2 hexvalue))
            (hexToDec (builtins.substring 4 2 hexvalue))
          ];

        RGBtoFloatRGB = rgb: builtins.map (v: v / 255.0) rgb;
        RGBStringSep = sep: rgb: lib.concatStringsSep sep (builtins.map (v: toString v) (rgb));
      };
    };

}
