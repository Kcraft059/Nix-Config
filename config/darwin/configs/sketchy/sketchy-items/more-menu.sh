# sketchybar --query default_menu_items
menucontrols=(
  "Control__Center,UserSwitcher"
  "Control__Center,Bluetooth"
)

SCRIPT_CLICK_SEPARATOR_MORE="$(
  cat <<EOM
INNER_PADDINGS=$INNER_PADDINGS
FONT="$FONT"
controls=(
${menucontrols[@]}
)
menuitems=(
  pkgs
)
EOM
) $(cat <<'EOF'

ICON_VALUE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.icon.value')"
if [[ $ICON_VALUE = "􀯶" ]]; then
  STATE=off
else
  STATE=on
fi

menu_set() {
  for item in ${menuitems[@]}; do
    sketchybar --animate tanh 15 \
               --set moremenu.$item drawing=$1
  done

  for item in "${controls[@]}"; do
    item=$(echo "$item" | sed -e "s/__/ /g")
    sketchybar --animate tanh 15 \
               --set "$item" drawing=$1
  done

  if [ $1 = "on" ]; then
    sketchybar --trigger more-menu-update
  fi
}
if [ $STATE = "on" ]; then
  menu_set "off"
  separator=(
    icon="􀯶"
    icon.font="$FONT:Semibold:14.0"
    icon.padding_left=$INNER_PADDINGS
    icon.padding_right=$INNER_PADDINGS
  )
  sketchybar --set $NAME icon.y_offset=0 \
             --animate tanh 15 \
             --set $NAME "${separator[@]}"
else
  menu_set "on"
  separator=(
    icon="|"
    icon.font="$FONT:Bold:16.0"
    icon.padding_left=0
    icon.padding_right=0
  )
  sketchybar --set $NAME icon.y_offset=2 \
             --animate tanh 15 \
             --set $NAME "${separator[@]}"
fi
EOF
)"

separator=(
  icon=􀯶
  label.drawing=off
  icon.font="$FONT:Semibold:14.0"
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color=$SUBTLE_MOON
  click_script="$SCRIPT_CLICK_SEPARATOR_MORE"
)

sketchybar --add item separator-more right \
  --set separator-more "${separator[@]}" \
  --add event more-menu-update