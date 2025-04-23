{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    GUIapps.enable = lib.mkEnableOption "Install GUI-Apps ?";
  };

  imports = [
    ./ghostty.nix
    ./zsh.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages =
      [
      ]
      ++ lib.optionals config.home-config.GUIapps.enable [
        pkgs.ghostty
        pkgs.vscode
        pkgs.fancyfolder
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
