SCRIPT_SPACES="$(
  cat <<'EOM'
update() {
  WIDTH="dynamic"
  BACKGROUND="on"
  if [ "$SELECTED" = "true" ]; then
    WIDTH="0"
    BACKGROUND="off"
  fi

  sketchybar --animate tanh 20 --set $NAME icon.highlight=$SELECTED label.width=$WIDTH background.drawing=$BACKGROUND
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    yabai -m space --destroy $SID
    sketchybar --trigger space_change --trigger windows_on_spaces
  else
    yabai -m space --focus $SID 2>/dev/null
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
EOM
)"

SCRIPT_SPACE_WINDOWS="$SCRIPT_MAP_ICON $(
  cat <<'EOM'

if [ "$SENDER" = "space_windows_change" ]; then
  space="$(echo "$INFO" | jq -r '.space')"
  apps="$(echo "$INFO" | jq -r '.apps | keys[]')"

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app
    do
      icon_strip+=" $(map_skappicon "$app")"
    done <<< "${apps}"
    sketchybar --set space.$space label="$icon_strip" label.drawing=on #background.drawing=on
  else
    icon_strip=" -"
    sketchybar --set space.$space label.drawing=off #background.drawing=off
  fi

fi
EOM
)"

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")

# Destroy space on right click, focus space on left click.
# New space by left clicking separator (>)

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"; do
  sid=$(($i + 1))

  space=(
    associated_space=$sid
    icon=${SPACE_ICONS[i]}
    icon.padding_left=6
    icon.padding_right=7
    icon.color=$GOLD_MOON
    padding_left=8
    padding_right=2
    background.color=$HIGH_MED_MOON
    background.height=$(($BAR_HEIGHT - 12))
    background.corner_radius=7
    background.drawing=off
    icon.highlight_color=$LOVE_MOON
    label.padding_right=20
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=$(($BAR_HEIGHT - 12))
    label.background.drawing=on
    label.background.color=$HIGH_HIGH_MOON
    label.background.corner_radius=7
    label.y_offset=-1
    label.drawing=off
    script="$SCRIPT_SPACES"
  )

  sketchybar --add space space.$sid left \
    --set space.$sid "${space[@]}" \
    --subscribe space.$sid mouse.clicked
done

separator=(
  icon=􀆊
  label.drawing=off
  icon.font="$FONT:Semibold:14.0"
  associated_display=active
  click_script='yabai -m space --create && sketchybar --trigger space_change'
  icon.color=$SUBTLE_MOON
  script="$SCRIPT_SPACE_WINDOWS"
)

sketchybar --add bracket spaces '/space\..*/' \
  --set spaces "${zones[@]}" \
  --add item separator left \
  --set separator "${separator[@]}" \
  --subscribe separator space_windows_change
