SCRIPT_CALENDAR="$(cat <<'EOM'

sleep $((59 - $(date '+%S')))

while [[ $(date '+%S') != "00" ]]; do
  sleep 0.1
done
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"

EOM
)"

SCRIPT_CLICK_CALENDAR="$(
  cat <<'EOM'
for (( i=0; i <= 5; ++i )); do
    sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M:%S')" \
                           label.width=65
    sleep 1
done
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')" \
                       label.width=40
EOM
)"

calendar=(
  icon="$(date '+%a %d. %b')" 
  label="$(date '+%H:%M')"
  icon.font="$FONT:Black:12.0"
  icon.padding_right=0
  label.width=50
  label.align=center
  label.padding_right=0
  update_freq=60
  script="$SCRIPT_CALENDAR"
  click_script="$SCRIPT_CLICK_CALENDAR"
)

sketchybar --add item calendar right \
  --set calendar "${calendar[@]}" #\
  #--subscribe calendar system_woke
add_separator "0" "right"
