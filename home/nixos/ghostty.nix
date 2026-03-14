{
  lib,
  config,
  global-config,
  pkgs,
  ...
}:
let
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
  theme = global-config.common.theme;
  ghostty-theme = import ../configs/ghostty-theme.nix { inherit theme; };
in
{
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = config.home-config.GUIapps.enable;
    settings = (
      {
        #theme = "dark:Rose Pine Moon,light:Rose Pine Dawn";

        background-blur = 15;
        background-opacity = 0.85;
        window-height = 30;
        window-width = 109;
        window-padding-x = 5;

        #term = "xterm-256color";
        #window-step-resize = true;
        quit-after-last-window-closed = true;

        #macos-icon = "custom-style";
        #macos-icon-ghost-color = "#F6C177";
        #macos-icon-screen-color = "#232137";
        #keybind = global:cmd+i=change_title_prompt

        #keybind = "global:cmd+opt+ctrl+space=toggle_quick_terminal";
        quick-terminal-position = "center";
        auto-update = "download";
      }
      # [THEME DEPENDENT]
      // lib.optionalAttrs theme.enable {
        theme = pkgs.writeText "ghostty-theme-${theme.name}" ghostty-theme;
      }
    );
  };
}
