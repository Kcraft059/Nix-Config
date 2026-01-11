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
    settings =
      let
        white = "7";
        background = "0";
        subtle = "8";

        elems = [
          rec {
            primary-color = "5";
            l-fmt = [
              "[](fg:${background})"
              "$os"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              os = {
                style = "fg:${primary-color} bg:${background}";
                format = "[ $symbol]($style)";
                symbols.NixOS = " ";
                symbols.Macos = " ";
                disabled = false;
              };
            };
          }
          rec {
            primary-color = "1";
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
            primary-color = "6";
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
                ahead = "[⇡\${count}](fg:2 bg:${background})";
                diverged = "[⇕⇡\${ahead_count}⇣\${behind_count}](fg:3 bg:${background})";
                behind = "[⇣\${count}](fg:1 bg:${background})";
                style = "fg:${primary-color} bg:${background}";
                format = "[$all_status$ahead_behind ]($style)";
              };
            };
          }
          rec {
            primary-color = "3";
            l-fmt = [
              "$c"
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = {
              c.style = "fg:${primary-color} bg:${background}";
            };
          }
          rec {
            primary-color = "4";
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
                style = "fg:${primary-color} bg:${background}";
                impure_msg = "[impure](fg:6 bg:${background})";
                pure_msg = "[pure](fg:2 bg:${background})";
                unknown_msg = "[unknown](fg:3 bg:${background})";
              };
            };
          }
          rec {
            primary-color = "2";
            l-fmt = [
              "[](fg:${primary-color} bg:${background})"
            ];
            r-fmt = [ ];
            config = { };
          }
          rec {
            primary-color = subtle;
            l-fmt = [
              "[](fg:${background})"
              "$fill"
              "[](fg:${background})"
            ];
            r-fmt = [ ];
            config = {
              fill = {
                symbol = "─";
                style = "fg:${primary-color}";
              };
            };
          }
          rec {
            primary-color = "4";
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
            primary-color = "2";
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
            primary-color = "5";
            l-fmt = [
              "[](fg:${colors."0"} bg:${background})"
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
            primary-color = "7";
            l-fmt = [ ];
            r-fmt = [
              "[](fg:${background})" # "[](fg:2)"
              "$time"
            ];
            config = {
              time = {
                disabled = false;
                time_format = "%T"; # Hour:Minute Format
                style = "fg:${primary-color} bg:${background}";
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
          add_newline = false;
          scan_timeout = 10;
          format = lib.concatStrings (builtins.concatLists (map (v: v.l-fmt) elems));
          right_format = lib.concatStrings (builtins.concatLists (map (v: v.r-fmt) elems));
        };
      in
      builtins.foldl' (acc: v: acc // v) base-settings (map (v: v.config) elems);
  };
}
