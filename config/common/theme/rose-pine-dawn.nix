{ pkgs, ... }:
{
  name = "rose_pine_moon";

  wallpaper = ./Wallpapers/Cherry_Blossom.png;

  theme = "light";

  colors = {
    accent = "#EB6F92";

    text = {
      primary = "#575279";
      subtle = "#797593";
      muted = "#9893a5";
    };

    colors = rec {
      red = "#b4637a";
      green = "#56949f";
      yellow = "#ea9d34";
      blue = "#286983";
      purple = "#907aa9";
      cyan = "#d7827e";
      orange = cyan;
    };

    colors_variant = rec {
      red = "#b4637a";
      green = "#56949f";
      yellow = "#ea9d34";
      blue = "#286983";
      purple = "#907aa9";
      cyan = "#d7827e";
      orange = cyan;
    };

    backgrounds = {
      base = "#faf4ed";
      surface = "#fffaf3";
      overlay = "#f2e9e1";
      highlight_low = "#f4ede8";
      highlight_med = "#dfdad9";
      highlight_high = "#cecacd";
    };
  };

  darwin.accent = 17;

  vs-theme = {
    package = pkgs.vscode-marketplace.mvllow.rose-pine;
    name = "Rosé Pine Dawn";
  };

  nvim-theme = {
    package = pkgs.vimPlugins.rose-pine;
    name = "rose-pine";
    options = {
      variant = "dawn";
      styles.transparency = true;
    };
  };
}
