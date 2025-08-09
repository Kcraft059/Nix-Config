# See : https://github.com/FelixKratz/dotfiles/blob/e6288b3f4220ca1ac64a68e60fced2d4c3e3e20b/.config/sketchybar/helper/cpu.h
GRAPH_MARGIN=4
GRAPH_WIDTH=140
PERCENT_WIDTH=24

GRAPH_SCRIPT="$(cat <<EOF
PINE_MOON=$PINE_MOON
GOLD_MOON=$GOLD_MOON
ROSE_MOON=$ROSE_MOON
LOVE_MOON=$LOVE_MOON
SUBTLE_MOON=$SUBTLE_MOON
EOF
) $(cat <<'EOF'

systempower=$(macmon pipe -s 1 -i 1 | jq -r .sys_power)
probe=$(/bin/ps -Aceo pid,pcpu,comm -r | awk 'NR==2')

topprog_percent=$(echo "$probe" | awk '{print $2}')
topprog=$(echo "$probe" | awk '{print $3}')
topprog_pid=$(echo "$probe" | awk '{print $1}')

if [ $(printf "%.0f" $topprog_percent) -gt 100 ]; then
  LABEL_COLOR=$LOVE_MOON
else
  LABEL_COLOR=$SUBTLE_MOON
fi

graphlabel="${topprog_percent}% - $topprog [$topprog_pid]"

#graphpercent=$(awk -v min=0 -v max=100 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
graphpercent=$(top -l1 -n1 | grep "^CPU usage:" | awk '{gsub(/%/,"",$3); print $3}')
graphpoint=$(bc <<< "scale=1; $graphpercent / 100 ")

case $(printf "%.0f" $graphpercent) in
  [8-9][0-9] | 7[5-9] | 100) COLOR=$LOVE_MOON
  ;;
  [5-6][0-9] | 7[0-4]) COLOR=$ROSE_MOON
  ;;
  [3-5][0-9] | 2[5-9] ) COLOR=$GOLD_MOON
  ;;
  [5-9] | 1[0-9] | 2[0-4]) COLOR=$PINE_MOON
  ;;
  *) COLOR=$SUBTLE_MOON
esac

sketchybar --push $NAME $graphpoint \
           --set $NAME.percent label="$(printf "%.0f" $graphpercent)%" \
           --set $NAME graph.color=$COLOR 

graphlabel="${topprog_percent}% - $topprog [$topprog_pid] | $(printf '%.2f' $systempower)W"


sketchybar --set $NAME.label label="$graphlabel" label.color="$LABEL_COLOR"

EOF
)"

graph=(
  graph.color=$SUBTLE_MOON
  drawing=off
  y_offset=$((- $BAR_HEIGHT / 2 + $GRAPH_MARGIN + 7 ))
  padding_left=0
  padding_right=0
  icon.drawing=off
  label.drawing=off
  background.padding_left=4
  background.padding_right=0
  #background.color=$LOVE_MOON
  background.drawing=on
  background.height=$(($BAR_HEIGHT - $GRAPH_MARGIN * 2 - 9 ))
  script="$GRAPH_SCRIPT"
  update_freq=2
)

graph_percent=(
  drawing=off
  padding_left=8
  padding_right=0
  y_offset=$((- $BAR_HEIGHT / 2 + $GRAPH_MARGIN + 8))
  label.padding_right=0
  label.padding_left=0
  icon.drawing=off
  label.drawing=on
  #background.color=$LOVE_MOON
  background.drawing=off
  label="37%"
  label.width=$PERCENT_WIDTH
  label.font="$FONT:Bold:10.0"
)

graph_label=(
  drawing=off
  padding_left=-$PERCENT_WIDTH
  padding_right=-$GRAPH_WIDTH
  label.width=$(($GRAPH_WIDTH + $PERCENT_WIDTH))
  y_offset=$(( $BAR_HEIGHT / 2 - $GRAPH_MARGIN - 5))
  label.padding_right=0
  label.padding_left=0
  icon.drawing=off
  label.drawing=on
  #background.color=$LOVE_MOON
  background.drawing=off
  label="GLUOP ORPI EIOP - EOIYUEUI 33%"
  label.color=$SUBTLE_MOON
  label.font="$FONT:Regular:7.0"
)

sketchybar --add item graph.percent e \
           --set graph.percent "${graph_percent[@]}" \
           --add item graph.label e \
           --set graph.label "${graph_label[@]}" \
           --add graph graph e $GRAPH_WIDTH \
           --set graph "${graph[@]}"