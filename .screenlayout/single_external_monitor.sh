#!/bin/sh

# --- Configuración ---
# IMPORTANTE: Confirma si tu pantalla interna sigue siendo DP-4 al usar el dock.
# A veces al conectar docks, la interna cambia a eDP-1 o eDP-1-1.
# Si no te apaga la pantalla de la laptop, revisa esto con 'xrandr --listmonitors'
INTERNAL_MONITOR="DP-4"

# Resolución y refresco
EXTERNAL_MODE="2560x1440"
EXTERNAL_RATE="75.00"

# --- Lógica del Script ---

# Pausa inicial
sleep 1

# --- CORRECCIÓN AQUÍ ---
# Buscamos específicamente cualquier monitor conectado que empiece por "DP-0"
# El "^DP-0" significa "que empiece con DP-0" (ej: DP-0.3.1, DP-0.1, etc.)
EXTERNAL_MONITOR=$(xrandr --query | grep " connected" | grep "^DP-0" | cut -d" " -f1 | head -n 1)

# Comprobar si se encontró un monitor externo
if [ -n "$EXTERNAL_MONITOR" ]; then
    echo "Dock detectado en puerto: '$EXTERNAL_MONITOR'"

    # Bucle de espera: asegurar que el monitor específico esté listo
    # Usamos grep -F para búsqueda literal exacta del nombre complejo
    while ! xrandr --query | grep -F "$EXTERNAL_MONITOR connected"; do
        echo "Esperando señal en $EXTERNAL_MONITOR..."
        sleep 1
    done

    # Aplicar configuración
    echo "Activando Dock ($EXTERNAL_MONITOR) y apagando Laptop ($INTERNAL_MONITOR)..."
    xrandr --output "$EXTERNAL_MONITOR" --primary --mode $EXTERNAL_MODE --rate $EXTERNAL_RATE --output "$INTERNAL_MONITOR" --off

else
    # Si no hay dock, vuelve a la laptop
    echo "Dock no detectado. Usando pantalla interna."
    xrandr --output "$INTERNAL_MONITOR" --primary --auto
fi

# Pausa de estabilidad
sleep 1

# Fondo de pantalla
feh --bg-fill --no-fehbg /usr/share/backgrounds/od_tux.png