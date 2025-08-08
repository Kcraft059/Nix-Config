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

SCRIPT_PKGS="$(cat <<'EOF'
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
EOF
)"

pkgs=(
  drawing=off
  script="$SCRIPT_PKGS"
  #click_script="$SCRIPT_CLICK_PKGS"
  icon=􀐛
  icon.color=$ROSE_MOON
  icon.font="$FONT:Regular:14.0"
  icon.padding_left=0 #$(($OUTER_PADDINGS - 4))
  icon.padding_right=0
  label=""
  label.font="$FONT:Semibold:10.0"
  label.padding_left=$INNER_PADDINGS
  label.padding_right=$OUTER_PADDINGS
  update_freq=120
  updates=when_shown
)

sketchybar --add item moremenu.pkgs right \
  --set moremenu.pkgs "${pkgs[@]}" \
  --subscribe moremenu.pkgs more-menu-update