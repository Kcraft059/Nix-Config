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

    initContent =
      lib.mkBefore # lib.optionalString builtins.elem "a"
        ''
          # p10k config
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ${../configs/.p10k.zsh} ]] || source ${../configs/.p10k.zsh} 

          setopt interactivecomments
        '';
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };
    
  };
}
