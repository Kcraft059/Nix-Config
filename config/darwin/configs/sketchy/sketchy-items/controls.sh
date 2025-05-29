# sketchybar --query default_menu_items

menuitem=(
  #"TextInputMenuAgent,Item-0"
  #"BetterDisplay,Item-0"
  #"Control Center,WiFi"
  #"Control Center,Bluetooth"
)

for item in "${menuitem[@]}"; do

  SCRIPT_CLICK_MENU_ITEM="$(
    cat <<'EOM'
menubar -s "$NAME"
EOM
  )"

  alias=(
    #background.color=0xffff0000
    padding_left=0
    padding_right=0
    #x_offset=20
    alias.color=$TEXT_MOON
    label.drawing=off
    icon.drawing=off
    click_script="$SCRIPT_CLICK_MENU_ITEM"
  )

  sketchybar --add alias "$item" right \
    --set "$item" "${alias[@]}"
done
