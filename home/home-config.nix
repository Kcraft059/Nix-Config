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
    ./lazy-vim.nix
    ./fzf.nix
  ];

  config = {
    home.packages =
      with pkgs;
      [
        # pkgs.atuin
        nixfmt-rfc-style
        imagemagick
        yt-dlp
        bat
        mailsy
        tree
        htop
        speedtest-go
        mtr
        eza
        #fzf
        # pkgs.mcrcon
        # pkgs.devenv maybe later see https://devenv.sh - alternative to nix-shells

      ]
      ++ lib.optionals config.home-config.GUIapps.enable [
        #pkgs.alacritty
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
