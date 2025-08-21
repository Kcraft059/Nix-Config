#!/bin/bash
list_nix_packages() {
  for x in $(nix-store --query --requisites "/run/current-system"); do
    if [ -d "$x" ]; then
      echo "$x"
    fi
  done | cut -d- -f2- |
    egrep '([0-9]{1,}\.)+[0-9]{1,}' |
    egrep -v '\-doc$|\-man$|\-info$|\-dev$|\-bin$|^nixos-system-nixos-' |
    uniq |
    wc -l
}

sketchybar --set $NAME label="$(($(list_nix_packages) - 0))"