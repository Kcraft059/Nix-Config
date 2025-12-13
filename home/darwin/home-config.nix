{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    darwinApps.enable = lib.mkEnableOption "Install Darwin-Apps ?";
  };

  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./quick-actions.nix
    ./sketchybar.nix
    ./app-defaults.nix
    ./links.nix
    ./rift.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages =
      with pkgs;
      [
        m-cli
        macmon
        zsh-powerlevel10k
      ]
      ++ [
        (pkgs.writeShellScriptBin "sftp-fuse" ''
          [[ -z "$1" ]] && exit 1
          sshfs $1:/ /Volumes/$1 \
                      -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=10 \
                      -o volname="$1 - SFTP" \
                      -o volicon="${../../ressources/Shared_Volume.tiff}" \
                      ''${2:+"-o"} ''${2:+"umask=$2"}
        '')
      ]
      ++ lib.optionals (config.home-config.darwinApps.enable && config.home-config.GUIapps.enable) [
        pkgs.krita-mac
      ];
  };
}
