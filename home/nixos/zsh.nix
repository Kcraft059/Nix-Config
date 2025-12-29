{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zsh = {
    enable = true;
    # Load the default Powerlevel10k configuration
    # Different of initExtra by adding First, it will be the first entry to be added
    initContent = lib.mkBefore ''
      # Prompt aspect
      # autoload -U colors && colors
      # NEWLINE=$'\n'
      # PS1="%{$NEWLINE%}%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[green]%}%m%{$fg[magenta]%}:%{$fg[cyan]%}%~%{$fg[red]%}]%{$reset_color%}$ "

      alias ll="eza --long --header --git --icons=auto"
      alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
    '';
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    /* settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$all"
      ];
      scan_timeout = 10;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      }; 
    }; */
  };
}
