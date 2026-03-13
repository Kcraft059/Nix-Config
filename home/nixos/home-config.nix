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
    #./zsh.nix
  ];

  config = {
    home.packages = [
    ]
    ++ lib.optionals config.home-config.GUIapps.enable [
      #pkgs.ghostty
      #pkgs.krita
      pkgs.deskflow
    ];

    home.stateVersion = "24.11";
  };
}
