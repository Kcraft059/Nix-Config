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
      gtk.enable = false;
      kde.enable = false;
      qt.enable = false;
    };

    # Plasma configuration
    programs.plasma = {
      enable = true;

      ## Theming
      configFile.kdeglobals.General.AccentColor = "116,118,168";

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

      ## Ui effects
      configFile.kwinrc.Plugins.slidebackEnabled = true;
      configFile.kwinrc.Plugins.translucencyEnabled = true;
      configFile.kwinrc."Effect-translucency" = {
        Inactive = 90;
        MoveResize = 95;
      };

      ## Ui elements
      panels = [
        {
          location = "top";
          floating = true;
          height = 30;
          opacity = "translucent";
          widgets = [
            ## App launcher 
            { 
              kickoff = {
                sortAlphabetically = true;
                icon = "nix-snowflake-white";
              };
            }

            ## Workspaces
            {
              name = "org.kde.plasma.pager";
              config.General.showWindowIcons = true;
            }

            "org.kde.plasma.marginsseparator"
            
            "org.kde.plasma.appmenu"

            "org.kde.plasma.marginsseparator"
          ];
        }
        {
          location = "bottom";
          hiding = "autohide";
          lengthMode = "fit";
          opacity = "translucent";
          floating = true;
          widgets = [
            {
              iconTasks = {
                launchers = [
                  "applications:org.kde.dolphin.desktop"
                  "applications:org.kde.konsole.desktop"
                  "file://${lib.traceValFn (v: "HM-Path: ${v}") config.home.profileDirectory}"
                ];
              };
            }
          ];
        }
      ];

      desktop.widgets = [
        {
          name = "org.kde.plasma.analogclock";
          config.General.showSecondHand = true;

          position = {
            horizontal = 1080;
            vertical = 0;
          };
          size = {
            height = 175;
            width = 175;
          };
        }
      ];

      ## Behaviour
      kwin.virtualDesktops.names = [
        "Desktop 1"
        "Desktop 2"
        "Desktop 3"
      ];

      /*
        hotkeys.commands."launch-konsole" = {
             name = "Launch Konsole";
             key = "Meta+Alt+K";
             command = "konsole";
           };
      */
    };

    home.file.".face.icon".source = config.home-config.userPicture;
  };
}
