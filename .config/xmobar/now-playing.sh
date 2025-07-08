#!/bin/bash

# --- Configuración ---
PLAYER="tidal-hifi"

# Colores
COLOR_PLAYING="#61afef"
COLOR_PAUSED="#e5c07b"

# --- Lógica del Script ---
# Verifica si el reproductor está activo
if playerctl -l 2>/dev/null | grep -q "$PLAYER"; then
    # El reproductor está abierto, revisamos su estado
    STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
    
    # Función para obtener y formatear metadatos
    get_metadata() {
        ARTIST=$(playerctl --player=$PLAYER metadata artist)
        TITLE=$(playerctl --player=$PLAYER metadata title)
        # Acorta el título si tiene más de 40 caracteres
        if [ ${#TITLE} -gt 40 ]; then
            TITLE="$(echo "$TITLE" | cut -c1-40)..."
        fi
        echo "$ARTIST - $TITLE"
    }

    case $STATUS in
        "Playing")
            # Muestra ícono de play (U+F04B) y la canción
            echo -e "<fc=$COLOR_PLAYING><fn=2>\uF04B</fn></fc> $(get_metadata)"
            ;;
        "Paused")
            # Muestra ícono de pausa (U+F04C) y la canción
            echo -e "<fc=$COLOR_PAUSED><fn=2>\uF04C</fn></fc> $(get_metadata)"
            ;;
        *)
            # Si está detenido (Stopped), no muestra nada
            echo ""
            ;;
    esac
else
    # Si el reproductor no está activo, no muestra nada
    echo ""
fi