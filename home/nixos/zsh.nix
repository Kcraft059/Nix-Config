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
    settings = {
      ## See https://starship.rs/presets/pastel-powerline
      add_newline = false;
      scan_timeout = 10;
      format = lib.concatStrings [
        "[](red)"
        "$os"
        "$username"
        "[](bg:red fg:#9A348E)"
        "$directory"
        "[](fg:#DA627D bg:#FCA17D)"
        "$git_branch"
        "$git_status"
        "[](fg:#FCA17D bg:#86BBD8)"
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
        "[](fg:#86BBD8 bg:#06969A)"
        #"$docker_context"
        "[](fg:#06969A bg:#33658A)"
        "$time"
        "[](fg:#33658A)"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$time"
      ];

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      username = {
        show_always = true;
        style_user = "bg:#9A348E";
        style_root = "bg:#9A348E";
        format = "[$user ]($style)";
        disabled = false;
      };
      os = {
        style = "bg:#9A348E";
        disabled = false;
      };
      directory = {
        style = "bg:#DA627D";
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
        style = "bg:#33658A";
        format = "[  $time ]($style)";
      };

      ## Git
      git_branch = {
        symbol = "";
        style = "bg:#FCA17D";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#FCA17D";
        format = "[$all_status$ahead_behind ]($style)";
      };

      ## Langs
      c = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
    };
  };
}
