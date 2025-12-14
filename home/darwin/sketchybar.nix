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
        wifi-unredactor
      ];

    };
    xdg.configFile = {
      "sketchybar/dyn-icon_map.sh".source = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
      "sketchybar/config.sh".text = ''
        MUSIC_INFO_WIDTH=100
        #MENUBAR_AUTOHIDE=False
        MENU_CONTROLS=(
        	"Control__Center,Bluetooth"
        	"Control__Center,FocusModes"
        )
        LOG_LEVEL=none
      '';
    };
    #home.sessionVariables.SKETCHYBAR_CONFIG = "$HOME/.config/sketchybar/local-config.sh";
  };
}
