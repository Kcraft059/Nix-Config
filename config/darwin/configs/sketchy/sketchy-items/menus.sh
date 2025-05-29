SCRIPT_CLICK_MENUS="$(
  cat <<'EOM'
menubar -s "$(echo "$NAME" | cut -d '.' -f 2)"
EOM
)"

mid=0
spaces=()
for ((i = 1; i <= 10; ++i)); do
  mid=$i
  space=(
    icon=$i
    label.drawing=off
    click_script="$SCRIPT_CLICK_MENUS"
    drawing=off
  )
  if [ $mid = 1 ]; then
    space+=(
      icon.font="$FONT:Heavy:14:0"
      icon.color=$FOAM_MOON
    )
  fi

  sketchybar --add item menu.$mid left \
    --set menu.$mid "${space[@]}"
  #--subscribe menu.$mid mouse.clicked front_app_switched
done

sketchybar --add bracket menus '/menu\..*/' \
  --set menus "${zones[@]}"
