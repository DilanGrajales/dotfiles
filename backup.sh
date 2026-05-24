#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
cd "$DOTFILES"

echo "=== backup.sh: Sincronizando dotfiles ==="

backup_home_root() {
  echo "[1/10] Archivos raiz del home..."
  for f in .bashrc .bash_profile .xinitrc .xprofile .Xresources \
           .gitconfig .fehbg .dmenurc .dir_colors .gtkrc-2.0 .zshrc; do
    [ -f "$HOME/$f" ] && cp "$HOME/$f" "$DOTFILES/$f"
  done
}

backup_config_dirs() {
  echo "[2/10] Directorios .config/..."
  for dir in dunst kitty rofi xmobar btop volumeicon xsettingsd ranger pipewire systemd; do
    [ -d "$HOME/.config/$dir" ] && rsync -a --delete "$HOME/.config/$dir/" "$DOTFILES/.config/$dir/"
  done
}

backup_picom() {
  echo "[3/10] Picom..."
  [ -f "$HOME/.config/picom.conf" ] && cp "$HOME/.config/picom.conf" "$DOTFILES/.config/picom.conf"
  [ -f "$HOME/.config/picom.bak" ] && cp "$HOME/.config/picom.bak" "$DOTFILES/.config/picom.bak"
}

backup_xmonad() {
  echo "[4/10] Xmonad..."
  rsync -a --delete \
    --exclude='build-x86_64-linux' --exclude='*.o' --exclude='*.hi' \
    --exclude='xmonad-x86_64-linux' --exclude='xmonad.errors' \
    "$HOME/.xmonad/" "$DOTFILES/.xmonad/"
}

backup_scripts() {
  echo "[5/10] Scripts en .local/bin/..."
  rsync -a --delete \
    --exclude='hi-fi-pipewire' \
    "$HOME/.local/bin/" "$DOTFILES/.local/bin/"
}

backup_rofi() {
  echo "[6/10] Temas de rofi..."
  [ -d "$HOME/.local/share/rofi" ] && rsync -a --delete "$HOME/.local/share/rofi/" "$DOTFILES/.local/share/rofi/"
}

backup_screenlayout() {
  echo "[7/10] Screen layouts..."
  rsync -a --delete "$HOME/.screenlayout/" "$DOTFILES/.screenlayout/"
}

backup_packages() {
  echo "[8/10] Listas de paquetes..."
  mkdir -p "$DOTFILES/packages"
  pacman -Qqen > "$DOTFILES/packages/packages-official.txt"
  pacman -Qqem > "$DOTFILES/packages/packages-aur.txt"
}

_run_as_root() {
  if sudo -n true 2>/dev/null; then
    sudo "$@"
  elif command -v su &>/dev/null; then
    echo "  sudo no disponible (no TTY), intentando con su..."
    read -r -s -p "  Password: " root_pass
    echo
    echo "$root_pass" | su -c "$*"
    unset root_pass
  else
    echo "  SKIP: no se pudo obtener privilegios"
    return 1
  fi
}

backup_system() {
  echo "[9/10] Configuraciones de sistema (sudo)..."
  _run_as_root mkdir -p "$DOTFILES/etc" || return
  _run_as_root cp /etc/default/grub "$DOTFILES/etc/grub"
  _run_as_root cp /etc/fstab "$DOTFILES/etc/fstab"
  _run_as_root cp /etc/pacman.conf "$DOTFILES/etc/pacman.conf"
  _run_as_root chown -R "$USER:$USER" "$DOTFILES/etc"
  _run_as_root rsync -a --delete /usr/share/grub/themes/thinkpad/ "$DOTFILES/grub/themes/thinkpad/"
  _run_as_root chown -R "$USER:$USER" "$DOTFILES/grub"
}

update_themes_readme() {
  echo "[10/10] Referencias de temas..."
  mkdir -p "$DOTFILES/themes"
  cat > "$DOTFILES/themes/README.md" << 'EOF'
# Temas

Este directorio no contiene assets binarios para mantener el repo liviano.
Los temas se instalan via AUR/pacman:

## GTK: Graphite-blue-Dark-nord
- Repo/AUR: https://github.com/vinceliuice/Graphite-gtk-theme
- Iconos: Papirus-Dark (sudo pacman -S papirus-icon-theme)

## Kvantum: Layan-solid
- AUR: kvantum-theme-layan

## GRUB: thinkpad
- Theme en /usr/share/grub/themes/thinkpad/ (respaldo en grub/themes/)
EOF
}

cleanup() {
  echo "Limpiando basura del repo..."
  rm -f "$DOTFILES/.zhistory" "$DOTFILES/.zsh_history" 2>/dev/null || true
  find "$DOTFILES/.xmonad" -name '*.bak' -delete 2>/dev/null || true
  find "$DOTFILES/.config" -name '*.bak' -delete 2>/dev/null || true
}

git_commit() {
  echo "Haciendo commit..."
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
  git add -A
  git commit -m "backup $TIMESTAMP" || echo "  (nada nuevo que commitear)"
}

backup_home_root
backup_config_dirs
backup_picom
backup_xmonad
backup_scripts
backup_rofi
backup_screenlayout
backup_packages
backup_system
update_themes_readme
cleanup
git_commit

echo "=== backup.sh completo ==="
