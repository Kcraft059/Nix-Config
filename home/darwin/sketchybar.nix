{
  config,
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
    ];
    programs.sketchybar = {
      enable = true;
      service = rec {
        enable = true;
        errorLogFile = "/tmp/sketchybar.log";
        outLogFile = errorLogFile;
      };
      configType = "bash";
      config = {
        source = "${inputs.sketchybar-config}";
        recursive = true;
      };
      extraPackages = with pkgs; [
        menubar-cli
        imagemagick
        macmon
      ];

    };
    xdg.configFile = {
      "sketchybar/dyn-icon_map.sh".source = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
      "sketchybar/config.sh".text = ''
        #NOTCH_WIDTH=180
        MUSIC_INFO_WIDTH=100
        #COLOR_SCHEME="catppuccin-mocha"
      '';
    };
    #home.sessionVariables.SKETCHYBAR_CONFIG = "$HOME/.config/sketchybar/local-config.sh";
  };
}
