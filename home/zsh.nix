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
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Prompt aspect
        # autoload -U colors && colors
        # NEWLINE=$'\n'
        # PS1="%{$NEWLINE%}%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[green]%}%m%{$fg[magenta]%}:%{$fg[cyan]%}%~%{$fg[red]%}]%{$reset_color%}$ "

        setopt interactivecomments
      '')
      (lib.mkAfter ''
        alias ll="eza --long --header --git --icons=auto"
        alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
      '')
    ];
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles = {
        comment = "fg=8,bold";
      };
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "systemd"
      ];
      #theme = "ys";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];

  };

  stylix.targets.starship.enable = false;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      ## See https://starship.rs/presets/pastel-powerline

      add_newline = false;
      scan_timeout = 10;

      continuation_prompt = "[› ](fg:8)";

      format = lib.concatStrings [
        "[](fg:0)"
        "$os"
        "[](fg:5 bg:0)"
        "$directory"
        "[](fg:1 bg:0)"
        "[](fg:6 bg:0)"
        "[](fg:3 bg:0)"
        "$git_branch"
        "$git_status"
        "$c"
        "[](fg:4 bg:0)"
        "$nix_shell"
        "[](fg:2 bg:0)"
        "[](fg:0)"

        "$fill"
        
        "[](fg:0)"
        "$username"
        "[](fg:2 bg:0)"
        "$hostname"
        "[](fg:5 bg:0)"
        "$localip"
        "[](fg:0)"
        "[─╮ ](fg:8)"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "[](fg:0)" # "[](fg:2)"
        "$time"
        "[](fg:0)" # "[](fg:2)"
        "[─╯](fg:8)"
      ];

      character = {
        success_symbol = "[❯](fg:4)";
        error_symbol = "[❯](fg:1)";
      };

      fill.symbol = "─";

      username = {
        show_always = true;
        style_user = "fg:4 bg:0";
        style_root = "fg:1 bg:0";
        format = "[ $user ]($style)";
        disabled = false;
      };

      hostname = {
        disabled = false;
        ssh_only = false;
        ssh_symbol = " ";
        format = "[ $hostname ]($style)";
        style = "fg:2 bg:0";
      };

      localip = {
        disabled = false;
        ssh_only = false;
        format = "[ $localipv4  ]($style)";
        style = "fg:5 bg:0";
      };

      os = {
        style = "fg:5 bg:0";
        format = "[ $symbol]($style)";
        symbols.NixOS = " ";
        symbols.Macos = " ";
        disabled = false;
      };
      directory = {
        style = "fg:1 bg:0";
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
        time_format = "%T"; # Hour:Minute Format
        style = "fg:7 bg:0";
        format = "[ $time  ]($style)";
      };

      ## Git
      git_branch = {
        symbol = "";
        style = "fg:3 bg:0";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        ahead = "[⇡\${count}](fg:2 bg:0)";
        diverged = "[⇕⇡\${ahead_count}⇣\${behind_count}](fg:3 bg:0)";
        behind = "[⇣\${count}](fg:1 bg:0)";
        style = "fg:3 bg:0";
        format = "[$all_status$ahead_behind ]($style)";
      };

      ## Langs
      c = {
        symbol = " ";
        style = "fg:5 bg:0";
        format = "[ $symbol ($version) ]($style)";
      };

      nix_shell = {
        disabled = false;
        format = "[ $symbol $state( \\($name\\)) ]($style)";
        symbol = " ";
        style = "fg:4 bg:0";
        impure_msg = "[impure](fg:6 bg:0)";
        pure_msg = "[pure](fg:2 bg:0)";
        unknown_msg = "[unknown](fg:3 bg:0)";
      };
    };
  };
}
