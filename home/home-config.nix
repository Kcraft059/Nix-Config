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
        viu # image viewer

        # gum for clis
        # mcrcon
        # devenv maybe later see https://devenv.sh - alternative to nix-shells
      ]
      ++ lib.optionals config.home-config.GUIapps.enable [
        #pkgs.alacritty
      ];
  };
}
