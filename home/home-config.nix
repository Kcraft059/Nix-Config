{
  pkgs,
  lib,
  config,
  ...
}:
{

  imports = [
    ./fastfetch.nix
    ./git.nix
    ./btop.nix
    ./atuin.nix
    ./alacritty.nix
    ./ssh.nix
    ./vscode.nix
    #./lazy-vim.nix
    ./fzf.nix
    ./rift.nix
    ./bat.nix
  ];

  config = {
    home.packages =
      with pkgs;
      [
        nixfmt-rfc-style # Nix formating
        imagemagick # Image editing
        yt-dlp # Video dwonloading tool
        mailsy # Temp email
        htop # Htop program manager
        speedtest-go # Speedtest
        mtr # My traceroute
        eza # ls replacement
        posting # Tui http request sender
        bear # generate compile_comand

        # gum for clis
        # pkgs.mcrcon
        # pkgs.devenv maybe later see https://devenv.sh - alternative to nix-shells

      ]
      ++ [
        (pkgs.writeShellScriptBin "sftp-fuse" ''
          sshfs $1:/ /Volumes/$1 \
            -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=10 \
            -o volname="$1 - SFTP" \
            -o volicon="${../ressources/Shared_Volume.tiff}" \
            ''${2:-"-o umask=$2"}
        '')
      ]
      ++ lib.optionals config.home-config.GUIapps.enable [
        #pkgs.alacritty
      ];

    # Miscellaneous configs

    home.file."Library/Developer/Xcode/UserData/FontAndColorThemes/Rose Pine Moon.xccolortheme".source =
      ../ressources/Rose_Pine_Moon.xccolortheme;
    home.file."Library/Group Containers/UBF8T346G9.Office/User Content.localized/Themes.localized/Default Theme.potm".source =
      ../ressources/Excel_Default.potm;
  };
}
