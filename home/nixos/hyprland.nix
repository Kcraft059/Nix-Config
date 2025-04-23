{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption ''Enable Hyprland and its plugins'';
  };

  config =
    let
      startupScript = pkgs.pkgs.writteShellScriptBin "start" ''
        ${pkgs.waybar}/bin/waybar &
        ${pkgs.swww}/bin/swww-daemon & 

        sleep 1

        ${pkgs.swww}/bin/swww img ${../../ressources/ign_colorful.png} &

      '';

    in
    lib.mkIf config.hyprland.enable {

      # HyprLand

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = ''${startupScript}/bin/start'';
        };
      };

      # Hyprpaper

      home.packages = [
        swww
      ];
      /*
        services.hyprpaper = {
          enable = true;
          settings = {
            preload = [ "/home/camille/.config/hypr/ign_colorful.png" ];
            wallpaper = [ "monitor,/home/camille/.config/hypr/ign_colorful.png" ];
          };
        };
      */

      home.file.".config/hypr/ign_coloful.png".source = ../../ressources/ign_colorful.png;

      # Plugins / gui programs/menus

      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      };
      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
    };
}
