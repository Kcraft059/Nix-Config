{ pkgs, ... }:
{
  name = "rose_pine_moon";

  wallpaper = ../../../ressources/Wallpaper/Breeze.png;

  theme = "dark";

  colors = {
    accent = "#7873F0";
    
    text = {
      primary = "#e0def4";
      subtle = "#908caa";
      muted = "#6e6a86";
    };

    colors = {
      red = "#eb6f92";
      green = "#9ccfd8";
      yellow = "#f6c177";
      blue = "#3e8fb0";
      purple = "#c4a7e7";
      cyan = "#ea9a97";
    };

    colors_variant = {
      red = "#b4637a";
      green = "#56949f";
      yellow = "#ea9d34";
      blue = "#286983";
      purple = "#907aa9";
      cyan = "#d7827e";
    };

    backgrounds = {
      base = "#232136";
      surface = "#2a273f";
      overlay = "#393552";
      highlight_low = "#2a283e";
      highlight_med = "#44415a";
      highlight_high = "#56526e";
    };
  };

  darwin.accent = 13;

  vs-theme = pkgs.vscode-marketplace.mvllow.rose-pine;
}
