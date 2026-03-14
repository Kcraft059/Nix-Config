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
  clrs = theme.colors;

  theme_file = pkgs.writeText "ghostty-theme-${theme.name}" ''
    palette = 0= ${clrs.backgrounds.overlay}
    palette = 1= ${clrs.colors.red}
    palette = 2= ${clrs.colors.green}
    palette = 3= ${clrs.colors.yellow}
    palette = 4= ${clrs.colors.blue}
    palette = 5= ${clrs.colors.purple}
    palette = 6= ${clrs.colors.cyan}
    palette = 7= ${clrs.text.primary}
    palette = 8= ${clrs.text.muted}
    palette = 9= ${clrs.colors_variant.red}
    palette = 10= ${clrs.colors_variant.green}
    palette = 11= ${clrs.colors_variant.yellow}
    palette = 12= ${clrs.colors_variant.blue}
    palette = 13= ${clrs.colors_variant.purple}
    palette = 14= ${clrs.colors_variant.cyan}
    palette = 15= ${clrs.text.primary}
    background = ${clrs.backgrounds.base}
    foreground = ${clrs.text.primary}
    cursor-color = ${clrs.text.primary}
    cursor-text = ${clrs.backgrounds.base}
    selection-background = ${clrs.backgrounds.highlight_med}
    selection-foreground = ${clrs.text.primary}
  '';
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
        theme = theme_file;
      }
    );
  };
}
