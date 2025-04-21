{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
    linuxApps.enable = lib.mkEnableOption "Install Linux-Apps ?";
  };

  imports = [
    ./fastfetch.nix
    ./ghostty.nix
    ./git.nix
    ./btop.nix
    ./zsh.nix
    ./atuin.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages =
      [
        # pkgs.atuin
        pkgs.nixfmt-rfc-style
        pkgs.imagemagick
        pkgs.yt-dlp
        pkgs.bat
        pkgs.mailsy
        pkgs.tree
        pkgs.htop
      ]
      ++ lib.optionals config.home-config.darwinApps.enable [
        pkgs.fancyfolder
        pkgs.m-cli
      ]
      ++ lib.optionals config.home-config.linuxApps.enable [
        pkgs.ghostty
        pkgs.alacritty
        pkgs.vscode
      ];
  };
}
/*
      programs.vscode = {
        enable = true;
      };

      ".config/fastfetch/logo.txt".text = (builtins.readFile ./logo.txt);

      programs.fastfetch = {
        enable = true;
        package = pkgs.fastfetch;
        settings = {
          logo = {
            source = "~/.config/fastfetch/logo.txt";
            padding = {
              right = 1;
            };
          };
        };
      };

  }
*/
