{ pkgs, lib, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkDefault "Default";
      theme_background = false;
      proc_tree = true;
    };
  };
}
