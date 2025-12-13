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
      "--color fg:#908caa,fg+:#e0def4,header:#c4a7e7,hl:#c4a7e7,hl+:#c4a7e7,info:#ea9a97,marker:#9ccfd8,pointer:#9ccfd8,prompt:#ea9a97,spinner:#9ccfd8"
      #"--preview 'bat --color=always --style=numbers {}'"
      #"--bind 'focus:transform-header:file --brief {}'"
    ];
  };
}
