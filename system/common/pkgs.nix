{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.system-pkgs = {
    core = lib.mkEnableOption "Install core utilities ?";
    additionnals = lib.mkEnableOption "Install packages ?";
    gui = lib.mkEnableOption "Enable Install of GUI apps";
  };

  config = {
    environment.systemPackages =
      lib.optionals config.system-pkgs.core [
        pkgs.git
        pkgs.screen
        pkgs.neovim
        pkgs.gcc
        pkgs.htop
      ]
      ++ lib.optionals config.system-pkgs.additionnals [
        pkgs.bindfs
        pkgs.sshfs
        pkgs.ntfs3g
        pkgs.ext4fuse
        pkgs.ffmpeg
      ]
      ++ lib.optionals config.system-pkgs.gui [
        pkgs.vscode
      ];

    fonts.packages =
      lib.optionals config.system-pkgs.core [
        pkgs.nerd-fonts.jetbrains-mono
      ]
      ++ lib.optionals config.system-pkgs.additionnals [
        pkgs.monocraft
      ];
  };
}
