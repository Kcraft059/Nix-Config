{ pkgs, config, ... }:
{
  ### Shared window-manager config

  # Enable cases
  enable-wm = config.darwin-system.window-man.enable;
  enable-yabai = config.darwin-system.window-man.type == "yabai";
  enable-aerospace = config.darwin-system.window-man.type == "aerospace";
  enable-rift = config.darwin-system.window-man.type == "rift";

  # Behaviour
  modifiers = {
    super = "ralt";
    mod = "cmd";
    shift = "shift";
    ctrl = "ctrl";
  };

  non-managed-apps = [
    "System Settings"
    "Ice"
    "wine64 pre-loader"
    "LuLu"
    "Fancy Folder"
    "Alcove"
    "Raycast"
    "DockDoor"
  ];

  quit-all-apps = pkgs.writeShellScriptBin "quit-all-apps" ''
    #!bin/bash

    apps=$(osascript -e 'tell application "System Events" to get name of every application process whose background only is false' | sed 's/, /,/g')

    IFS=',' read -r -a app_list <<< "$apps"

    for app in "''${app_list[@]}"; do
        if [[ "$app" != "Finder" ]]; then
            echo "Quitted $app"
            killall "$app"
        fi
    done
  '';

  # Visual
  global-padding = 6;
  barHeight = if config.home-manager.users.camille.programs.sketchybar.enable then 38 else 0;
}
