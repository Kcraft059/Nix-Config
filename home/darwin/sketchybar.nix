{
  config,
  global-config,
  inputs,
  pkgs,
  lib,
  themeUtils,
  ...
}:
let
  theme = global-config.common.theme;
  clr = theme.colors;
  hcv = themeUtils.hexColorToHexValue;

  safe_theme_name = "custom_theme";

  palette_config = pkgs.writeText "sketchybar-${theme.name}.lua" ''
    ${safe_theme_name} = {
      bar = {
        background = function(tpf, tpfunc)
          return tpfunc(0x161616, 145)
        end,
        border = function(tpf, tpfunc)
          return tpfunc(0x808080, tpf - 20)
        end
      },
      text = {
        primary = 0xff${hcv clr.text.primary},
        subtle = 0xff${hcv clr.text.subtle},
        muted = 0xff${hcv clr.text.muted},
      },
      zone = {
        background = function(tpf, tpfunc)
          return tpfunc(0x${hcv clr.backgrounds.overlay}, tpf - 50)
        end,
        border = function(tpf, tpfunc)
          return tpfunc(0x${hcv clr.backgrounds.highlight_med}, tpf - 20)
        end,
        overlay = 0xff${hcv clr.backgrounds.highlight_high}
      },
      colors = {
        red = 0xff${hcv clr.colors.red},
        orange = 0xff${hcv clr.colors.cyan},
        yellow = 0xff${hcv clr.colors.yellow},
        blue = 0xff${hcv clr.colors.blue},
        cyan = 0xff${hcv clr.colors.green},
        purple = 0xff${hcv clr.colors.purple},
        black = 0xff${hcv clr.backgrounds.highlight_low}
      }
    }
  '';

in
{
  options.home-config.status-bar = {
    enable = lib.mkEnableOption "Whether to enable the Custom Menu-Bar service Service";
  };

  config = lib.mkIf config.home-config.status-bar.enable {
    home.packages = with pkgs; [
      sketchybar-app-font
      menubar-cli
      ft-haptic
    ];

    programs.sketchybar = {
      enable = true;

      service = rec {
        enable = true;
        errorLogFile = "/tmp/sketchybar.log";
        outLogFile = errorLogFile;
      };

      configType = "lua";

      config = {
        source = "${inputs.sketchybar-config}";
        recursive = true;
      };

      extraPackages = with pkgs; [
        menubar-cli
        ft-haptic
        imagemagick
        sketchybar-app-font
        nix
        yabai
      ];
    };

    launchd.agents.sketchybar.config.EnvironmentVariables =
      lib.mkIf config.home-config.status-bar.enable
        (
          lib.mkMerge [
            {
              # [THEME DEPENDENT]
              SKETCHYBAR_CONFIG = "${pkgs.writeText "sketchybar-config.lua" (
                ''
                  bd_display_groups = {
                    ["Dual External"]       = { icon = "􀨧" },
                    ["Built-in + External"] = { icon = "􂤓" },
                    ["Built-in"]            = { icon = "􁈸" }
                  }

                  controls = {
                    "Control Center,Bluetooth",
                    "Control Center,FocusModes"
                  }


                  git_key = "${global-config.sops.secrets.github-token.path}"
                ''
                + lib.optionalString theme.enable ''
                  theme = "${safe_theme_name}"
                  theme_file = "${palette_config}"
                ''
              )}";
            }
          ]
        );
  };
}
