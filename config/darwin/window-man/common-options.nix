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
    "Stickies"
  ];

  quit-all-apps = "${pkgs.writeShellScriptBin "quit-all-apps" ''
    apps=$(osascript -e 'tell application "System Events" to get name of every application process whose background only is false' | sed 's/, /,/g')

    IFS=',' read -r -a app_list <<< "$apps"

    for app in "''${app_list[@]}"; do
        if [[ "$app" != "Finder" ]]; then
            echo "Quitted $app"
            killall "$app"
        fi
    done
  ''}/bin/quit-all-apps";

  shutdown = "${pkgs.writeShellScriptBin "shutdown" ''
    osascript -e 'tell app "loginwindow" to «event aevtrsdn»'
  ''}/bin/shutdown";

  restart = "${pkgs.writeShellScriptBin "restart" ''
    osascript -e 'tell app "loginwindow" to «event aevtrrst»'
  ''}/bin/restart";

  screensaver = "/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine";

  stickies-toggle = "${pkgs.writeShellScriptBin "stickies-toggle" ''
    if pid=$(pgrep Stickies); then
      kill -9 $pid
    else
      open -a /System/Applications/Stickies.app
    fi
  ''}/bin/stickies-toggle";

  stickies-new = "${pkgs.writeShellScriptBin "stickies-new" ''
    osascript -e '
      tell application "Stickies" to activate
      tell application "System Events" to tell process "Stickies"
        repeat until menu "File" of menu bar 1 exists
          delay 0.02
        end repeat
        click menu item "New Note" of menu "File" of menu bar 1
        
        set frontmost to true
      end tell'
  ''}/bin/stickies-new";

  stickies-clipboard = "${pkgs.writeShellScriptBin "stickies-clipboard" ''
    osascript -e '
      tell application "Stickies" to activate
      tell application "System Events" to tell process "Stickies"
        repeat until menu "File" of menu bar 1 exists
          delay 0.02
        end repeat
        click menu item "New Note" of menu "File" of menu bar 1

        set frontmost to true

		    repeat until menu "Edit" of menu bar 1 exists
		    	delay 0.02
		    end repeat
		    click menu item "Paste" of menu "Edit" of menu bar 1
      end tell'
  ''}/bin/stickies-clipboard";

  stickies-clear = "${pkgs.writeShellScriptBin "stickies-clear" ''
    osascript -e 'tell application "System Events" to tell process "Stickies"
      try
        set frontmost to true
      on error -- the Stickie app is not running
        return
      end try

      repeat until menu "File" of menu bar 1 exists
        delay 0.02
      end repeat

      set windowCount to (count windows)
      repeat with i from windowCount to 1 by -1
        perform action "AXRaise" of window 1
        click menu item "Close" of menu "File" of menu bar 1
        try
          click button "Delete Note" of window 1
        end try
      end repeat
    end tell'
  ''}/bin/stickies-clear";

  # Visual
  global-padding = 6;
  window-padding = 4;
  barHeight = if config.home-manager.users.camille.programs.sketchybar.enable then 38 else 0;
}
