{
  pkgs,
  config,
  lib,
  system,
  inputs,
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
    coreUtils = lib.mkEnableOption "Install core utilities ?";
    additionnals.enable = lib.mkEnableOption "Install packages ?";
    GUIapps.enable = lib.mkEnableOption "Enable Install of GUI apps";
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
    linuxApps.enable = lib.mkEnableOption "Install linux-Apps ?";
  };

  config = {

    nixpkgs.overlays =
      [ 
        inputs.nix-vscode-extensions.overlays.default
        (import ../../overlays/fancy-folder.nix)
      ]
      ++ lib.optionals config.NIXPKG.darwinApps.enable [
        #(import ./overlays/mas.nix)
        (import ../../overlays/menubar-cli.nix)
        (import ../../overlays/krita-mac.nix)
        #(import ../../overlays/smc-cli.nix)
        (import ../../overlays/battery-toolkit.nix)
      ];

    environment.systemPackages =
      lib.optionals config.NIXPKG.coreUtils [
        pkgs.git
        pkgs.screen
        pkgs.neovim
        pkgs.jq
      ]
      ++ lib.optionals config.NIXPKG.additionnals.enable [
        #pkgs.php
        pkgs.ffmpeg
        pkgs.openjdk8
        pkgs.openjdk23
        pkgs.openjdk21
        effectivePkgsX86.openjdk17
      ]
      ++ lib.optionals config.NIXPKG.GUIapps.enable [
        #pkgs.ghostty
        pkgs.vscode
        # Gui Apps
      ]
      ++ lib.optionals config.NIXPKG.darwinApps.enable [
        # Darwin Apps
        #pkgs.smc-cli
        pkgs.smc-fuzzer
        pkgs.mkalias
        pkgs.mas
        pkgs.battery-toolkit
      ]
      ++ lib.optionals config.NIXPKG.linuxApps.enable [
        pkgs.sshfs
        pkgs.kdePackages.dolphin # GUI Prefer Home-Manager
      ];

    fonts.packages = lib.optionals config.NIXPKG.coreUtils [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.monocraft
    ];
  };
}
