{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    services.yabai = lib.mkIf config.darwin-system.window-man.enable {
      enable = true;
      enableScriptingAddition = true; # `sudo nvram boot-args="-arm64e_preview_abi"`
      config = {
        layout = "bsp";
        focus_follows_mouse = "off";
        mouse_follows_focus = "on";
        window_placement = "second_child";

        #window_shadow = "float";
        # Appearance
        window_opacity = "on";
        active_window_opacity = 1.0;
        normal_window_opacity = 0.90;
        insert_feedback_color = "0xff3e8fb0";
        window_opacity_duration = 0.15;
        window_border_width = 2;
        window_border_hidpi = "off";
        window_border_radius = 11;
        window_animation_duration = 0.22;
        active_window_border_color = "0xffe1e3e4";
        normal_window_border_color = "0xff2a2f38";

        menubar_opacity = 0.5;
        external_bar = lib.optionalString config.services.sketchybar.enable "all:36:0"; # Only add if sketchy_bar
        top_padding = 8;
        bottom_padding = 8;
        left_padding = 8;
        right_padding = 8;
        window_gap = 8;
      };
      extraConfig = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
      '';
    };
    services.skhd = lib.mkIf config.darwin-system.window-man.enable {
      enable = true;
      skhdConfig = ''
        ctrl + ralt - up : sh -c 'yabai -m space --create; yabai -m space --focus last'
        ctrl + ralt - down : yabai -m space --destroy
        ctrl + ralt - right : yabai -m space --move next
        ctrl + ralt - left : yabai -m space --move prev
        cmd + ralt - up : yabai -m window --swap north
        cmd + ralt - down : yabai -m window --swap south
        cmd + ralt - right : yabai -m window --swap east
        cmd + ralt - left : yabai -m window --swap west
        shift + ralt - up : yabai -m window --warp north
        shift + ralt - down : yabai -m window --warp south
        shift + ralt - right : yabai -m window --warp east
        shift + ralt - left : yabai -m window --warp west
        ralt - return : yabai -m window --toggle float
        shift + ralt - return : yabai -m window --toggle sticky
        cmd + ralt - j : yabai -m space --rotate 270
        cmd + ralt - k : yabai -m space --rotate 90
        ralt - up : yabai -m window --focus north
        ralt - down : yabai -m window --focus south
        ralt - right : yabai -m window --focus east
        ralt - left : yabai -m window --focus west
      '';
    };
    services.sketchybar = lib.mkIf config.darwin-system.status-bar.enable {
      enable = true;
      config = (builtins.readFile ./configs/sketchybarrc);
    };
  };
}

/*
  services.aerospace = {
        enable = false;
        settings = {
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;
          accordion-padding = 30;
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
          automatically-unhide-macos-hidden-apps = false;
          gaps = {
            outer.left = 8;
            outer.bottom = 8;
            outer.top = 8;
            outer.right = 8;
            inner.horizontal = 8;
            inner.vertical = 8;
          };
          mode.main.binding =
            let
              wbinds = [
                {
                  s = "1";
                  w = "1";
                }
                {
                  s = "2";
                  w = "2";
                }
                {
                  s = "3";
                  w = "3";
                }
                {
                  s = "4";
                  w = "4";
                }
                {
                  s = "5";
                  w = "5";
                }
              ];
            in
            builtins.listToAttrs (
              (builtins.map (x: {
                name = "alt-${x.s}";
                value = "workspace ${x.w}";
              }) wbinds)
              ++ (builtins.map (x: {
                name = "alt-shift-${x.s}";
                value = "move-node-to-workspace ${x.w}";
              }) wbinds)
            )
            // {
              alt-j = "focus left";
              alt-k = "focus down";
              alt-i = "focus up";
              alt-l = "focus right";
              ctrl-alt-shift-j = [
                "join-with left"
                "mode main"
              ];
              ctrl-alt-shift-k = [
                "join-with down"
                "mode main"
              ];
              ctrl-alt-shift-i = [
                "join-with up"
                "mode main"
              ];
              ctrl-alt-shift-l = [
                "join-with right"
                "mode main"
              ];
              alt-shift-j = "move left";
              alt-shift-k = "move down";
              alt-shift-i = "move up";
              alt-shift-l = "move right";
              alt-slash = "layout tiles horizontal vertical"; # ( + = )
              alt-comma = "layout accordion horizontal vertical"; # ( . ; )
              alt-tab = "workspace-back-and-forth";
              ctrl-alt-cmd-esc = "enable off";
            };
        };
      };
*/
