{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    stylix.targets.alacritty.enable = false;
    programs.alacritty = {
      enable = config.home-config.GUIapps.enable;
      settings = {
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

        # [THEME DEPENDENT]
        general = {
          import = [ "${pkgs.alacritty-theme}/share/alacritty-theme/rose_pine_moon.toml" ];
        };
      };
    };
  };
}

/* theme.toml
  [colors.primary]
  background = '#232136'
  foreground = '#e0def4'

  [colors.cursor]
  text = '#e0def4'
  cursor = '#56526e'

  [colors.vi_mode_cursor]
  text = '#e0def4'
  cursor = '#56526e'

  [colors.selection]
  text = '#e0def4'
  background = '#44415a'
  [colors.normal]
  black = '#393552'
  red = '#eb6f92'
  green = '#3e8fb0'
  yellow = '#f6c177'
  blue = '#9ccfd8'
  magenta = '#c4a7e7'
  cyan = '#ea9a97'
  white = '#e0def4'

  [colors.bright]
  black = '#6e6a86'
  red = '#eb6f92'
  green = '#3e8fb0'
  yellow = '#f6c177'
  blue = '#9ccfd8'
  magenta = '#c4a7e7'
  cyan = '#ea9a97'
  white = '#e0def4'

  [colors.hints]
  start = { foreground = '#908caa', background = '#2a273f' }
  end = { foreground = '#6e6a86', background = '#2a273f' }
*/
