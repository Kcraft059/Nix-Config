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
        font.size = 12;
        font.normal = {
          family = "JetBrainsMono Nerd Font";
        };
        window = {
          padding = {
            x = 5;
            y = 0;
          };
          opacity = 0.85;
        };
        general = {
          import = [ "${pkgs.alacritty-theme}/share/alacritty-theme/rose_pine_moon.toml" ];
        };
      };
    };
  };
}
