{ lib, ... }:
{
  programs.zsh = {
    initContent = lib.mkBefore ''
      alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
      export XDG_CONFIG_HOME=$HOME/.config # Needed for some programs
    '';
  };
}
