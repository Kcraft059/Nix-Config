{
  pkgs,
  lib,
  config,
  global-config,
  ...
}:
let
  theme = global-config.common.theme;

  alacritty-theme = import ./configs/alacritty-theme.nix { inherit theme;  };
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
            import = [ (pkgs.writeText "alacritty-${theme.name}.toml" alacritty-theme) ];
          };
        }
      );
    };
  };
}
