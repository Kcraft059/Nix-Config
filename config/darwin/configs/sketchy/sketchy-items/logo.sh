SCRIPT_POPUP_TOGGLE="$(
  cat <<EOM
X_BAR_PADDING=$X_BAR_PADDING
PINE_MOON=$PINE_MOON
TEXT_MOON=$TEXT_MOON
FONT="$FONT"
EOM
) $(
  cat <<'EOM'

STATE="$(sketchybar --query $NAME | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.background.drawing')"
if [ -z "$STATE" ]; then STATE="off"; fi
menu_on() {
  for space in $(sketchybar --query spaces | jq -r '.bracket[]'); do
    sketchybar --set $space drawing=off
  done
  sketchybar --set spaces drawing=off \
    --set separator drawing=off \
    --set front_app drawing=off \
    --animate tanh 15 --set $NAME background.drawing=on \
    icon.color=$PINE_MOON \
    icon=􀣺 \
    icon.font="$FONT:Black:17.0" \
    icon.y_offset=1 \
    padding_right=5 \
    padding_left=5
  update_menus
  sleep 30
  menu_off
}

menu_off() {
  for space in $(sketchybar --query spaces | jq -r '.bracket[]'); do
    sketchybar --set $space drawing=on
  done
  sketchybar --set spaces drawing=on \
    --set separator drawing=on \
    --set front_app drawing=on \
    --animate tanh 15 --set $NAME background.drawing=off \
    icon.color=$TEXT_MOON \
    icon=􀆔 \
    icon.font="$FONT:Semibold:14.0" \
    icon.y_offset=0 \
    padding_right=10 \
    padding_left=$X_BAR_PADDING
  mid=1
  while [ $mid -le 10 ]; do
    sketchybar --set menu.$mid drawing=off
    mid=$((mid + 1))
  done
}

toggle_menu() {
  if [ $BUTTON = "right" ]; then
    if [ $STATE = "off" ]; then
      menu_on
    elif [ $STATE = "on" ]; then
      menu_off
    fi
  elif [ $MODIFIER = "shift" ]; then
    sketchybar --reload
  else
    if [ $STATE = "off" ]; then
      /System/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control
    elif [ $STATE = "on" ]; then
      menubar -s 0
    fi
  fi
}

update_menus() {
  mid=1
  while IFS= read -r menu; do
    sketchybar --set menu.$mid icon="$menu" drawing=on
    mid=$(($mid + 1))
  done < <(menubar -l)
  while [ $mid -le 10 ]; do
    sketchybar --set menu.$mid drawing=off
    mid=$((mid + 1))
  done
}

case "$SENDER" in
"mouse.clicked")
  toggle_menu
  ;;
"front_app_switched")
  if [ $STATE = "on" ]; then
    update_menus
    sleep 1
    update_menus
  fi
  ;;
*) if [ $STATE = "on" ]; then update_menus; fi ;;
esac
EOM

)"

logo=(
  icon=􀆔
  padding_left=$X_BAR_PADDING
  padding_right=10
  icon.font="$FONT:Semibold:14.0"
  icon.color=$TEXT_MOON
  icon.padding_left=8
  icon.padding_right=8
  script="$SCRIPT_POPUP_TOGGLE"
  label.drawing=off
  background.height=$(($BAR_HEIGHT - 8))
  background.border_width=2
  background.border_color=$HIGH_MED_MOON
  background.color=$OVERLAY_MOON
  background.drawing=off
)

prefs=(
  icon=e
  label="Preferences"
  click_script="open -a 'System Preferences'; $POPUP_OFF"
)

sketchybar --add item logo left \
  --set logo "${logo[@]}" \
  --subscribe logo front_app_switched mouse.clicked \
  --add item logo.prefs popup.logo \
  --set logo.prefs "${prefs[@]}"
