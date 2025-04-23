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

  config = lib.mkIf config.hyprland.enable {

    # HyprLand

    wayland.windowManager.hyprland = {
      enable = true;
    };

    # Hyprpaper
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "/home/camille/.config/hypr/ign_colorful.png" ];
        wallpaper = [ "monitor,/home/camille/.config/hypr/ign_colorful.png" ];
      };
    };

    home.file.".config/hypr/ign_coloful.png".source = ../../ressources/ign_colorful.png;

    # Plugins / gui programs/menus

    /* programs.waybar = {
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
    }; */
  };
}
