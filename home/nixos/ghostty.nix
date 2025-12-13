{
  pkgs,
  lib,
  config,
  ...
}:
{
  # home.packages = [ pkgs.ghostty ];
  stylix.targets.ghostty.enable = false;

  programs.ghostty = {
    enable = config.home-config.GUIapps.enable;
    settings = {
      theme = "Rose Pine Moon";
      background-blur = 15;
      background-opacity = 0.85;
      window-step-resize = true;
      window-height = 30;
      window-width = 109;
      window-padding-x = 5;
      quit-after-last-window-closed = true;
      #keybind = global:cmd+i=change_title_prompt
      #keybind = [ "global:cmd+opt+ctrl+space=toggle_quick_terminal" ];
      quick-terminal-position = "center";
      auto-update = "download";
      #term = "xterm-256color";
    };
  };
}
