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
        #${pkgs.swww}/bin/swww-daemon & 
        #sleep 1
        #${pkgs.swww}/bin/swww img ${../../ressources/ign_colorful.png} &
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
          "$applauncher" = "rofi";
          "$fileManager" = "thunar";
          #source = "~/.config/hypr/rose-pine-moon.conf";
          general = {
            gaps_in = 5;
            gaps_out = 15;
            border_size = 2;
            "col.active_border" = lib.mkDefault "$pine $iris 45deg";
            "col.inactive_border" = lib.mkDefault "$muted";
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
              color = lib.mkDefault "rgba(1a1a1aee)";
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
            "$mainMod, Q, exec, $terminal "
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, SPACE, exec, $applauncher -show drun"
          ];
          animations = {
            enabled = "yes";
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1.0"
              "quick,0.15,0,0.1,1"
            ];
            animation = [
              "global, 1, 10, default"
              "border, 1, 5.39, easeOutQuint"
              "windows, 1, 4.79, easeOutQuint"
              "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
              "windowsOut, 1, 1.49, linear, popin 87%"
              "fadeIn, 1, 1.73, almostLinear"
              "fadeOut, 1, 1.46, almostLinear"
              "fade, 1, 3.03, quick"
              "layers, 1, 3.81, easeOutQuint"
              "layersIn, 1, 4, easeOutQuint, fade"
              "layersOut, 1, 1.5, linear, fade"
              "fadeLayersIn, 1, 1.79, almostLinear"
              "fadeLayersOut, 1, 1.39, almostLinear"
              "workspaces, 1, 1.94, almostLinear, fade"
              "workspacesIn, 1, 1.21, almostLinear, fade"
              "workspacesOut, 1, 1.94, almostLinear, fade"
            ];
            layerrule = [
              "blur, waybar" # Add blur to waybar
              "blurpopups, waybar" # Blur waybar popups too!
              "ignorealpha 0.2, waybar" # Make it so transparent parts are ignored
            ];
          };
        };
      };

      /*
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
      */
      home.file.".config/hypr/ign_coloful.png".source = ../../ressources/ign_colorful.png;

      # Plugins and Menu Items

      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [ "/home/camille/.config/hypr/ign_colorful.png" ];
          wallpaper = [ "monitor,/home/camille/.config/hypr/ign_colorful.png" ];
        };
      };

      programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
        style = lib.mkForce (builtins.readFile ../configs/waybar-style.css); # Using mkForce for stylix
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            mod = "dock";
            exclusive = true;
            gtk-layer-shell = true;
            margin-bottom = -1;
            passthrough = false;
            height = 30;
            modules-left = [
              "custom/os_button"
              "hyprland/workspaces"
            ];
            "modules-center" = [
              "wlr/taskbar"
              "clock"
             ];
            "modules-right" = [
              "cpu"
              "temperature"
              "memory"
              "disk"
              "tray"
              "pulseaudio"
              "network"
              "battery"
              "hyprland/language"
            ];

            "hyprland/language" = {
              format = "{}";
              format-en = "ENG";
              format-ru = "РУС";
            };

            "hyprland/workspaces" = {
              icon-size = 22;
              spacing = 16;
              on-scroll-up = "hyprctl dispatch workspace r+1";
              on-scroll-down = "hyprctl dispatch workspace r-1";
            };

            "custom/os_button" = {
              format = "";
              on-click = "wofi --show drun";
              tooltip = false;
            };

            cpu = {
              interval = 5;
              format = "  {usage}%";
              max-length = 10;
            };

            temperature = {
              hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
              input-filename = "temp2_input";
              critical-threshold = 75;
              tooltip = false;
              format-critical = "({temperatureC}°C)";
              format = "({temperatureC}°C)";
            };

            disk = {
              interval = 30;
              format = "󰋊 {percentage_used}%";
              path = "/";
              tooltip = true;
              unit = "GB";
              tooltip-format = "Available {free} of {total}";
            };

            memory = {
              interval = 10;
              format = "  {percentage}%";
              max-length = 10;
              tooltip = true;
              tooltip-format = "RAM - {used:0.1f}GiB used";
            };

            "wlr/taskbar" = {
              format = "{icon} {title:.17}";
              icon-size = 28;
              spacing = 3;
              on-click-middle = "close";
              tooltip-format = "{title}";
              ignore-list = [ ];
              on-click = "activate";
            };

            tray = {
              icon-size = 18;
              spacing = 3;
            };

            clock = {
              format = "{:%R %d.%m.%Y}";
              tooltip-format = "<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "year";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='#ffead3'><b>{}</b></span>";
                  days = "<span color='#ecc6d9'><b>{}</b></span>";
                  weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                  weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                  today = "<span color='#ff6699'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-click-forward = "tz_up";
                on-click-backward = "tz_down";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };

            network = {
              format-wifi = " {icon}";
              format-ethernet = "  ";
              format-disconnected = "󰌙";
              format-icons = [
                "󰤯 "
                "󰤟 "
                "󰤢 "
                "󰤢 "
                "󰤨 "
              ];
            };

            battery = {
              states = {
                good = 95;
                warning = 30;
                critical = 20;
              };
              format = "{icon} {capacity}%";
              format-charging = " {capacity}%";
              format-plugged = " {capacity}%";
              format-alt = "{time} {icon}";
              format-icons = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };

            pulseaudio = {
              max-volume = 150;
              scroll-step = 10;
              format = "{icon}";
              tooltip-format = "{volume}%";
              format-muted = " ";
              format-icons.default = [
                " "
                " "
                " "
              ];
              on-click = "pwvucontrol";
            };

          };
        };
      };

      programs.rofi = {
        enable = true;
      };

      programs.wofi = {
        enable = true;
      };

      /*
        home.packages = [
          pkgs.swww
        ];
      */
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
