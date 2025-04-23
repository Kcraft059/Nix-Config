{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    home-config.hyprland.enable = lib.mkEnableOption ''Enable Hyprland and its plugins'';
  };

  config =
    let
      startupScript = pkgs.writeShellScriptBin "start" ''
        ${pkgs.waybar}/bin/waybar &
        ${pkgs.swww}/bin/swww-daemon & 

        sleep 1

        ${pkgs.swww}/bin/swww img ${../../ressources/ign_colorful.png} &

      '';

    in
    lib.mkIf config.home-config.hyprland.enable {

      # HyprLand

      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "${startupScript}/bin/start"
            "$terminal"
          ];
          "$terminal" = "ghostty";
          "$fileManager" = "thunar";
          source = "~/.config/hypr/rose-pine-moon.conf";
          general = {
            gaps_in = 5;
            gaps_out = 15;
            border_size = 2;
            col.active_border = "$pine $iris 45deg";
            ol.inactive_border = "$muted";
            resize_on_border = true;
            layout = "dwindle";
          };
          decoration = {
            rounding = 10;
            rounding_power = 2;
            active_opacity = 0.90;
            inactive_opacity = 0.85;
            shadow = {
              enabled = true;
              range = 4;
              render_power = 5;
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = 7;
              passes = 3;
              vibrancy = 0.1696;
            };
          };
          dwindle = {
            pseudotile = true;
            preserve_split = true;
          };
          input = {
            kb_layout = "fr";
            follow_mouse = 1;
            touchpad = {
              natural_scroll = false;
            };
          };
          gestures = {
            workspace_swipe = true;
          };
          "$mainMod" = "SUPER";
          bind = [
            "$mainMod, Q, exec, $terminal"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
          ];
        };
      };

      home.file.".config/hypr/rose-pine-moon.conf".text = ''
        $base	        = 0xff232136
        $surface        = 0xff2a273f
        $overlay        = 0xff393552
        $muted          = 0xff6e6a86
        $subtle         = 0xff908caa
        $text           = 0xffe0def4
        $love           = 0xffeb6f92
        $gold           = 0xfff6c177
        $rose           = 0xffea9a97
        $pine           = 0xff3e8fb0
        $foam           = 0xff9ccfd8
        $iris           = 0xffc4a7e7
        $highlightLow   = 0xff2a283e
        $highlightMed   = 0xff44415a
        $highlightHigh  = 0xff56526e
      '';
      home.file.".config/hypr/ign_coloful.png".source = ../../ressources/ign_colorful.png;

      # Hyprpaper

      home.packages = [
        pkgs.swww
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

      # Plugins / gui programs/menus

      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      };
      /*
        programs.thunar = {
          enable = true;
          plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
          ];
        };
      */
    };
}
