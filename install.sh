#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Iniciando instalación de Dotfiles ===${NC}"

# 1. Actualizar sistema e instalar dependencias base
echo -e "${GREEN}[+] Actualizando sistema e instalando base-devel/git...${NC}"
sudo pacman -Syu --noconfirm base-devel git zsh

# 2. Instalar Yay (AUR Helper) si no existe
if ! command -v yay &> /dev/null; then
    echo -e "${GREEN}[+] Instalando Yay...${NC}"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    echo -e "${BLUE}[*] Yay ya está instalado.${NC}"
fi

# 3. Definiendo paquetes
# Paquetes oficiales
PACMAN_PKGS=(
    # Core
    "xmonad"
    "xmonad-contrib"
    "xmobar"
    "xdotool"
    "kitty"
    "dunst"
    "picom"
    # Tools
    "rofi"
    "xclip"
    "scrot"
    "fzf"
    "brightnessctl"
    "playerctl"
    "pamixer"
    "feh"
    "ffmpeg"
    "libnotify"
    "pacman-contrib" # para checkupdates
    "slop"           # para selecciones de región
    "upower"
    "thunar"
    # Audio/Bluetooth/Net
    "pulseaudio-utils"
    "bluez"
    "bluez-utils"
    "networkmanager"
    # Fonts
    "ttf-font-awesome"
)

# Paquetes AUR
AUR_PKGS=(
    "greenclip"
    "rofi-power-menu"
    "rofi-calc"
    "betterlockscreen"
    "google-chrome"
    "nwg-look"
    "nerd-fonts-sf-mono-ligatures" # Ajustar si el nombre varía
    "thinkfan-tui" # Verificar si existe en AUR, asumiendo sí por los scripts
)

# 4. Instalación de paquetes
echo -e "${GREEN}[+] Instalando paquetes oficiales...${NC}"
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

echo -e "${GREEN}[+] Instalando paquetes de AUR...${NC}"
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# 5. Configuración de Dotfiles
echo -e "${GREEN}[+] Copiando archivos de configuración...${NC}"

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Función para backup y copia
install_config() {
    local src="$1"
    local dest="$2"
    
    if [ -e "$dest" ]; then
        echo "    Respaldo: $dest -> $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi
    
    echo "    Copiando: $src -> $dest"
    cp -r "$src" "$dest"
}

install_config ".xmonad" "$HOME/.xmonad"
install_config ".config" "$HOME/.config"
install_config ".local" "$HOME/.local"
install_config ".zshrc" "$HOME/.zshrc"
install_config ".xinitrc" "$HOME/.xinitrc"
install_config ".profile" "$HOME/.profile"
install_config ".xprofile" "$HOME/.xprofile"
install_config ".Xresources" "$HOME/.Xresources"

# Restaurar propiedad y permisos de ejecutables
echo -e "${GREEN}[+] Restaurando permisos de ejecutables...${NC}"
CURRENT_USER=$(whoami)

# Restaurar la propiedad de los archivos en .local/bin
if [ -d "$HOME/.local/bin" ]; then
    echo "    -> Restaurando propiedad de archivos en ~/.local/bin..."
    sudo find "$HOME/.local/bin" -type f -exec chown $CURRENT_USER:$CURRENT_USER {} +
    
    echo "    -> Asegurando permisos de ejecución..."
    chmod u+x "$HOME/.local/bin"/*
fi

# Crear directorios necesarios si no existen
mkdir -p "$HOME/.local/share/themes"
mkdir -p "$HOME/.local/share/icons"

# Copiar temas e iconos locales si existen en el repo
if [ -d "./themes/gtk" ]; then
    echo -e "${GREEN}[+] Instalando temas GTK...${NC}"
    cp -r ./themes/gtk/* "$HOME/.local/share/themes/"
fi

# 6. Fondos de pantalla y Lockscreen
if [ -d "./usr/share/backgrounds" ]; then
    echo -e "${GREEN}[+] Instalando fondos de pantalla...${NC}"
    sudo mkdir -p /usr/share/backgrounds
    sudo cp -r ./usr/share/backgrounds/* /usr/share/backgrounds/
    
    echo -e "${GREEN}[+] Actualizando caché de betterlockscreen...${NC}"
    # Se usa la carpeta completa para que el usuario pueda rotar si quiere
    # O se define uno por defecto. Usaremos el primero encontrado o la carpeta.
    betterlockscreen -u /usr/share/backgrounds/
fi

# 6. Servicios
echo -e "${GREEN}[+] Habilitando servicios...${NC}"
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
# sudo systemctl enable --now systemd-logind # Generalmente activo por defecto

# 7. Configuración de Grub (Opcional)
echo -e "${BLUE}=== Configuración de Grub ===${NC}"
read -p "¿Deseas aplicar la configuración de Grub del repositorio? (s/n): " confirm_grub
if [[ "$confirm_grub" =~ ^[sS]$ ]]; then
    echo -e "${GREEN}[+] Aplicando configuración de Grub...${NC}"
    
    # Backup grub actual
    sudo cp /etc/default/grub "/etc/default/grub.backup_$(date +%Y%m%d)"
    
    # Copiar nuevo archivo
    sudo cp ./grub/grub /etc/default/grub
    
    # Copiar tema de grub
    if [ -d "./grub/themes" ]; then
        sudo mkdir -p /usr/share/grub/themes
        sudo cp -r ./grub/themes/* /usr/share/grub/themes/
    fi
    
    echo -e "${GREEN}[+] Generando grub.cfg...${NC}"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "[-] Saltando configuración de Grub."
fi

# 8. Shell
echo -e "${BLUE}=== Finalizado ===${NC}"
echo -e "Por favor reinicia el sistema o cierra sesión para ver los cambios."
echo -e "Si instalaste zsh por primera vez, asegúrate de cambiar tu shell con: chsh -s /bin/zsh"
