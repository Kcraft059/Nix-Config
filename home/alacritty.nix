{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    programs.alacritty = {
      enable = config.home-config.GUIapps.enable;
    };
  };
}
