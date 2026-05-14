{ lib, ... }:
{
  programs.zsh = {
    # Load the default Powerlevel10k configuration
    # Different of initExtra by adding First, it will be the first entry to be added

    initContent = lib.mkBefore ''
      alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
      export XDG_CONFIG_HOME=$HOME/.config # Needed for some programs
    '';
  };
}
