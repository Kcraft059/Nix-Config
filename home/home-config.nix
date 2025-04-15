{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.home-config = {
    darwinApps.enable = lib.mkEnableOption "Install Mac-Apps ?";
  };

  imports = [
    ./fastfetch.nix
    ./ghostty.nix
    ./git.nix
    ./btop.nix
  ];

  config = {

    home.stateVersion = "24.11";

    home.packages =
      [
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
      ];

  };
}
/*
      programs.vscode = {
        enable = true;
      };

      ".config/fastfetch/logo.txt".text = (builtins.readFile ./logo.txt);

      programs.zsh = {
        enable = true;
        # Load the default Powerlevel10k configuration
        initExtra = ''
          echo 'test'
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          source /opt/homebrew /share/powerlevel10k/powerlevel10k.zsh-theme
          source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

          # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
      };

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
