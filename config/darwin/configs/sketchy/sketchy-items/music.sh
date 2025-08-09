ARTWORK_MARGIN=5
TITLE_MARGIN=11
INFO_WIDTH=80

SCRIPT_MUSIC="$(cat <<EOF
ARTWORK_MARGIN=$ARTWORK_MARGIN
BAR_HEIGHT=$BAR_HEIGHT
PATH=$PATH

EOF
) $(cat <<'EOF'
#SKETCHYBAR_MEDIASTREAM#

pids=$(ps -p $(pgrep sh) | grep '#SKETCHYBAR_MEDIASTREAM#' | awk '{print $1}')

if [[ -n "$pids" ]]; then
  pids+=" $(cat ${TMPDIR}/sketchybar/pids)"
  echo killing "#SKETCHYBAR_MEDIASTREAM# pids:" $pids
  kill -9 $pids
fi

media-control stream | grep --line-buffered 'data' | while IFS= read -r line; do

  if ps -p $$>/dev/null; then # list childs to prevent multiple background process remaining
    pgrep -P $$ >${TMPDIR}/sketchybar/pids
  fi

  if ! { 
   [[ "$(echo $line | jq -r .payload)" == '{}' ]] || 
   { [[ -n "$lastAppPID" ]] && ! ps -p "$lastAppPID" > /dev/null; }; 
  }; then

    artworkData=$(echo $line | jq -r .payload.artworkData)
    currentPID=$(echo $line | jq -r .payload.processIdentifier)
    playing=$(echo $line | jq -r .payload.playing)

    # Set Artwork

    if [[ $artworkData != "null" ]];then

      tmpfile=$(mktemp ${TMPDIR}sketchybar/cover.XXXXXXXXXX)

      echo $artworkData | \
        base64 -d > $tmpfile

      case $(identify -ping -format '%m' $tmpfile) in
        "JPEG") ext=jpg
        mv $tmpfile $tmpfile.$ext
        ;;
        "PNG") ext=png
        mv $tmpfile $tmpfile.$ext
        ;;
        "TIFF") 
        mv $tmpfile $tmpfile.tiff
        magick $tmpfile.tiff $tmpfile.jpg
        ext=jpg
        ;;
      esac

      scale=$(bc <<< "scale=4; 
        ( ($BAR_HEIGHT - $ARTWORK_MARGIN * 2) / $(identify -ping -format '%h' $tmpfile.$ext) )
      ")
      icon_width=$(bc <<< "scale=0; 
        ( $(identify -ping -format '%w' $tmpfile.$ext) * $scale )
      ")

      sketchybar --set $NAME background.image=$tmpfile.$ext \
                             background.image.scale=$scale \
                             icon.width=$(printf "%.0f" $icon_width)

      rm -f $tmpfile*
    fi

    # Set Title and artist + ?Album

    if [[ $(echo $line | jq -r .payload.title) != "null" ]];then

      title_label="$(echo $line | jq -r .payload.title)"
      artist=$(echo "$line" | jq -r .payload.artist)
      album=$(echo "$line" | jq -r .payload.album)
      
      subtitle_label="$artist"
      if [[ -n "$album" ]]; then
        subtitle_label+=" • $album"
      fi

      sketchybar --set $NAME.title label="$title_label" \
                 --set $NAME.subtitle label="$subtitle_label"
    fi

    # Set Playing state indicator

    if [[ $playing != "null" && $(echo $line | jq -r .diff) == "true" ]];then
      case $playing in
        "true") sketchybar --set $NAME icon.padding_left=-3 \
                           --animate tanh 5 \
                           --set $NAME icon="􀊆" \
                                       icon.drawing=on 
        {
          sleep 5
          sketchybar --animate tanh 45 --set $NAME icon.drawing=false
        } &
        ;;
        "false") sketchybar --set $NAME icon.padding_left=0 \
                            --animate tanh 5 \
                            --set $NAME icon="􀊄" \
                                        icon.drawing=on 
        {
          sleep 5
          sketchybar --animate tanh 45 --set $NAME icon.drawing=false
        } &
        ;;
      esac
    fi

    if [[ $currentPID != "null" ]];then
      lastAppPID=$currentPID
    fi

    sketchybar --set $NAME drawing=on \
               --set $NAME.title drawing=on \
               --set $NAME.subtitle drawing=on \
               --trigger activities_update
    

  else

    sketchybar --set $NAME drawing=off \
             --set $NAME.title drawing=off \
             --set $NAME.subtitle drawing=off \
             --trigger activities_update

    lastAppPID=""

  fi
done

EOF
)"

SCRIPT_CLICK_MUSIC_ARTWORK="$(cat <<EOF
PATH=$PATH

EOF
) $(cat <<'EOF'
media-control toggle-play-pause
EOF
)"

SCRIPT_CLICK_MUSIC_TITLE="$(cat <<'EOF'
menubar -s "Control Center,NowPlaying"
EOF
)"

SCRIPT_CENTER_SEP="$(cat <<'EOF'
GRAPHSTATE="$(sketchybar --query graph | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.drawing')"
MUSICSTATE="$(sketchybar --query music | sed 's/\\n//g; s/\\\$//g; s/\\ //g' | jq -r '.geometry.drawing')"

activitycount=0

if [ "$GRAPHSTATE" = "on" ]; then ((activitycount++)); fi
if [ "$MUSICSTATE" = "on" ]; then ((activitycount++)); fi

if [ $activitycount -gt 0 ]; then
  sketchybar --set separator_center drawing=on
else
  sketchybar --set separator_center drawing=off
fi

EOF
)"

music_artwork=(
  drawing=off
  script="$SCRIPT_MUSIC"
  click_script="$SCRIPT_CLICK_MUSIC_ARTWORK"
  icon="􀊆"
  icon.drawing=off
  icon.color=$HIGH_MED_MOON
  icon.shadow.drawing=on
  icon.shadow.color=$BAR_COLOR
  icon.shadow.distance=3
  icon.align=center
  label.drawing=off
  icon.padding_right=0
  icon.padding_left=-3
  background.drawing=on
  background.height=$(($BAR_HEIGHT - $ARTWORK_MARGIN * 2))
  background.image.border_color=$MUTED_MOON
  background.image.border_width=1
  background.image.corner_radius=4
  background.image.padding_right=1
  update_freq=0
  padding_left=0
  padding_right=8
)

music_title=(
  label=Title
  drawing=off
  click_script="$SCRIPT_CLICK_MUSIC_TITLE"
  label.color=$TEXT_MOON
  icon.drawing=off
  #background.color=0xff0000ff
  #background.height=8
  label.align=right
  label.width=$INFO_WIDTH
  label.max_chars=13
  label.font="$FONT:Semibold:10.0"
  scroll_texts=on
  padding_left=-$INFO_WIDTH
  padding_right=0
  y_offset=$(($BAR_HEIGHT / 2 - $TITLE_MARGIN))
)

music_subtitle=(
  label=SubTitle
  drawing=off
  click_script="$SCRIPT_CLICK_MUSIC_TITLE"
  label.color=$SUBTLE_MOON
  icon.drawing=off
  #background.color=0xffff0000
  #background.height=8
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

center_separator=(
  icon="|"
  script="$SCRIPT_CENTER_SEP"
  icon.color=$SUBTLE_MOON
  icon.font="$FONT:Bold:16.0"
  icon.y_offset=2
  label.drawing=off
  icon.padding_left=0
  icon.padding_right=0
  update_freq=0
  updates=on
)

sketchybar --add item separator_center center \
           --set separator_center "${center_separator[@]}" \
           --add event activities_update #\
sketchybar --subscribe separator_center activities_update

sketchybar --add item music q \
  --set music "${music_artwork[@]}" \
  --add item music.title q \
  --set music.title "${music_title[@]}" \
  --add item music.subtitle q \
  --set music.subtitle "${music_subtitle[@]}" #\

  #--subscribe music-player media_change
  #--add event mediachange MPMusicPlayerControllerNowPlayingItemDidChange \