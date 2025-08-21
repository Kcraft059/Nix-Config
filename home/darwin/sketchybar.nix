{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.darwin-system.status-bar.enable {
    home.packages = with pkgs; [
      sketchybar-app-font
    ];
    programs.sketchybar = {
      enable = true;
      configType = "bash";
      config = {
        source = ./sketchybar;
        recursive = true;
      };
      extraPackages = with pkgs; [
        yabai
      ];
    };
    xdg.configFile = {
      "sketchybar/icon_map.sh".source = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
    };
  };
}
