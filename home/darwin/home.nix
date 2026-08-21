{
  pkgs,
  lib,
  config,
  ...
}:
{

  options = {
    home-config.external-drive.enable = lib.mkEnableOption "Enable linking of outside resources";
    home-config.external-drive.path = lib.mkOption {
      type = lib.types.str;
      default = "/Volumes/Data";
      example = lib.literalExpression "";
      description = ''
        Mount point for the shared disk
      '';
    };
  };

  config = {
    home.stateVersion = "26.05";

    home.packages =
      with pkgs;
      [
        macmon
      ]
      ++ lib.optionals config.home-config.gui [
        raycast-beta
        libresprite-app
        prismlauncher
        signal-desktop
      ]
      ++ [
        (pkgs.writeShellScriptBin "os-switch" ''
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

          ARG=''${1:--p}
          LIMIT="$2"
          VALID=(80 85 90 95 100)

          if [ "$ARG" = "-p" ];then 
            PERM=true
          elif [ "$ARG" = "-t" ];then
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
      ];
  };
}
