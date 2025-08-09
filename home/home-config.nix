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
  ];

  config = {
    home.packages = [
      # pkgs.atuin
      pkgs.nixfmt-rfc-style
      pkgs.imagemagick
      pkgs.yt-dlp
      pkgs.bat
      pkgs.mailsy
      pkgs.tree
      pkgs.htop
      pkgs.speedtest-go
      pkgs.mtr
      pkgs.eza
    ] ++ lib.optionals config.home-config.GUIapps.enable [
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
