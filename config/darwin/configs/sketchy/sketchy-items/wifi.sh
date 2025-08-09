SCRIPT_WIFI="$(cat <<EOM
PINE_MOON=$PINE_MOON
FOAM_MOON=$FOAM_MOON
ROSE_MOON=$ROSE_MOON
LOVE_MOON=$LOVE_MOON
ICON_HOTSPOT=􀉤
ICON_WIFI=􀙇
ICON_WIFI_OFF=􀙈
EOM
) $(
  cat <<'EOM'
WIFI_PORT=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
WIFI=$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1; gsub(":",""); print;exit}') #$(ipconfig getsummary $WIFI_PORT | awk -F': ' '/ SSID : / {print $2}')
HOTSPOT=$(ipconfig getsummary $WIFI_PORT | grep sname | awk '{print $3}')
IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)

if [[ $HOTSPOT != "" ]]; then
  ICON=$ICON_HOTSPOT
  ICON_COLOR=$FOAM_MOON
  LABEL=$HOTSPOT
elif [[ $WIFI != "" ]]; then
  ICON=$ICON_WIFI
  ICON_COLOR=$PINE_MOON
  LABEL=$WIFI
elif [[ $IP_ADDRESS != "" ]]; then
  ICON=$ICON_WIFI
  ICON_COLOR=$ROSE_MOON
  LABEL="on"
else
  ICON=$ICON_WIFI_OFF
  ICON_COLOR=$LOVE_MOON
  LABEL="off"
fi

wifi=(
  icon=$ICON
  label=$LABEL
  icon.color=$ICON_COLOR
)

sketchybar --set $NAME "${wifi[@]}"
EOM
)"

SCRIPT_CLICK_WIFI="$(cat <<'EOM'
WIFI_PORT=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
WIFI=$(ipconfig getsummary $WIFI_PORT | awk -F': ' '/ SSID : / {print $2}')
if [ $BUTTON = "left" ]; then 
  menubar -s "Control Center,WiFi"
else 
  if [[ $WIFI != "" ]]; then 
    sudo ifconfig $WIFI_PORT down
  else 
    sudo ifconfig $WIFI_PORT up
  fi
fi
EOM
)"

wifi=(
  script="$SCRIPT_WIFI"
  click_script="$SCRIPT_CLICK_WIFI"
  label="Searching…"
  icon=􀙥
  icon.color=$SUBTLE_MOON
  icon.padding_right=0
  label.max_chars=10
  label.font="$FONT:Semibold:10.0"
  scroll_texts=on
  #scroll_duration=100
  #update_freq=5
  padding_left=0
  padding_right=0
)
sketchybar --add item wifi right \
  --set wifi "${wifi[@]}" \
  --subscribe wifi wifi_change
