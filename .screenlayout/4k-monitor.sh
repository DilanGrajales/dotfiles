#!/bin/sh

# --- Configuración ---
INTERNAL_MONITOR="DP-4"
EXTERNAL_4K="DP-0"
EXTERNAL_MODE="3840x2160"
WALLPAPER="/usr/share/backgrounds/frame-purple.jpg"

# Pausa breve para que xrandr refresque el estado de los puertos
sleep 1

# Detectar si el monitor 4K está conectado
DETECTED=$(xrandr --query | grep -w "$EXTERNAL_4K connected")

if [ -n "$DETECTED" ]; then
    echo "✅ Monitor 4K Detectado ($EXTERNAL_4K)"
    
    # Aplicamos tu configuración de un solo monitor 4K
    xrandr --output "$EXTERNAL_4K" --primary --mode "$EXTERNAL_MODE" --pos 0x0 --rotate normal \
           --output "$INTERNAL_MONITOR" --off \
           --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-0 --off
else
    echo "⚠️ Monitor 4K no encontrado. Aplicando Fallback ($INTERNAL_MONITOR)..."
    
    # Volver a la pantalla interna de la laptop
    xrandr --output "$INTERNAL_MONITOR" --primary --auto \
           --output "$EXTERNAL_4K" --off \
           --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-0 --off
fi

# --- Post-Configuración ---

# Restaurar fondo de pantalla con feh
if command -v feh >/dev/null 2>&1; then
    feh --bg-fill --no-fehbg "$WALLPAPER"
fi

# Opcional: Reiniciar xmonad o tu barra si los usas
# xmonad --restart
