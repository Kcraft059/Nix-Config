SCRIPT_CLICK_BATTERY="$(
  cat <<'EOM'
if [ $BUTTON = "right" ]; then 
  menubar -s "Control Center,Battery"
else 
  menubar -s "Battery Toolkit,Item-0"
fi
EOM
)"
SCRIPT_BATTERY="$(
  cat <<EOM
TEXT_MOON=$TEXT_MOON
PINE_MOON=$PINE_MOON
FOAM_MOON=$FOAM_MOON
GOLD_MOON=$GOLD_MOON
ROSE_MOON=$ROSE_MOON
LOVE_MOON=$LOVE_MOON
IRIS_MOON=$IRIS_MOON
SUBTLE_MOON=$SUBTLE_MOON
EOM
) $(
  cat <<'EOM'
PERCENTAGE=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)
ACCONNECTED=$(pmset -g batt | grep 'AC Power')
NOTCHARGING=$(pmset -g batt | grep 'not charging')

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

DRAWING=on
COLOR=$TEXT_MOON
case ${PERCENTAGE} in
  9[0-9]|100) ICON=􀛨; COLOR=$PINE_MOON
  ;;
  [6-8][0-9]) ICON=􀺸; COLOR=$FOAM_MOON
  ;;
  [3-5][0-9]) ICON=􀺶; COLOR=$GOLD_MOON
  ;;
  [1-2][0-9]) ICON=􀛩; COLOR=$ROSE_MOON
  ;;
  *) ICON=􀛪; COLOR=$LOVE_MOON
esac

if [[ $ACCONNECTED != "" ]]; then
  ICON=􀢋

  if [[ $NOTCHARGING != "" ]]; then
    COLOR=$SUBTLE_MOON
  else
    COLOR=$IRIS_MOON
  fi
fi

sketchybar --set $NAME icon="$ICON" icon.color=$COLOR label="$PERCENTAGE %"
EOM
)"

battery=(
  script="$SCRIPT_BATTERY"
  click_script="$SCRIPT_CLICK_BATTERY"
  #icon=􀺸
  icon.font="$FONT:Regular:16.0"
  icon.padding_left=$(($OUTER_PADDINGS - 4))
  icon.padding_right=0
  label=""
  label.font="$FONT:Semibold:10.0"
  label.padding_left=$INNER_PADDINGS
  label.padding_right=$OUTER_PADDINGS
  update_freq=120
  updates=on
)

sketchybar --add item battery right \
  --set battery "${battery[@]}" \
  --subscribe battery power_source_change system_woke
