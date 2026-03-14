{
  inputs,
  pkgs,
  lib,
  themeUtils,
  config,
  global-config,
  ...
}:
let
  theme = global-config.common.theme;
  safe_theme_name = "custom_theme";

  sketchybar-theme = import ../configs/sketchybar-theme.nix {
    inherit theme themeUtils safe_theme_name;
  };
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
                # [THEME DEPENDENT]
                + lib.optionalString theme.enable ''
                  theme = "${safe_theme_name}"
                  theme_file = "${pkgs.writeText "sketchybar-${theme.name}.lua" sketchybar-theme}"
                ''
              )}";
            }
          ]
        );
  };
}
