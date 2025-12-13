{
  pkgs,
  lib,
  config,
  ...
}:
let
  os-switch = "${pkgs.writeShellScriptBin "os-switch" ''
    #!/bin/bash
    sudo bless -mount "/Volumes/$(ls /Volumes/ | fzf)" -setBoot
    echo -ne "Reboot? (y/n): "
    read reboot_cf
    if [[ "$reboot_cf" =~ ^[Yy]$ ]]; then
      sudo reboot
    fi
    unset reboot_cf
  ''}/bin/os-switch";
in
{
  programs.zsh = {
    enable = true;
    # Load the default Powerlevel10k configuration
    # Different of initExtra by adding First, it will be the first entry to be added

    initContent =
      lib.mkBefore 
        ''
          # p10k config
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          [[ ! -f ${../configs/.p10k.zsh} ]] || source ${../configs/.p10k.zsh} 

          setopt interactivecomments

          alias ll="eza --long --header --git --icons=auto"
          alias os-switch="${os-switch}"
          alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
        '';
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };

  };
}
