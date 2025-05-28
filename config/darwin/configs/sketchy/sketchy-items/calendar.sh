SCRIPT_CALENDAR="$(cat <<'EOM'

sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
EOM
)"

SCRIPT_CLICK_CALENDAR="$(cat <<'EOM'
for (( i=0; i <= 5; ++i ))
do
    sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M:%S')" \
                           label.width=65
    sleep 1
done
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" \
                       label.width=40
EOM
)"

calendar=(
  icon.font="$FONT:Black:12.0"
  icon.padding_right=0
  label.width=45
  label.align=center
  label.padding_right=0
  update_freq=30
  script="$SCRIPT_CALENDAR"
  click_script="$SCRIPT_CLICK_CALENDAR"
)

sketchybar --add item calendar right       \
           --set calendar "${calendar[@]}" \
           --subscribe calendar system_woke