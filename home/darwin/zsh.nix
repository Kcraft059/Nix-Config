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
    # Load the default Powerlevel10k configuration
    # Different of initExtra by adding First, it will be the first entry to be added

    initContent = lib.mkBefore ''
      alias os-switch="${os-switch}"
      alias fzf-p="fzf --preview='bat --color=always --style=numbers {}' --bind 'focus:transform-header:file --brief {}'"
      export XDG_CONFIG_HOME=$HOME/.config # Needed for some programs
    '';
  };
}
