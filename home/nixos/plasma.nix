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
      panels =
        let
          lenSpacer = len: {
            name = "org.kde.plasma.panelspacer";
            config.General = {
              expanding = false;
              length = len;
            };
          };
          spacer = "org.kde.plasma.panelspacer";
        in
        [
          {
            location = "top";
            floating = true;
            hiding = "windowsbelow";
            height = 30;
            opacity = "translucent";
            widgets = [
              ## App launcher
              (lenSpacer 5)
              {
                kickoff = {
                  sortAlphabetically = true;
                  icon = "nix-snowflake-white";
                };
              }
              ## Workspaces
              (lenSpacer 5)
              {
                name = "org.kde.plasma.pager";
                config.General.showWindowIcons = true;
              }
              "org.kde.plasma.marginsseparator"
              (lenSpacer 8)
              ## Appname
              {
                applicationTitleBar = {
                  behavior = {
                    activeTaskSource = "activeTask";
                  };
                  layout = {
                    elements = [
                      "windowIcon"
                      "windowTitle"
                    ];
                    horizontalAlignment = "left";
                    showDisabledElements = "deactivated";
                    verticalAlignment = "center";
                  };
                  windowTitle = {
                    font = {
                      bold = false;
                      fit = "fixedSize";
                      size = 12;
                    };
                    hideEmptyTitle = true;
                    source = "appName";
                  };
                };
              }
              {
                name = "org.kde.plasma.appmenu";
                config.Appearance.compactView = true;
              }
              spacer
              ## Controls
              "org.kde.plasma.marginsseparator"
              {
                systemTray.items = {
                  shown = [
                    "org.kde.plasma.volume"
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.bluetooth"
                  ];
                  hidden = [
                    "org.kde.plasma.battery"
                    "org.kde.kscreen"
                  ];
                };
              }
              "org.kde.plasma.marginsseparator"
              {
                name = "org.kde.plasma.digitalclock";
              }
              (lenSpacer 5)
            ];
          }
          {
            location = "bottom";
            hiding = "dodgewindows";
            lengthMode = "fit";
            opacity = "translucent";
            floating = true;
            widgets = [
              {
                iconTasks = {
                  launchers = [
                    "applications:systemsettings.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "file://${config.home.profileDirectory}/share/applications/Alacritty.desktop"
                    "file://${config.home.profileDirectory}/share/applications/code.desktop"
                    "file://${config.home.profileDirectory}/share/applications/firefox.desktop"
                  ];
                };
              }
              (lenSpacer 5)
              "org.kde.plasma.trash"
            ];
          }
        ];

      desktop.widgets = [
        {
          name = "org.kde.plasma.analogclock";
          config.General.showSecondHand = true;

          position = {
            horizontal = 1920 - (builtins.elemAt config.programs.plasma.desktop.widgets 0).size.width;
            vertical = (builtins.elemAt config.programs.plasma.panels 0).height + 10;
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
