{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    programs.alacritty = {
      enable = config.home-config.GUIapps.enable;
      settings = lib.mkForce {
        font.size = 12;
        font.normal = {
          family = "JetBrainsMono Nerd Font";
        };
        general = {
          import = [ "${pkgs.alacritty-theme}/share/alacritty-theme/rose_pine_moon.toml" ];
        };
      };
    };
  };
}
