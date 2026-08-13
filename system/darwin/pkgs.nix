{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages =
    lib.optionals config.system-pkgs.core [
    ]
    ++ lib.optionals config.system-pkgs.additionnals [
      pkgs.nixos-rebuild
      pkgs.smc-fuzzer
      (pkgs.writeShellScriptBin "mount_sftp" ''
        [[ -z "$1" ]] && exit 1
        ${pkgs.sshfs}/bin/sshfs $1:/ /Volumes/$1 \
        	-o reconnect,ServerAliveInterval=15,ServerAliveCountMax=10 \
        	-o volname="$1 - SFTP" \
        	-o modules=volicon -o iconpath="${../../resources/Shared_Volume.tiff}" \
        	''${2:+"-o"} ''${2:+"umask=$2"}
      '')
    ]
    ++ lib.optionals config.system-pkgs.gui [
      pkgs.utm
      pkgs.iina
    ];
}
