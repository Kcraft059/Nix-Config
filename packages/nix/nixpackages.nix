{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.NIXPKG = {
    coreUtils = lib.mkEnableOption "Install core utilities ?";
    additionnals.enable = lib.mkEnableOption "Install packages ?";
    GUIapps.enable = lib.mkEnableOption "Enable Install of GUI apps";
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
    linuxApps.enable = lib.mkEnableOption "Install linux-Apps ?";
  };

  config = {
    environment.systemPackages =
      lib.optionals config.NIXPKG.coreUtils [
        pkgs.git
        pkgs.screen
        pkgs.neovim
        pkgs.jq
        pkgs.gcc
        pkgs.htop # Htop program manager
      ]
      ++ lib.optionals config.NIXPKG.additionnals.enable [
        pkgs.bindfs
        pkgs.ffmpeg
        #pkgs.openjdk8
        #pkgs.openjdk21
      ]
      ++ lib.optionals config.NIXPKG.GUIapps.enable [
        pkgs.vscode
        # Gui Apps
      ]
      ++ lib.optionals config.NIXPKG.darwinApps.enable [
        # Darwin Apps
        #pkgs.rift
        pkgs.nixos-rebuild
        pkgs.smc-fuzzer
        pkgs.mkalias
        pkgs.mas
        pkgs.utm
        pkgs.iina
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
