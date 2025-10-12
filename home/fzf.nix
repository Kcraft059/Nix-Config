{ pkgs, lib, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--style full"
      "--height 80%" 
      "--layout reverse" 
      "--border top"
      #"--preview 'bat --color=always --style=numbers {}'"
      #"--bind 'focus:transform-header:file --brief {}'"
    ];
  };
}
