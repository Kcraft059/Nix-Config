{
  pkgs,
  config,
  lib,
  ...
}:

let
  common = import ./common-options.nix { inherit config pkgs; };

  # Enabling options
  enable-yabai = common.enable-yabai && common.enable-wm;

  # Behaviour options
  non-managed-apps-config = lib.concatStringsSep "\n" (
    builtins.map (name: "yabai -m rule --add app=\"^${name}$\" manage=off") common.non-managed-apps
  );

  # Visual options
  global-padding = common.global-padding;
  barHeight = common.barHeight;

  # Final eval
  yabai-final-config = non-managed-apps-config + "\n";
in
{
  config = {
    services.yabai = {

      enable = enable-yabai;
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
        external_bar = "all:${toString barHeight}:0"; # Only add if sketchybar
        top_padding = global-padding;
        bottom_padding = global-padding;
        left_padding = global-padding;
        right_padding = global-padding;
        window_gap = global-padding;
      };

      extraConfig =
        # Adds additionnal config
        yabai-final-config + ''
          yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
          sudo yabai --load-sa
          #borders active_color=0xffc4a7e7 hidpi=on width=4.0 &
        '';
    };
  };
}
