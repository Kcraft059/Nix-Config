SCRIPT_CLICK_DISPLAY="PATH=$PATH $(cat <<'EOM'

betterdisplaycli toggle --appmenu
EOM
)"
# betterdisplaycli get --identifiers --devicetype=DisplayGroup
SCRIPT_DISPLAY="PATH=$PATH $(cat <<'EOM'

displaygroups=(
  "Built-in"
  "Built-in + External"
  "Dual External"
)

ICON="􀢹"
if [ -n "$(pgrep "BetterDisplay")" ]; then
  for displayGroup in "${displaygroups[@]}"; do
    if [ "$(betterdisplaycli get --name="$displayGroup" --active)" = "on" ]; then
      case "$displayGroup" in
        'Built-in') ICON="􁈸"
        ;;
        'Built-in + External') ICON="􂤓"
        ;;
        'Dual External') ICON="􀨧"
        ;;
      esac
    fi
  done
  sketchybar --set $NAME icon="$ICON" drawing="on" 
else
  sketchybar --set $NAME drawing="off"
fi
EOM
)"

display=(
  icon=􀨧
  click_script="$SCRIPT_CLICK_DISPLAY"
  script="$SCRIPT_DISPLAY"
  icon.color=$PINE_MOON
  icon.padding_right=2
  label.max_chars=10
  label.font="$FONT:Semibold:10.0"
  scroll_texts=on
  #scroll_duration=100
  padding_left=0
  padding_right=0
  label.drawing=off
)

sketchybar --add item display right \
  --set display "${display[@]}" \
  --subscribe display system_woke display_change