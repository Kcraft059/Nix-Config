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

  stylix.targets.starship.enable = false;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      ## See https://starship.rs/presets/pastel-powerline
      add_newline = false;
      scan_timeout = 10;
      format = lib.concatStrings [
        "[](fg:0)"
        "$os"
        "$username"
        "[](fg:1 bg:0)" # "[](fg:1 bg:6)"
        "$directory"
        "[](fg:6 bg:0)" # "[](fg:6 bg:3)"
        "$git_branch"
        "$git_status"
        "[](fg:3 bg:0)" # "[](fg:3 bg:5)"
        "$c"
        #"$elixir"
        #"$elm"
        #"$golang"
        #"$gradle"
        #"$haskell"
        #"$java"
        #"$julia"
        #"$nodejs"
        #"$nim"
        #"$rust"
        #"$scala"
        "[](fg:5 bg:0)" # "[](fg:5 bg:4)"
        #"$docker_context"
        "[](fg:4 bg:0)" # "[](fg:4 bg:2)"
        "$time"
        "[](fg:0)" # "[](fg:2)"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$hostname"
        "$line_break"
        "$time"
      ];

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      username = {
        show_always = true;
        style_user = "fg:1 bg:0";
        style_root = "fg:1 bg:0";
        format = "[$user ]($style)";
        disabled = false;
      };
      hostname = {
        disabled = false;
      };
      os = {
        style = "fg:1 bg:0";
        disabled = false;
      };
      directory = {
        style = "fg:6 bg:0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "fg:2 bg:0";
        format = "[  $time ]($style)";
      };

      ## Git
      git_branch = {
        symbol = "";
        style = "fg:3 bg:0";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "fg:3 bg:0";
        format = "[$all_status$ahead_behind ]($style)";
      };

      ## Langs
      c = {
        symbol = " ";
        style = "fg:5 bg:0";
        format = "[ $symbol ($version) ]($style)";
      };
    };
  };
}
