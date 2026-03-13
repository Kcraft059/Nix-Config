{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
in
{
  home.file.".config/ghostty/config".text = lib.optionalString config.home-config.GUIapps.enable (
    toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
      # [THEME DEPENDENT]
      theme = "dark:Rose Pine Moon,light:Rose Pine Dawn";
      background-blur = 15;
      background-opacity = 0.85;
      #window-step-resize = true;
      window-height = 30;
      window-width = 109;
      window-padding-x = 5;
      quit-after-last-window-closed = true;
      #macos-icon = "custom-style";
      #macos-icon-ghost-color = "#F6C177";
      #macos-icon-screen-color = "#232137";
      #keybind = global:cmd+i=change_title_prompt
      keybind = "global:cmd+opt+ctrl+space=toggle_quick_terminal";
      quick-terminal-position = "center";
      auto-update = "download";
      #term = "xterm-256color";
    }
  );
}

/*
  Palette config (for auto-generation)
  palette = 0=#393552
  palette = 1=#eb6f92
  palette = 2=#3e8fb0
  palette = 3=#f6c177
  palette = 4=#9ccfd8
  palette = 5=#c4a7e7
  palette = 6=#ea9a97
  palette = 7=#e0def4
  palette = 8=#6e6a86
  palette = 9=#eb6f92
  palette = 10=#3e8fb0
  palette = 11=#f6c177
  palette = 12=#9ccfd8
  palette = 13=#c4a7e7
  palette = 14=#ea9a97
  palette = 15=#e0def4
  background = #232136
  foreground = #e0def4
  cursor-color = #e0def4
  cursor-text = #232136
  selection-background = #44415a
  selection-foreground = #e0def4
*/
