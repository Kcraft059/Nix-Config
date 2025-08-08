SCRIPT_MUSIC="$(cat <<'EOF'
#SKETCHYBAR_MEDIASTREAM#

pids=$(ps -p $(pgrep sh) | grep '#SKETCHYBAR_MEDIASTREAM#' | awk '{print $1}')

if [[ -n "$pids" ]]; then
  #echo killing $pids
  kill -9 $pids
fi

media-control stream | grep --line-buffered 'data' | while IFS= read -r line; do

  if ! { 
   [[ "$(echo $line | jq -r .payload)" == '{}' ]] || 
   { [[ -n "$lastAppPID" ]] && ! ps -p "$lastAppPID" > /dev/null; }; 
  }; then

    artworkData=$(echo $line | jq -r .payload.artworkData)

    if [[ $artworkData != "null" ]];then

      tmpfile=$(mktemp ${TMPDIR}sketchybar/cover.XXXXXXXXXX)

      echo $artworkData | \
        base64 -d > $tmpfile

      if [[ -n "$(head -c 50 $tmpfile | grep 'PNG')" ]]; then
        mv $tmpfile $tmpfile.png

        scale=$(bc <<< "scale=4; (600 - $(identify -ping -format '%h' $tmpfile.png)) / 15000 + 0.04 ")

        sketchybar --set $NAME background.image=$tmpfile.png \
                               background.image.scale=$scale
      else
        mv $tmpfile $tmpfile.jpg

        scale=$(bc <<< "scale=4; (600 - $(identify -ping -format '%h' $tmpfile.jpg)) / 15000 + 0.04 ")

        sketchybar --set $NAME background.image=$tmpfile.jpg \
                               background.image.scale=$scale
      fi

      rm -f $tmpfile*
    fi

    if [[ $(echo $line | jq -r .payload.title) != "null" ]];then

      title_label="$(echo $line | jq -r .payload.title)"
      subtitle_label="$(echo $line | jq -r .payload.artist) • $(echo $line | jq -r .payload.album)"

      sketchybar --set $NAME.title label="$title_label" \
                 --set $NAME.subtitle label="$subtitle_label"
    fi

    currentPID=$(echo $line | jq -r .payload.processIdentifier)

    if [[ $currentPID != "null" ]];then
      echo setting $currentPID
      lastAppPID=$currentPID
    fi

    sketchybar --set $NAME drawing=on \
               --set $NAME.title drawing=on \
               --set $NAME.subtitle drawing=on

  else

    sketchybar --set $NAME drawing=off \
             --set $NAME.title drawing=off \
             --set $NAME.subtitle drawing=off
    lastAppPID=""

  fi
done

EOF
)"

TITLE_MARGIN=11
INFO_WIDTH=80

music_artwork=(
  #icon=􀙫
  script="$SCRIPT_MUSIC"
  #click_script="$SCRIPT_CLICK_WIFI"
  icon.padding_right=0
  background.drawing=on
  background.height=$(($BAR_HEIGHT - $TITLE_MARGIN + 4))
  #background.image.scale=0.04
  background.image.border_color=$MUTED_MOON
  background.image.border_width=1
  background.image.corner_radius=4
  background.image.padding_right=1
  #scroll_duration=100
  update_freq=0
  padding_left=0
  padding_right=4
)

music_title=(
  label=Title
  label.color=$TEXT_MOON
  icon.drawing=off
  #background.color=0xff0000ff
  background.height=8
  label.align=right
  label.width=$INFO_WIDTH
  label.max_chars=13
  label.font="$FONT:Semibold:10.0"
  scroll_texts=on
  #scroll_duration=50
  padding_left=-$INFO_WIDTH
  padding_right=0
  y_offset=$(($BAR_HEIGHT / 2 - $TITLE_MARGIN))
)

music_subtitle=(
  label=SubTitle
  label.color=$SUBTLE_MOON
  icon.drawing=off
  #background.color=0xffff0000
  background.height=8
  label.align=right
  label.width=$INFO_WIDTH
  label.max_chars=14
  label.font="$FONT:Semibold:9.0"
  scroll_texts=on
  #scroll_duration=10
  padding_left=0
  padding_right=0
  y_offset=$(( - ($BAR_HEIGHT / 2) + $TITLE_MARGIN))
)

sketchybar --add item music right \
  --set music "${music_artwork[@]}" \
  --add item music.title right \
  --set music.title "${music_title[@]}" \
  --add item music.subtitle right \
  --set music.subtitle "${music_subtitle[@]}" #\
  #--subscribe music-player media_change
  #--add event mediachange MPMusicPlayerControllerNowPlayingItemDidChange \