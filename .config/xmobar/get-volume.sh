#!/bin/bash
# ~/.config/xmobar/get-volume.sh
# Estilo idéntico al now-playing.sh: paths absolutos + printf + FA icons

set -euo pipefail

PULSECMD="/usr/bin/pactl"
AWK="/usr/bin/awk"
GREP="/usr/bin/grep"
SED="/usr/bin/sed"
PRINTF="/usr/bin/printf"
TR="/usr/bin/tr"

# Colores (ajusta a tu paleta)
COLOR_MAIN="#abb2bf"
COLOR_MUTED="#e06c75"

# Iconos Font Awesome 6 Free Solid (asegúrate de tenerlos en additionalFonts y usar <fn=2>)
ICON_MUTE=$'\uf6a9'   # mute
ICON_LOW=$'\uf027'    # volumen bajo
ICON_MED=$'\uf027'    # (puedes reutilizar LOW)
ICON_HIGH=$'\uf028'   # volumen alto


# Detecta sink por defecto (PipeWire/Pulse)
DEFAULT_SINK="$($PULSECMD info 2>/dev/null | $GREP 'Default Sink:' | $SED 's/Default Sink: //')"
if [[ -z "${DEFAULT_SINK:-}" ]]; then
  # Fallback: primer sink listado
  DEFAULT_SINK="$($PULSECMD list short sinks 2>/dev/null | $AWK 'NR==1{print $1}')"
fi

if [[ -z "${DEFAULT_SINK:-}" ]]; then
  # Ni siquiera hay pulse corriendo
  $PRINTF "<fc=%s><fn=2>%s</fn></fc> --\n" "$COLOR_MUTED" "$ICON_MUTE"
  exit 0
fi

# Estado mute
MUTED="$($PULSECMD get-sink-mute "$DEFAULT_SINK" 2>/dev/null | $AWK '{print $2}' | $TR -d '\n')"

# Volumen: toma la primera línea y el promedio mostrado por pactl (campo /xx%/)
VOL="$($PULSECMD get-sink-volume "$DEFAULT_SINK" 2>/dev/null | $AWK -F'/' 'NR==1{gsub(/%/,"",$2); gsub(/ /,"",$2); print $2}')"
VOL="${VOL:-0}"

# Construye salida
if [[ "${MUTED:-no}" == "yes" || "$VOL" -eq 0 ]]; then
  $PRINTF "<fc=%s><fn=2>%s</fn></fc> muted\n" "$COLOR_MUTED" "$ICON_MUTE"
  exit 0
fi

ICON="$ICON_HIGH"
if   [[ "$VOL" -lt 34 ]]; then ICON="$ICON_LOW"
elif [[ "$VOL" -lt 67 ]]; then ICON="$ICON_MED"
fi

$PRINTF "<fc=%s><fn=2>%s</fn></fc> %s%%\n" "$COLOR_MAIN" "$ICON" "$VOL"
