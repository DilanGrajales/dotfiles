#!/bin/sh

# Comprueba si el monitor DP-1 está conectado
if xrandr --query | grep -q "DP-1 connected"; then
    # Si está conectado, apaga la pantalla de la laptop y usa solo el monitor externo.
    xrandr --output eDP-1 --off \
           --output DP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal \
           --output HDMI-1 --off \
           --output DP-2 --off
else
    # Si no está conectado, usa solo la pantalla de la laptop y apaga las demás.
    xrandr --output eDP-1 --primary --auto \
           --output DP-1 --off \
           --output HDMI-1 --off \
           --output DP-2 --off
fi
