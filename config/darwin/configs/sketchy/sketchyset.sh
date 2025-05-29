sketchybar --add bracket controls battery wifi display "${menuitem[@]}" \
  --set controls "${zones[@]}" \
  --add bracket volume_controls volume_icon mic \
  --set volume_controls "${zones[@]}"

sketchybar --update

echo "sketchybar configuation loaded.."
