SCRIPT_VOLUME_CLICK="$(
  cat <<'EOM'
WIDTH=100

detail_on() {
  sketchybar --animate tanh 30 --set volume slider.width=$WIDTH
}

detail_off() {
  sketchybar --animate tanh 30 --set volume slider.width=0
}

toggle_detail() {
  if [ $BUTTON = "left" ]; then
    INITIAL_WIDTH=$(sketchybar --query volume | sed 's/\\n/\\\\n/g; s/\\\$/$/g' | jq -r '.slider.width')
    if [ "$INITIAL_WIDTH" -eq "0" ]; then
      detail_on
    else
      detail_off
    fi
  else
    menubar -s "Control Center,Sound"
  fi
}

toggle_detail

EOM
)"

SCRIPT_VOLUME="$(
  cat <<'EOM'
WIDTH=100
ICONS_VOLUME=(􀊣 􀊡 􀊥 􀊧 􀊩)
volume_change() {
  case $INFO in
    [6-9][0-9]|100) ICON=${ICONS_VOLUME[4]}
    ;;
    [3-5][0-9]) ICON=${ICONS_VOLUME[3]}
    ;;
    [1-2][0-9]) ICON=${ICONS_VOLUME[2]}
    ;;
    [1-9]) ICON=${ICONS_VOLUME[1]}
    ;;
    0) ICON=${ICONS_VOLUME[0]}
    ;;
    *) ICON=${ICONS_VOLUME[4]}
  esac

  sketchybar --set volume_icon icon=$ICON

  sketchybar --set $NAME slider.percentage=$INFO \
             --animate tanh 30 --set $NAME slider.width=$WIDTH 

  sleep 2

  # Check wether the volume was changed another time while sleeping
  FINAL_PERCENTAGE=$(sketchybar --query $NAME | jq -r ".slider.percentage")
  if [ "$FINAL_PERCENTAGE" -eq "$INFO" ]; then
    sketchybar --animate tanh 30 --set $NAME slider.width=0
  fi
}

mouse_clicked() {
  osascript -e "set volume output volume $PERCENTAGE"
}

mouse_entered() {
  sketchybar --set $NAME slider.knob.drawing=on
}

mouse_exited() {
  sketchybar --set $NAME slider.knob.drawing=off
}

case "$SENDER" in
  "volume_change") volume_change
  ;;
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") mouse_entered
  ;;
  "mouse.exited") mouse_exited
  ;;
esac
EOM
)"

volume_slider=(
  script="$SCRIPT_VOLUME"
  updates=on
  padding_left=0
  padding_right=0
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$PINE_MOON
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$MUTED_MOON
  slider.knob=􀀁
  slider.knob.drawing=off
)

volume_icon=(
  click_script="$SCRIPT_VOLUME_CLICK"
  icon.align=left
  icon.padding_left=$(($OUTER_PADDINGS - 3))
  icon.padding_right=$OUTER_PADDINGS

  icon.color=$IRIS_MOON
  #label.width=32
  label.padding_left=0
  label.padding_right=0
  label.align=left
  label.font="$FONT:Regular:14.0"
)

sketchybar --add slider volume right \
  --set volume "${volume_slider[@]}" \
  --subscribe volume volume_change \
  mouse.clicked \
  mouse.entered \
  mouse.exited \
  \
  --add item volume_icon right \
  --set volume_icon "${volume_icon[@]}"

add_separator "1" "right"