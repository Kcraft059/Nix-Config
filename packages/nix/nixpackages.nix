{ pkgs, config, lib, ... }:
let
  pkgsX86 = import pkgs.path {
    system = "x86_64-darwin";
    config = pkgs.config;
  };
  pkgsArm = import pkgs.path {
    system = "aarch64-darwin";
    config = pkgs.config;
  };
in
{
  options.NIXPKG = {
    GUIapps.enable = lib.mkEnableOption "Enable Install of GUI apps";
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
  };

  config = {
    environment.systemPackages =
      [
        pkgs.mas
        pkgs.mkalias
        pkgs.ffmpeg
        pkgs.screen
        pkgs.php
        pkgs.neovim
        pkgs.openjdk8
        pkgsX86.openjdk17
        pkgs.openjdk23
      ]
      ++ lib.optionals config.NIXPKG.GUIapps.enable [ # Gui Apps
        # pkgs.alacritty # GUI Prefer Home-Manager
      ]
      ++ lib.optionals config.NIXPKG.darwinApps.enable [ # Darwin Apps
        pkgs.battery-toolkit
      ];

    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.monocraft
    ];
  };
}
