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
    ./bat.nix
  ];

  options = {
    home-config.GUIapps.enable = lib.mkEnableOption "Install GUI-Apps ?";
    home-config.external-drive.enable = lib.mkEnableOption "Enable linking of outside ressources";
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
        nixfmt-rfc-style # Nix formating
        imagemagick # Image editing
        yt-dlp # Video dwonloading tool
        mailsy # Temp email
        htop # Htop program manager
        speedtest-go # Speedtest
        mtr # My traceroute
        eza # ls replacement
        posting # Tui http request sender
        viu # image viewer
        sops # Secret management

        bear # generate compile_comand

        # gum for clis
        # mcrcon
        # devenv maybe later see https://devenv.sh - alternative to nix-shells
      ]
      ++ lib.optionals config.home-config.GUIapps.enable (with pkgs; [
        audacity
        #pkgs.alacritty
      ]);
  };
}
