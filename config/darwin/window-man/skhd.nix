{
  pkgs,
  lib,
  config,
  ...
}:
let
  common = import ./common-options.nix { inherit config pkgs; };

  # Behaviour options
  super = common.modifiers.super;
  mod = common.modifiers.mod;
  ctrl = common.modifiers.ctrl;
  shift = common.modifiers.shift;

  yabai = "${pkgs.yabai}/bin/yabai";
  yabai-config = lib.optionalString common.enable-yabai ''
    # === Spaces Management ===
    ${super} + ${ctrl} - up : sh -c '${yabai} -m space --create; ${yabai} -m space --focus "$(${yabai} -m query --spaces | jq "[.[] | select(.display == ($(${yabai} -m query --displays --display | jq .index))) ] | max_by(.index).index")"'
    ${super} + ${ctrl} - down : ${yabai} -m space --destroy
    ${super} + ${ctrl} - right : ${yabai} -m space --move next
    ${super} + ${ctrl} - left : ${yabai} -m space --move prev

    # === Window Management ===
    ${super} - up : ${yabai} -m window --focus north
    ${super} - down : ${yabai} -m window --focus south
    ${super} - right : ${yabai} -m window --focus east
    ${super} - left : ${yabai} -m window --focus west

    # Swap
    ${super} + ${mod} - up : ${yabai} -m window --swap north
    ${super} + ${mod} - down : ${yabai} -m window --swap south
    ${super} + ${mod} - right : ${yabai} -m window --swap east
    ${super} + ${mod} - left : ${yabai} -m window --swap west

    # Warp
    ${super} + ${shift} - up : ${yabai} -m window --warp north
    ${super} + ${shift} - down : ${yabai} -m window --warp south
    ${super} + ${shift} - right : ${yabai} -m window --warp east
    ${super} + ${shift} - left : ${yabai} -m window --warp west

    # Toggles
    ${super} - return : ${yabai} -m window --toggle float
    ${super} + ${shift} - return : ${yabai} -m window --toggle sticky

    # Move to Spaces
    ${ctrl} + ${shift} - right : sh -c '${yabai} -m window --space next; ${yabai} -m space --focus next'
    ${ctrl} + ${shift} - left : sh -c '${yabai} -m window --space prev; ${yabai} -m space --focus prev'
    ${ctrl} + ${shift} + ${mod} - right : sh -c '${yabai} -m window --display east; ${yabai} -m display --focus east'
    ${ctrl} + ${shift} + ${mod} - left : sh -c '${yabai} -m window --display west; ${yabai} -m display --focus west'

    # === Layout Management ===
    ${super} + ${mod} - k : ${yabai} -m space --rotate 270
    ${super} + ${mod} - j : ${yabai} -m space --rotate 90
    ${super} + ${mod} - m : ${yabai} -m space --layout bsp
    ${super} + ${mod} - f : ${yabai} -m space --layout float
  '';

  aerospace = "${pkgs.aerospace}/bin/aerospace";
  aerospace-config = lib.optionalString common.enable-aerospace ''
    # === Window Focus ===
    ${super} - left : ${aerospace} focus --boundaries-action wrap-around-the-workspace left
    ${super} - down : ${aerospace} focus --boundaries-action wrap-around-the-workspace down
    ${super} - up : ${aerospace} focus --boundaries-action wrap-around-the-workspace up
    ${super} - right : ${aerospace} focus --boundaries-action wrap-around-the-workspace right

    ${super} + ${ctrl} - j : ${aerospace} focus --boundaries-action wrap-around-the-workspace dfs-next
    ${super} + ${ctrl} - k : ${aerospace} focus --boundaries-action wrap-around-the-workspace dfs-prev

    # === Window Movement ===
    ${super} + ${mod} + ${shift} - up : ${aerospace} swap --swap-focus --wrap-around left
    ${super} + ${mod} + ${shift} - down : ${aerospace} swap --swap-focus --wrap-around down
    ${super} + ${mod} + ${shift} - left : ${aerospace} swap --swap-focus --wrap-around up
    ${super} + ${mod} + ${shift} - right : ${aerospace} swap --swap-focus --wrap-around right

    ${super} + ${mod} - up : ${aerospace} move up
    ${super} + ${mod} - down : ${aerospace} move down
    ${super} + ${mod} - left : ${aerospace} move left
    ${super} + ${mod} - right : ${aerospace} move right

    # === Workspace Switching ===
          
    ${super} + ${ctrl} - right : ${aerospace} workspace next
    ${super} + ${ctrl} - left : ${aerospace} workspace prev
    ${super} + ${ctrl} + ${shift} - right : ${aerospace} move-node-to-workspace --focus-follows-window next
    ${super} + ${ctrl} + ${shift} - left : ${aerospace} move-node-to-workspace --focus-follows-window prev

    # ${super} - 1 : ${aerospace} workspace 1
    # ${super} - 2 : ${aerospace} workspace 2
    # ${super} - 3 : ${aerospace} workspace 3
    # ${super} - 4 : ${aerospace} workspace 4
    # ${super} - 5 : ${aerospace} workspace 5
    # ${super} - 6 : ${aerospace} workspace 6
    # ${super} - 7 : ${aerospace} workspace 7
    # ${super} - 8 : ${aerospace} workspace 8
    # ${super} - 9 : ${aerospace} workspace 9

    # ${super} + ${shift} - 1 : ${aerospace} move-node-to-workspace --focus-follows-window 1
    # ${super} + ${shift} - 2 : ${aerospace} move-node-to-workspace --focus-follows-window 2
    # ${super} + ${shift} - 3 : ${aerospace} move-node-to-workspace --focus-follows-window 3
    # ${super} + ${shift} - 4 : ${aerospace} move-node-to-workspace --focus-follows-window 4
    # ${super} + ${shift} - 5 : ${aerospace} move-node-to-workspace --focus-follows-window 5
    # ${super} + ${shift} - 6 : ${aerospace} move-node-to-workspace --focus-follows-window 6
    # ${super} + ${shift} - 7 : ${aerospace} move-node-to-workspace --focus-follows-window 7
    # ${super} + ${shift} - 8 : ${aerospace} move-node-to-workspace --focus-follows-window 8
    # ${super} + ${shift} - 9 : ${aerospace} move-node-to-workspace --focus-follows-window 9

    # === Layout Management ===
    ${super} - e : ${aerospace} layout horizontal
    ${super} - v : ${aerospace} layout vertical

    ${super} + ${shift} - t : ${aerospace} layout tiles horizontal vertical
    ${super} + ${shift} - s : ${aerospace} layout accordian horizontal vertical

    # === Window Actions ===
    ${super} - f : ${aerospace} fullscreen
    ${super} + ${shift} - space : ${aerospace} layout floating tiling
    ${super} + ${shift} - q : ${aerospace} close

    # === Window Resizing ===
    ${ctrl} + ${super} - h : ${aerospace} resize smart -50
    ${ctrl} + ${super} - l : ${aerospace} resize smart +50
    ${ctrl} + ${super} - j : ${aerospace} resize smart-opposite +50
    ${ctrl} + ${super} - k : ${aerospace} resize smart-opposite -50
    ${super} - 0 : ${aerospace} balance-sizes
  '';

  skhd-final-conf = yabai-config + aerospace-config;

in
{
  services.skhd = {
    enable = common.enable-wm;
    skhdConfig = skhd-final-conf + ''
      # App launch
      ctrl + cmd + alt - t : open /Applications/Ghostty.app
      ctrl + cmd + alt - q : ${common.quit-all-apps}/bin/quit-all-apps
      cmd + alt - escape : ${common.shutdown}/bin/shutdown
      cmd + ctrl - escape : ${common.restart}/bin/restart
    '';
  };
}
