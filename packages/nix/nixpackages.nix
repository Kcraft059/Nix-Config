{
  pkgs,
  config,
  lib,
  system,
  ...
}:
let
  pkgsX86 =
    if system == "aarch64-darwin" then
      import pkgs.path {
        system = "x86_64-darwin";
        config = pkgs.config;
      }
    else
      null;

  effectivePkgsX86 = if pkgsX86 != null then pkgsX86 else pkgs;
in
{
  options.NIXPKG = {
    GUIapps.enable = lib.mkEnableOption "Enable Install of GUI apps";
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
    linuxApps.enable = lib.mkEnableOption "Install linux-Apps ?";
  };

  config = {

    nixpkgs.overlays = [
      # Currently Empty
    ] ++ lib.optionals config.NIXPKG.darwinApps.enable [
      #(import ./overlays/mas.nix)
      (import ../../overlays/fancy-folder.nix)
      (import ../../overlays/battery-toolkit.nix)
    ] ;

    environment.systemPackages =
      [
        pkgs.git
        pkgs.ffmpeg
        pkgs.screen
        pkgs.php
        pkgs.neovim
        pkgs.openjdk8
        effectivePkgsX86.openjdk17
        pkgs.openjdk23
      ]
      ++ lib.optionals config.NIXPKG.GUIapps.enable [
        # Gui Apps
        pkgs.dolphin # GUI Prefer Home-Manager
      ]
      ++ lib.optionals config.NIXPKG.darwinApps.enable [
        # Darwin Apps
        pkgs.mkalias
        pkgs.mas
        pkgs.battery-toolkit
      ]
      ++ lib.optionals config.NIXPKG.linuxApps.enable [
        pkgs.sshfs
      ];

    fonts.packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.monocraft
    ];
  };
}
