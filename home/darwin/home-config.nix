{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    GUIapps.enable = lib.mkEnableOption "Install GUI-Apps ?";
    darwinApps.enable = lib.mkEnableOption "Install Darwin-Apps ?";
  };

  imports = [
    ./ghostty.nix
    ./zsh.nix
    ./quick-actions.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages =
      [
        pkgs.m-cli
        pkgs.macmon
        pkgs.zsh-powerlevel10k
      ]
      ++ lib.optionals (config.home-config.darwinApps.enable && config.home-config.GUIapps.enable) [
        pkgs.krita-mac
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
