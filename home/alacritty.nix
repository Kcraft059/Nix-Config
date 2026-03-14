{
  pkgs,
  lib,
  config,
  global-config,
  ...
}:
let
  theme = global-config.common.theme;
  clrs = theme.colors;

  theme_file = pkgs.writeText "alacritty-${theme.name}.toml" ''
    [colors.primary]
    background = '${clrs.backgrounds.base}'
    foreground = '${clrs.text.primary}'

    [colors.cursor]
    text = '${clrs.text.primary}'
    cursor = '${clrs.backgrounds.highlight_high}'

    [colors.vi_mode_cursor]
    text = '${clrs.text.primary}'
    cursor = '${clrs.backgrounds.highlight_high}'

    [colors.selection]
    text = '${clrs.text.primary}'
    background = '${clrs.backgrounds.highlight_med}'

    [colors.normal]
    black = '${clrs.backgrounds.overlay}'
    red = '${clrs.colors.red}'
    green = '${clrs.colors.green}'
    yellow = '${clrs.colors.yellow}'
    blue = '${clrs.colors.blue}'
    magenta = '${clrs.colors.purple}'
    cyan = '${clrs.colors.cyan}'
    white = '${clrs.text.primary}'

    [colors.bright]
    black = '${clrs.text.muted}'
    red = '${clrs.colors_variant.red}'
    green = '${clrs.colors_variant.green}'
    yellow = '${clrs.colors_variant.yellow}'
    blue = '${clrs.colors_variant.blue}'
    magenta = '${clrs.colors_variant.purple}'
    cyan = '${clrs.colors_variant.cyan}'
    white = '${clrs.text.primary}'

    [colors.hints]
    start = { foreground = '${clrs.text.subtle}', background = '${clrs.backgrounds.surface}' }
    end = { foreground = '${clrs.text.muted}', background = '${clrs.backgrounds.surface}' }
  '';
in
{
  config = {
    stylix.targets.alacritty.enable = false;
    
    programs.alacritty = {
      enable = config.home-config.GUIapps.enable;
      settings = (
        {
          font.size = 11;
          font.normal = {
            family = "JetBrainsMono Nerd Font";
          };
          window = {
            padding = {
              x = 5;
              y = 0;
            };
            opacity = 0.85;
            blur = true;
          };

        }
        # [THEME DEPENDENT]
        // lib.optionalAttrs theme.enable {
          general = {
            import = [ theme_file ];
            #import = [ "${pkgs.alacritty-theme}/share/alacritty-theme/rose_pine_moon.toml" ];
          };
        }
      );
    };
  };
}
