{
  config,
  global-config,
  inputs,
  pkgs,
  lib,
  ...
}:
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
        #source = ../../sketchybar-config;
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

    launchd.agents.sketchybar.config.EnvironmentVariables = lib.mkMerge [
      {
        SKETCHYBAR_CONFIG = "${pkgs.writeText "test" ''
          bd_display_groups = {
            ["Dual External"]       = { icon = "􀨧" },
            ["Built-in + External"] = { icon = "􂤓" },
            ["Built-in"]            = { icon = "􁈸" }
          }

          controls = {
            "Control Center,Bluetooth",
            "Control Center,FocusModes"
          }
        ''}";
      }
    ];
  };
}
