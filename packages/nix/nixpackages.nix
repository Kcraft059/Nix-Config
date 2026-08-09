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
      ++ lib.optionals config.system-pkgs.additionnals.enable (
        [
          pkgs.bindfs
          pkgs.sshfs
          pkgs.ntfs3g
          pkgs.ext4fuse
          pkgs.ffmpeg
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          (pkgs.writeShellScriptBin "mount_sftp" ''
            [[ -z "$1" ]] && exit 1
            ${pkgs.sshfs}/bin/sshfs $1:/ /Volumes/$1 \
            	-o reconnect,ServerAliveInterval=15,ServerAliveCountMax=10 \
            	-o volname="$1 - SFTP" \
            	-o modules=volicon -o iconpath="${../../resources/Shared_Volume.tiff}" \
            	''${2:+"-o"} ''${2:+"umask=$2"}
          '')
        ]
      )
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
        pkgs.kdePackages.dolphin # GUI Prefer Home-Manager
      ];

    fonts.packages = lib.optionals config.system-pkgs.coreUtils [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.monocraft
    ];
  };
}
