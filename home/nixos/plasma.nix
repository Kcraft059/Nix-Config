{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    home-config.plasma.enable = lib.mkEnableOption ''Enable Plasma configuration and its plugins'';
  };

  config = lib.mkIf config.home-config.plasma.enable {
    # Stylix overrides
    stylix.targets = {
      #gtk.enable = false;
      kde.enable = false;
      qt.enable = false;
    };

    # Plasma configuration
    programs.plasma = {
      enable = true;

      ## Theming
      workspace = {
        lookAndFeel = "org.kde.breezedark.desktop";
        theme = "breeze-dark";
        cursor = {
          theme = "breeze_cursors";
          size = 20;
        };
        soundTheme = "ocean";
        wallpaper = "${config.home-config.desktopManager.wallpaper}";
      };

      fonts = {
        general = {
          family = "JetBrains Mono";
          pointSize = 12;
        };
      };

      desktop.widgets = [
        {
          "org.kde.plasma.digitalclock" = {
            config.Appearance.showDate = false;
          };
          position = {
            horizontal = 51;
            vertical = 100;
          };
          size = {
            height = 250;
            width = 250;
          }
        }
      ];

      /*
        hotkeys.commands."launch-konsole" = {
             name = "Launch Konsole";
             key = "Meta+Alt+K";
             command = "konsole";
           };
      */
    };
  };
}
