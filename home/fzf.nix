{ pkgs, lib, ... }:
{
  stylix.targets.fzf.enable = false;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--style full"
      "--height 80%"
      "--layout reverse"
      "--border top"
      "--color fg:8,fg+:2,header:5,hl:13,hl+:5,info:6,marker:2,pointer:10,prompt:6,spinner:2"
      #"--preview 'bat --color=always --style=numbers {}'"
      #"--bind 'focus:transform-header:file --brief {}'"
    ];
  };
}
