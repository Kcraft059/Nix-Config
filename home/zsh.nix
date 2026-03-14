{
  pkgs,
  lib,
  config,
  ...
}:
let
  c = {
    black = "0";
    red = "1";
    green = "2";
    yellow = "3";
    blue = "4";
    purple = "5";
    cyan = "6";
    white = "7";
    black_ = "8";
    red_ = "9";
    green_ = "10";
    yellow_ = "11";
    blue_ = "12";
    purple_ = "13";
    cyan_ = "14";
    white_ = "15";
  };
in
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

      highlighters = [
        "brackets"
        "pattern"
        "main"
      ];

      patterns = {
        #"rm -rf *" = "fg=1,bold,bg=8";
      };

      styles = {
        comment = "fg=${c.black_}";
        unknown-token = "fg=${c.red},underline,bold";
        reserved-word = "fg=${c.purple},bold";
        builtin = "fg=${c.green_},bold";
        command = "fg=${c.green}";
        alias = "fg=${c.green_},underline";
        function = "fg=${c.cyan}";
        commandseparator = "fg=${c.black_},bold";
        path = "fg=${c.white},underline";
        path_pathseparator = "fg=${c.cyan},underline";
        globbing = "fg=${c.purple},bold";
        command-substitution-delimiter-quoted = "fg=${c.purple}";
        command-substitution-delimiter-unquoted = "fg=${c.cyan}";
        single-hyphen-option = "fg=${c.blue}";
        double-hyphen-option = "fg=${c.blue},bold";
        single-quoted-argument = "fg=${c.yellow},bold";
        boudle-quoted-argument = "fg=${c.yellow}";
        dollar-double-quoted-argument = "fg=${c.purple}";
        dollar-argument = "fg=${c.purple}";
        redirection = "fg=${c.cyan},bold,underline";
        arithmetic-expansion = "fg=${c.cyan}";
        assign = "fg=${c.white},underline";
        bracket-level-1 = "fg=${c.cyan_}";
        bracket-level-2 = "fg=${c.blue_}";
        bracket-level-3 = "fg=${c.purple_}";
        bracket-level-4 = "fg=${c.yellow_}";
      };
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "systemd"
      ];
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
    settings =
      let
        white = c.white;
        background = c.black;
        subtle = c.black_;

        elems = [
          rec {
            primary-color = c.purple;
            l-fmt = [
              "[](fg:${background})"
              "$os"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              os = {
                style = "fg:${primary-color} bold bg:${background}";
                format = "[ $symbol]($style)";
                symbols.NixOS = " ";
                symbols.Macos = " ";
                disabled = false;
              };
            };
          }
          rec {
            primary-color = c.red;
            l-fmt = [
              "$directory"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              directory = {
                style = "fg:${primary-color} bg:${background}";
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
            };
          }
          rec {
            primary-color = c.cyan;
            l-fmt = [
              "$git_branch"
              "$git_status"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              git_branch = {
                symbol = "";
                style = "fg:${primary-color} bg:${background}";
                format = "[ $symbol $branch ]($style)";
              };
              git_status = {
                ahead = "[⇡\${count}](fg:4 bg:${background})";
                diverged = "[⇕⇡\${ahead_count}⇣\${behind_count}](fg:3 bg:${background})";
                behind = "[⇣\${count}](fg:1 bg:${background})";
                style = "fg:${primary-color} bg:${background}";
                format = "[$all_status$ahead_behind ]($style)";
              };
            };
          }
          rec {
            primary-color = c.yellow;
            l-fmt = [
              "$c"
              "$cpp"
              "$python"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              c = {
                symbol = " ";
                style = "fg:${primary-color} bg:${background}";
                format = "[ $symbol($version(-$name)) ]($style)";
              };
              cpp = {
                symbol = " ";
                style = "fg:${primary-color} bg:${background}";
                format = "[$symbol($version(-$name) )]($style)";
              };
              python = {
                symbol = " ";
                style = "fg:${primary-color} bg:${background}";
                format = "[ \${symbol}\${pyenv_prefix}(\${version} )(\\($virtualenv\\) )]($style)";
              };
            };
          }
          rec {
            primary-color = c.green;
            l-fmt = [
              "$nix_shell"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              nix_shell = {
                disabled = false;
                format = "[ $symbol $state( \\($name\\)) ]($style)";
                symbol = " ";
                style = "fg:${primary-color} bold bg:${background}";
                impure_msg = "[impure](fg:6 bg:${background})";
                pure_msg = "[pure](fg:2 bg:${background})";
                unknown_msg = "[unknown](fg:3 bg:${background})";
              };
            };
          }
          rec {
            primary-color = c.blue;
            l-fmt = [
              "$cmd_duration"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              cmd_duration = {
                show_notifications = false;
                show_milliseconds = true;
                style = "fg:${primary-color} bg:${background}";
                format = "[  $duration ]($style)";
              };
            };
          }
          rec {
            primary-color = subtle;
            l-fmt = [
              "$status"
              "[](fg:${background})"
              "$fill"
              "[](fg:${background})"
            ];
            r-fmt = [ ];
            config = {
              status = {
                disabled = false;
                symbol = "✘";
                format = "[ $symbol $status ]($style)";
                style = "fg:1 bold bg:${background}";
              };
              fill = {
                symbol = "─";
                style = "fg:${primary-color}";
              };
            };
          }
          rec {
            primary-color = c.green;
            l-fmt = [
              "$username"
            ];
            r-fmt = [ ];
            config = {
              username = {
                show_always = true;
                style_user = "fg:${primary-color} bg:${background}";
                style_root = "fg:1 bg:${background}";
                format = "[ $user ]($style)";
                disabled = false;
              };
            };
          }
          rec {
            primary-color = c.blue;
            l-fmt = [
              "[](fg:${primary-color} bg:${background})"
              "$hostname"
            ];
            r-fmt = [ ];
            config = {
              hostname = {
                disabled = false;
                ssh_only = false;
                ssh_symbol = " ";
                format = "[ $hostname ]($style)";
                style = "fg:${primary-color} bg:${background}";
              };
            };
          }
          rec {
            primary-color = c.purple;
            l-fmt = [
              "[](fg:${primary-color} bg:${background})"
              "$localip"
            ];
            r-fmt = [ ];
            config = {
              localip = {
                disabled = false;
                ssh_only = false;
                format = "[ $localipv4  ]($style)";
                style = "fg:${primary-color} bg:${background}";
              };
            };
          }
          rec {
            primary-color = c.white;
            l-fmt = [ ];
            r-fmt = [
              "[](fg:${background})" # "[](fg:2)"
              "$time"
            ];
            config = {
              time = {
                disabled = false;
                time_format = "%T"; # Hour:Minute Format
                style = "fg:${primary-color} italic bg:${background}";
                format = "[ $time  ]($style)";
              };
            };
          }
          rec {
            primary-color = subtle;
            l-fmt = [
              "[](fg:${background})"
              "[─╮ ](fg:${primary-color})"
              "$line_break"
              "$character"
            ];
            r-fmt = [
              "[](fg:${background})" # "[](fg:2)"
              "[─╯](fg:${primary-color})"
            ];
            config = {
              continuation_prompt = "[› ](fg:${subtle})";
              character = {
                success_symbol = "[❯](fg:4)";
                error_symbol = "[❯](fg:1)";
              };
            };
          }
        ];

        base-settings = {
          add_newline = true;
          scan_timeout = 10;
          format = lib.concatStrings (builtins.concatLists (map (v: v.l-fmt) elems));
          right_format = lib.concatStrings (builtins.concatLists (map (v: v.r-fmt) elems));
        };
      in
      builtins.foldl' (acc: v: acc // v) base-settings (map (v: v.config) elems);
  };
}
