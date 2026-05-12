{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./plasma.nix
    ./ghostty.nix
  ];

  config = {
    home.packages = [
    ]
    ++ lib.optionals config.home-config.GUIapps.enable [
      pkgs.deskflow
    ];

    home.stateVersion = "24.11";
  };
}
