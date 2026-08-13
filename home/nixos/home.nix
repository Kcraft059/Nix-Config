{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    home.stateVersion = "26.05";

    home.packages = [
    ]
    ++ lib.optionals config.home-config.GUIapps.enable [
      pkgs.deskflow
    ];
  };
}
