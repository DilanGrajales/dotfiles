#!/bin/bash
DIR="$HOME/.cache/clipmenu"

mkdir -p "$DIR"

declare -a chars=("á" "é" "í" "ó" "ú" "Á" "É" "Í" "Ó" "Ú" "ñ" "Ñ")

for c in "${chars[@]}"; do
    file="${DIR}/default_${c}"
    printf "%s" "$c" > "$file"
done

