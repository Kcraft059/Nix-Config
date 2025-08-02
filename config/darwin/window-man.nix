{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    services.yabai = {
      enable = config.darwin-system.window-man.enable;
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
        window_animation_duration = 0.22;

        menubar_opacity = 0.75;
        external_bar = lib.optionalString config.services.sketchybar.enable "all:36:0"; # Only add if sketchybar
        top_padding = 8;
        bottom_padding = 8;
        left_padding = 8;
        right_padding = 8;
        window_gap = 8;
      };
      extraConfig = ''
        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^Ice$" manage=off
        yabai -m rule --add app="^wine64 pre-loader$" manage=off
        yabai -m rule --add app="^LuLu$" manage=off
        yabai -m rule --add app="^Fancy Folder$" manage=off
        yabai -m rule --add app="^Alcove$" manage=off
        yabai -m rule --add app="^Raycast$" manage=off
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        #borders active_color=0xffc4a7e7 hidpi=on width=4.0 &
        sudo yabai --load-sa
      '';
    };
    services.skhd = {
      enable = config.darwin-system.window-man.enable;
      skhdConfig = ''
        # Spaces Management 
        ctrl + ralt - up : sh -c 'yabai -m space --create; yabai -m space --focus "$(yabai -m query --spaces | jq "[.[] | select(.display == ($(yabai -m query --displays --display | jq .index))) ] | max_by(.index).index")"'
        ctrl + ralt - down : yabai -m space --destroy
        ctrl + ralt - right : yabai -m space --move next
        ctrl + ralt - left : yabai -m space --move prev

        # Window Management
        ralt - up : yabai -m window --focus north
        ralt - down : yabai -m window --focus south
        ralt - right : yabai -m window --focus east
        ralt - left : yabai -m window --focus west
        # Swap
        cmd + ralt - up : yabai -m window --swap north
        cmd + ralt - down : yabai -m window --swap south
        cmd + ralt - right : yabai -m window --swap east
        cmd + ralt - left : yabai -m window --swap west
        # Warp
        shift + ralt - up : yabai -m window --warp north
        shift + ralt - down : yabai -m window --warp south
        shift + ralt - right : yabai -m window --warp east
        shift + ralt - left : yabai -m window --warp west
        # Toggles
        ralt - return : yabai -m window --toggle float
        shift + ralt - return : yabai -m window --toggle sticky
        # Move to Spaces
        shift + ctrl - right : sh -c 'yabai -m window --space next; yabai -m space --focus next'
        shift + ctrl - left : sh -c 'yabai -m window --space prev; yabai -m space --focus prev'
        shift + cmd + ctrl - right : sh -c 'yabai -m window --display east; yabai -m display --focus east'
        shift + cmd + ctrl - left : sh -c 'yabai -m window --display west; yabai -m display --focus west'

        # Current Space Management
        cmd + ralt - k : yabai -m space --rotate 270
        cmd + ralt - j : yabai -m space --rotate 90
        cmd + ralt - m : yabai -m space --layout bsp
        cmd + ralt - f : yabai -m space --layout float

        # App launch
        ctrl + cmd + alt - t : open /Applications/Ghostty.app
      '';
    };
    services.sketchybar = {
      enable = config.darwin-system.status-bar.enable;
      config = builtins.concatStringsSep "\n" [
        (builtins.readFile ./configs/sketchy/colors.sh)
        (builtins.readFile ./configs/sketchy/icon_map.sh)
        (builtins.readFile ./configs/sketchy/add_separator.sh)
        (builtins.readFile ./configs/sketchy/sketchybarrc)
        (builtins.readFile ./configs/sketchy/sketchy-items/logo.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/spaces.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/frontapp.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/menus.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/calendar.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/mic.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/volume.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/battery.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/wifi.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/display.sh)
        (builtins.readFile ./configs/sketchy/sketchy-items/controls.sh)
        (builtins.readFile ./configs/sketchy/sketchyset.sh)
      ];
    };
    environment.systemPackages =
      /*
        lib.optionals config.darwin-system.window-man.enable [
          pkgs.jankyborders
        ] ++
      */
      lib.optionals config.services.sketchybar.enable [
        pkgs.menubar-cli
      ];
    fonts.packages = lib.optionals config.services.sketchybar.enable [
      pkgs.sketchybar-app-font
    ];
  };
}
