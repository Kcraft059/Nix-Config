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
        # [THEME DEPENDENT]
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

          --theme_file = {pkgs.writeText smth}
          --theme = {global-config.common.theme.name}

          git_key = "${global-config.sops.secrets.github-token.path}"
        ''}";
      }
    ];
  };
}
/*
  themes.lua (for auto-generation)
  gruv_box = {
    bar = {
      background = function(tpf, tpfunc)
        return tpfunc(0x161616, 145)
      end,
      border = function(tpf, tpfunc)
        return tpfunc(0x808080, tpf - 20)
      end
    },
    text = {
      primary = 0xfffbf1c7,
      subtle = 0xffa89984,
      muted = 0xff7c6f64
    },
    zone = {
      background = function(tpf, tpfunc)
        return tpfunc(0x3c3836, tpf - 50)
      end,
      border = function(tpf, tpfunc)
        return tpfunc(0x665c54, tpf - 20)
      end,
      overlay = 0xff7C6f64
    },
    colors = {
      red = 0xfffb4934,
      orange = 0xfffe8019,
      yellow = 0xfffabd2f,
      blue = 0xff458588,
      cyan = 0xffb8bb26,
      purple = 0xffd3869b,
      black = 0xff000000
    }
  }
*/
