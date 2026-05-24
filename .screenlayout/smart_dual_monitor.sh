#!/bin/sh

# --- Configuración de Monitores ---
INTERNAL_MONITOR="DP-4"

# Monitor Principal (Horizontal 1440p)
MAIN_MONITOR="DP-0"
MAIN_MODE="2560x1440"
MAIN_POS="0x1071" # Tu posición personalizada para alinearlo con el vertical

# Monitor Secundario (Vertical 4K)
VERT_MONITOR="DP-2"
VERT_MODE="3840x2160"
VERT_POS="2560x0"

# --- Lógica de Detección ---

# Pausa breve para dar tiempo a que xrandr detecte cambios al conectar
sleep 1

# Verificamos si los monitores externos están conectados
# Buscamos la cadena exacta "DP-X connected"
MAIN_DETECTED=$(xrandr --query | grep -w "$MAIN_MONITOR connected")
VERT_DETECTED=$(xrandr --query | grep -w "$VERT_MONITOR connected")

if [ -n "$MAIN_DETECTED" ] && [ -n "$VERT_DETECTED" ]; then
    echo "✅ Setup Dual Detectado ($MAIN_MONITOR + $VERT_MONITOR)"
    echo "Apagando pantalla interna y configurando escritorio..."

    # Aplicamos la configuración exacta de tu dual_4k.sh
    xrandr --output "$MAIN_MONITOR" --primary --mode "$MAIN_MODE" -r 75 --pos "$MAIN_POS" --rotate normal \
           --output "$VERT_MONITOR" --mode "$VERT_MODE" -r 60 --pos "$VERT_POS" --rotate right \
           --output "$INTERNAL_MONITOR" --off \
           --output DP-1 --off --output DP-3 --off --output HDMI-0 --off

else
    echo "⚠️ No se detectó el setup completo."
    echo "Volviendo a pantalla interna ($INTERNAL_MONITOR)..."

    # Si no están los dos, encendemos la laptop y apagamos los externos por seguridad
    xrandr --output "$INTERNAL_MONITOR" --primary --auto \
           --output "$MAIN_MONITOR" --off \
           --output "$VERT_MONITOR" --off
fi

# --- Post-Configuración ---

# Esperar a que xrandr termine de parpadear
# sleep 1

# Restaurar fondo de pantalla (Indispensable al cambiar resoluciones)
if command -v feh >/dev/null 2>&1; then
    feh --bg-fill --no-fehbg /usr/share/backgrounds/dark-waves.png
fi
