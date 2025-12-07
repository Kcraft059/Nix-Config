{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    GUIapps.enable = lib.mkEnableOption "Install GUI-Apps ?";
    darwinApps.enable = lib.mkEnableOption "Install Darwin-Apps ?";
  };

  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./quick-actions.nix
    ./sketchybar.nix
    ./app-defaults.nix
    ./links.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages = [
      pkgs.m-cli
      pkgs.macmon
      pkgs.zsh-powerlevel10k
    ]
    ++ lib.optionals (config.home-config.darwinApps.enable && config.home-config.GUIapps.enable) [
      pkgs.krita-mac
    ];
  };
}