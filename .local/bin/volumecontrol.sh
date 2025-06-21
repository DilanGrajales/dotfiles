#!/usr/bin/env bash

print_usage() {
  cat <<EOF
Usage: $(basename "$0") <action> [step]

Actions:
    i    <i>ncrease volume [+2%]
    d    <d>ecrease volume [-2%]
    m    toggle <m>ute

Optional:
    step  volume change step [default: 5]

Examples:
    $(basename "${0}") i 10    # Increase volume by 10%
    $(basename "${0}") m       # Toggle mute
EOF
  exit 1
}

get_volume() {
  amixer get Master | awk -F'[][]' '/%/ { print $2; exit }' | tr -d '%'
}

get_mute() {
  amixer get Master | awk '/Mono:/ { print $6 }' | grep -q off && echo "true" || echo "false"
}

notify_vol() {
  local vol=$1
  local delta=$2
  level=$((vol / 34 + 1))
  muted=""
  mute=$(get_mute)
  [ "${mute}" = "true" ] && muted=" (Muted)"
  notify-send -a "volumecontrol.sh" -r 2 -t 800 -h int:value:"${vol}" -i "${icodir}/volume-${level}.svg" "Volume${muted}" "${vol} (${delta})"
}

notify_mute() {
  mute=$(get_mute)
  vol=$(get_volume)
  if [ "${mute}" == "true" ]; then
    notify-send -a "volumecontrol.sh" -r 2 -t 800 -h int:value:"${vol}" -i "${icodir}/muted.svg" "muted" "${vol}"
  else
    notify-send -a "volumecontrol.sh" -r 2 -t 800 -h int:value:"${vol}" -i "${icodir}/volume-3.svg" "unmuted" "${vol}"
  fi
}

change_volume() {
  local action=$1
  local step=$2
  local sign="-"

  [ "${action}" = "i" ] && sign="+"

  vol=$(get_volume)

  [ "${sign}" = "+" ] && [ "${vol}" = "100" ] && notify_vol 100 "..." && exit 0
  [ "${sign}" = "-" ] && [ "${vol}" = "0" ] && notify_vol 0 "..." && exit 0

  amixer set Master "${step}%${sign}" > /dev/null
  vol=$(get_volume)

  [ "${action}" = "d" ] && sign="\-"

  notify_vol "$vol" "$sign$step%"
}

toggle_mute() {
  amixer set Master toggle > /dev/null
  notify_mute
}

step=${VOLUME_STEPS:-2}
icodir="$HOME/.config/dunst/icons"

# Execute action
case $1 in
i | d) change_volume "$1" "${2:-$step}" ;;
m) toggle_mute ;;
*) print_usage ;;
esac