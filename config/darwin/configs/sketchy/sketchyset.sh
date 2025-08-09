sketchybar --add bracket base-controls battery wifi display \
  --set base-controls "${zones[@]}" \
  --add bracket volume_controls volume_icon mic \
  --set volume_controls "${zones[@]}" \
  --add bracket more_menu '/moremenu\..*/' "${menuitem[@]}" \
  --set more_menu "${zones[@]}" 

sketchybar --update

echo "sketchybar configuation loaded.."
