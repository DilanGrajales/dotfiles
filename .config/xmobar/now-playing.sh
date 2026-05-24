#!/bin/bash

# --- Configuración ---
# No necesitamos una variable PLAYER fija, la encontraremos dinámicamente.

# Colores
COLOR_PLAYING="#61afef"
COLOR_PAUSED="#e5c07b"

# --- Lógica del Script ---
# Busca el primer reproductor que coincida con "chromium.instance"
PLAYER=$(playerctl -l 2>/dev/null | grep 'chromium.instance' | head -n 1)

# Verifica si se encontró un reproductor
if [ -n "$PLAYER" ]; then
    STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

    get_metadata() {
        ARTIST=$(playerctl --player=$PLAYER metadata artist)
        TITLE=$(playerctl --player=$PLAYER metadata title)
        if [ -z "$ARTIST" ] || [ -z "$TITLE" ]; then
            echo ""
            return
        fi
        if [ ${#TITLE} -gt 40 ]; then
            TITLE="$(echo "$TITLE" | cut -c1-40)..."
        fi
        echo "$ARTIST - $TITLE"
    }

    if [[ "$STATUS" == "Playing" ]] || [[ "$STATUS" == "Paused" ]]; then
        METADATA=$(get_metadata)
        if [ -n "$METADATA" ]; then
            if [[ "$STATUS" == "Playing" ]]; then
                echo -e "<fc=$COLOR_PLAYING><fn=2>\uF04B</fn></fc> $METADATA"
            else
                echo -e "<fc=$COLOR_PAUSED><fn=2>\uF04C</fn></fc> $METADATA"
            fi
        else
            echo ""
        fi
    else
        echo ""
    fi
else
    echo ""
fi
