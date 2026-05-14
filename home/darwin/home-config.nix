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
        macmon
      ]
      ++ [
        (pkgs.writeShellScriptBin "mountsftp" ''
          [[ -z "$1" ]] && exit 1
          sshfs $1:/ /Volumes/$1 \
                      -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=10 \
                      -o volname="$1 - SFTP" \
                      -o volicon="${../../resources/Shared_Volume.tiff}" \
                      ''${2:+"-o"} ''${2:+"umask=$2"}
        '')
        (pkgs.writeShellScriptBin "osswitch" ''
          sudo bless -mount "/Volumes/$(ls /Volumes/ | fzf)" -setBoot
          echo -ne "Reboot? (y/n): "
          read reboot_cf
          if [[ "$reboot_cf" =~ ^[Yy]$ ]]; then
            sudo reboot
          fi
          unset reboot_cf
        '')
        (pkgs.writeShellScriptBin "chlimit" ''
          # Usage: -[pt] <limit>

          : ''${1:=-p}
          LIMIT="$2"
          VALID=(80 85 90 95 100)

          if [ "$1" = "-p" ];then 
            PERM=true
          elif [ "$1" = "-t" ];then
            PERM=false
          fi

          if ! shortcuts list | grep -q "Set Charge Limit"; then
            echo -e "Can't find \"Set Charge Limit\" shortcut\nA dialog will open to install the required shortcut"
            open "${../../resources}/Set Charge Limit.shortcut"

            while ! shortcuts list | grep -q "Set Charge Limit"; do
              sleep 0.5
            done

            echo "Shortcut sucessfully installed !"
            killall Shortcuts
          fi

          if [[ ! " ''${VALID[@]} " =~ " ''${LIMIT} " ]]; then
              echo "Error: valid values are 80, 85, 90, 95, 100"
              exit 1
          fi

          echo "$LIMIT,$PERM" | shortcuts run "Set Charge Limit" --input-path -
          echo -e "Set limit to $LIMIT% $([ "$PERM" = "false" ] && echo "until tomorrow")"
        '')
      ]
      ++ lib.optionals (config.home-config.darwinApps.enable && config.home-config.GUIapps.enable) [
        raycast
      ];
  };
}
