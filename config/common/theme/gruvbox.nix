{ pkgs, ... }:
{
  name = "gruvbox_dark";

  wallpaper = ./Wallpapers/Lake.jpg;

  theme = "dark";

  colors = {
    accent = "#d79921";

    text = {
      primary = "#ebdbb2";
      subtle = "#a89984";
      muted = "#928374";
    };

    colors = {
      red = "#cc241d";
      green = "#98971a";
      yellow = "#d79921";
      blue = "#458588";
      purple = "#b16286";
      cyan = "#689d6a";
      orange = "#d65d0e";
    };

    colors_variant = {
      red = "#fb4934";
      green = "#b8bb26";
      yellow = "#fabd2f";
      blue = "#83a598";
      purple = "#d3869b";
      cyan = "#8ec07c";
      orange = "#fe8019";
    };

    backgrounds = {
      base = "#32302F";
      surface = "#282828";
      overlay = "#3c3836";
      highlight_low = "#32302f";
      highlight_med = "#504945";
      highlight_high = "#665c54";
    };
  };

  darwin.accent = 9;

  vs-theme = {
    package = pkgs.vscode-marketplace.jdinhlife.gruvbox;
    name = "Gruvbox Dark Soft";
  };
}
