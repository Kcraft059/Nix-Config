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
    /* initExtraFirst = # lib.optionalString builtins.elem "a"
      ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        source /opt/homebrew /share/powerlevel10k/powerlevel10k.zsh-theme
        source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      ''; */
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
  };
}
