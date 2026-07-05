{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.system-pkgs = {
    coreUtils = lib.mkEnableOption "Install core utilities ?";
    additionnals.enable = lib.mkEnableOption "Install packages ?";
    GUIapps.enable = lib.mkEnableOption "Enable Install of GUI apps";
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
    linuxApps.enable = lib.mkEnableOption "Install linux-Apps ?";
  };

  config = {
    environment.systemPackages =
      lib.optionals config.system-pkgs.coreUtils [
        pkgs.git
        pkgs.screen
        pkgs.neovim
        pkgs.jq
        pkgs.gcc
        pkgs.htop # Htop program manager
      ]
      ++ lib.optionals config.system-pkgs.additionnals.enable [
        pkgs.bindfs
        pkgs.ffmpeg
      ]
      ++ lib.optionals config.system-pkgs.GUIapps.enable [
        pkgs.vscode
        # Gui Apps
      ]
      ++ lib.optionals config.system-pkgs.darwinApps.enable [
        # Darwin Apps
        pkgs.nixos-rebuild
        pkgs.smc-fuzzer
        pkgs.mkalias
        pkgs.mas
        pkgs.utm
        pkgs.iina
      ]
      ++ lib.optionals config.system-pkgs.linuxApps.enable [
        pkgs.sshfs
        pkgs.kdePackages.dolphin # GUI Prefer Home-Manager
      ];

    fonts.packages = lib.optionals config.system-pkgs.coreUtils [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.monocraft
    ];
  };
}
