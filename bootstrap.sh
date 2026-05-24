#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"

if [ ! -d "$DOTFILES" ]; then
  echo "ERROR: No se encuentra $DOTFILES"
  echo "Clonalo primero: git clone <url> $DOTFILES"
  exit 1
fi

echo "=== bootstrap.sh: Restaurando dotfiles ==="

install_packages() {
  echo "[1/6] Instalando paquetes oficiales..."
  sudo pacman -S --needed - < "$DOTFILES/packages/packages-official.txt"

  echo "[2/6] Instalando paquetes AUR..."
  if command -v yay &>/dev/null; then
    yay -S --needed - < "$DOTFILES/packages/packages-aur.txt"
  elif command -v paru &>/dev/null; then
    paru -S --needed - < "$DOTFILES/packages/packages-aur.txt"
  else
    echo "  Aviso: ni yay ni paru encontrados. Instala los AUR manualmente."
  fi
}

restore_home() {
  echo "[3/6] Restaurando configs de home..."
  rsync -a \
    --exclude='.git' --exclude='.gitignore' --exclude='.zhistory' \
    --exclude='.zsh_history' --exclude='backup.sh' --exclude='bootstrap.sh' \
    --exclude='packages' --exclude='etc' --exclude='grub' \
    --exclude='themes' --exclude='README.md' \
    "$DOTFILES/" "$HOME/"
}

restore_system() {
  echo "[4/6] Restaurando configs de sistema (sudo)..."
  sudo mkdir -p /usr/share/grub/themes
  sudo cp "$DOTFILES/etc/grub" /etc/default/grub
  sudo cp "$DOTFILES/etc/fstab" /etc/fstab
  sudo cp "$DOTFILES/etc/pacman.conf" /etc/pacman.conf
  sudo cp -r "$DOTFILES/grub/themes/thinkpad" /usr/share/grub/themes/
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

recompile_xmonad() {
  echo "[5/6] Recompilando xmonad..."
  xmonad --recompile || echo "  Aviso: fallo al recompilar xmonad"
}

enable_services() {
  echo "[6/6] Habilitando servicios systemd user..."
  for svc in clipmenud hour-telling connect-lofree clipcat; do
    systemctl --user enable "$svc" 2>/dev/null || true
  done
}

install_packages
restore_home
restore_system
recompile_xmonad
enable_services

echo "=== bootstrap.sh completo ==="
echo "Re-log o reinicia para aplicar todos los cambios."
