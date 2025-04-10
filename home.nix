{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.nixfmt-rfc-style
    pkgs.fastfetch
    pkgs.imagemagick
    pkgs.yt-dlp
    pkgs.bat
    pkgs.mailsy
    pkgs.tree
    pkgs.btop
    pkgs.htop
  ];

  programs.git = {
    enable = true;
    userEmail = "kcraft059.msg@gmail.com";
    userName = "Kcraft059";
  };

  home.file = {
    ".config/ghostty/config".text = ''
      theme = dark:rose-pine-moon,light:rose-pine-dawn
      background-blur = 15
      background-opacity = 0.85
      window-step-resize = true
      window-height = 35
      window-width = 125
      window-padding-x = 5 
      quit-after-last-window-closed = true
      macos-icon = custom-style
      macos-icon-ghost-color = #F6C177
      macos-icon-screen-color = #232137

      #keybind = global:cmd+i=change_title_prompt
      keybind = global:cmd+opt+ctrl+space=toggle_quick_terminal
      quick-terminal-position = center
    '';
    # ".config/fastfetch/logo.txt".text = (builtins.readFile ./logo.txt);
    ".config/fastfetch/logo.txt".source = ./configs/fastfetch/logo.txt;
    ".config/fastfetch/config.jsonc".source = ./configs/fastfetch/config.jsonc;
  };

  /*
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
  */

  /*
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
  */
}
