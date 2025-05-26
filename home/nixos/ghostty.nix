{ pkgs, lib, ... }:
let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
in
{
  # home.packages = [ pkgs.ghostty ];
  home.file.".config/ghostty/config".text = toKeyValue { mkKeyValue = mkKeyValueDefault { } " = "; } {
    theme = "rose-pine-moon";
    background-blur = 15;
    background-opacity = 0.85;
    window-step-resize = true;
    window-height = 30;
    window-width = 109;
    window-padding-x = 5;
    quit-after-last-window-closed = true;
    macos-icon = "custom-style";
    macos-icon-ghost-color = "#F6C177";
    macos-icon-screen-color = "#232137";
    #keybind = global:cmd+i=change_title_prompt
    keybind = "global:cmd+opt+ctrl+space=toggle_quick_terminal";
    quick-terminal-position = "center";
    auto-update = "download";
    term = "xterm-256color";
  };
}
