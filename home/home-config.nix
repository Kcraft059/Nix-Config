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
    ./firefox.nix
    ./vim.nix
    ./fzf.nix
    ./zsh.nix
    ./bat.nix
  ];

  options = {
    home-config.GUIapps.enable = lib.mkEnableOption "Install GUI-Apps ?";
    home-config.external-drive.enable = lib.mkEnableOption "Enable linking of outside resources";
    home-config.external-drive.path = lib.mkOption {
      type = lib.types.str;
      default = "/Volumes/Data";
      example = lib.literalExpression '''';
      description = ''
        Mount point for the shared disk
      '';
    };
  };

  config = {
    home.packages =
      with pkgs;
      [
        imagemagick # Image editing
        yt-dlp # Video dwonloading tool
        speedtest-go # Speedtest
        mtr # My traceroute
        eza # ls replacement
        # mailsy # Temp email
        # posting # Tui http request sender
        viu # image viewer
        sops # Secret management

        bear # generate compile_comand

        # gum for clis
        # mcrcon
        # devenv maybe later see https://devenv.sh - alternative to nix-shells
      ]
      ++ lib.optionals config.home-config.GUIapps.enable (
        with pkgs;
        [
          audacity
        ]
      );
  };
}
