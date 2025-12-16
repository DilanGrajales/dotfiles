# Dotfiles para XMonad + Xmobar

Este repositorio contiene los archivos de configuración necesarios para instalar y personalizar un entorno de escritorio basado en **XMonad** y **Xmobar** en Linux.

## Requisitos

- Linux (probado en distribuciones basadas en Arch)
- [XMonad](https://xmonad.org/)
- [Xmobar](https://xmobar.org/)
- [Zsh](https://www.zsh.org/)

### Tabla de Dependencias

Estos son los programas necesarios para que todos los scripts y módulos funcionen correctamente:

| Categoría | Paquete | Descripción |
| :--- | :--- | :--- |
| **Core** | `xmonad`, `xmonad-contrib`, `xmobar` | Gestor de ventanas y barra |
| **Terminal** | `kitty`, `zsh` | Emulador y Shell |
| **Lanzadores** | `rofi`, `dmenu` (opcional) | Menús y lanzadores de apps |
| **Utilidades** | `fzf`, `xclip`, `greenclip` | Búsqueda y portapapeles |
| **Pantalla** | `scrot`, `brightnessctl`, `feh`, `picom` | Capturas, brillo, fondo y compositor |
| **Audio** | `pamixer`, `pulseaudio-utils` (pactl) | Control de volumen |
| **Media** | `playerctl`, `ffmpeg` | Control multimedia y grabación |
| **Red/BT** | `networkmanager`, `bluez`, `nmcli` | WiFi y Bluetooth |
| **Notificaciones** | `dunst`, `libnotify` | Sistema de notificaciones |
| **Sistema** | `upower`, `pacman-contrib`, `slop` | Batería, actualizaciones, selección |
| **Estilo** | `nwg-look`, `lxappearance` | Configuración GTK |

## Instalación

### Método Automático (Recomendado)

Este repositorio incluye un script de instalación que se encarga de:

1. Instalar todas las dependencias (Pacman y AUR).
2. Copiar los archivos de configuración (`.xmonad`, `.config`, `.local`).
3. Configurar servicios básicos.
4. (Opcional) Configurar Grub.

```zsh
git clone https://github.com/DilanGrajeles/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### Método Manual

Si prefieres hacerlo paso a paso:

1. **Clona el repositorio**:

    ```zsh
    git clone https://github.com/DilanGrajeles/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **Instala paquetes**:
    Revisa la tabla de dependencias arriba e instala los paquetes con `pacman` y `yay`.

    ```zsh
    # Ejemplo básico
    sudo pacman -S xmonad xmonad-contrib xmobar kitty dunst zsh
    yay -S greenclip rofi-power-menu nwg-look
    ```

3. **Copia configuraciones**:

    ```zsh
    cp -r .xmonad ~/
    cp -r .config ~/
    cp -r .local ~/
    cp .zshrc ~/
    cp .xinitrc ~/
    cp .profile ~/
    cp .xprofile ~/
    cp .Xresources ~/
    ```

    Estos archivos adicionales manejan:
    - **.xinitrc**: Inicio de sesión (si usas `startx`).
    - **.profile / .xprofile**: Variables de entorno.
    - **.Xresources**: Configuración de DPI y colores para aplicaciones X11 antiguas.

4. **Configura Temas**:
    - Mueve temas GTK a `~/.local/share/themes`.
    - Mueve iconos a `~/.local/share/icons`.
    - Usa `nwg-look` para aplicar el tema.

#### Iconos y Cursores

1. Mueve los iconos y cursores a `.local/share/icons`

    ```zsh
    mkdir -p ~/.local/share/icons
    # cp -r ./themes/icons/NombreIconos ~/.local/share/icons/
    # cp -r ./themes/cursors/NombreCursores ~/.local/share/icons/
    ```

2. Selecciona el tema

    Ve a `nwg-look` y selecciona el tema, iconos y cursor.

#### Fondos de Pantalla y Lockscreen

El instalador mueve los fondos a `/usr/share/backgrounds/`.

Para actualizar el fondo de pantalla de bloqueo (`betterlockscreen`):

```zsh
# Actualizar caché con una imagen específica
betterlockscreen -u /usr/share/backgrounds/mountains.png

# O usar la configuración de xmonad si está vinculada
```

### Copiar configuración de Grub

El archivo `./grub/grub` ya contiene la configuración necesaria (temas, resolución 2K, parámetros de hibernación y gráficos).

1. **Verifica el UUID de SWAP**
    - Ejecuta `lsblk -f` para obtener tu UUID.
    - Edita `./grub/grub` si tu UUID es diferente al preconfigurado.

2. **Instala y Copia**

    ```zsh
    sudo cp ./grub/grub /etc/default/grub
    
    # Instalar tema
    sudo mkdir -p /usr/share/grub/themes
    sudo cp -r ./grub/themes/thinkpad/ /usr/share/grub/themes/
    
    # Generar config
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

## Opciones de energia

### Usar solo monitor con tapa cerrada

1. **Editar logind.conf**: `sudo nano /etc/systemd/logind.conf`
2. **Modificar**:

    ```plaintext
    HandleLidSwitch=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=ignore
    IdleActionSec=infinity
    ```

3. **Reiniciar servicio**: `sudo systemctl restart systemd-logind.service`

## Configuración de Pantallas (LightDM)

Para que la configuración de pantallas se aplique al iniciar sesión en LightDM, crea un enlace simbólico al script de layout:

```zsh
sudo ln -s /home/$USER/.screenlayout/smart_dual_monitor.sh /etc/lightdm/display_setup.sh
```

Y en la configuración de `/etc/lightdm/lightdm.conf`, agrega esta línea bajo el apartado `[Seat:*]`:

```ini
[Seat:*]
...
display-setup-script=/etc/lightdm/display_setup.sh
```

## Personalización

- Modifica los archivos en `.xmonad/` para cambiar atajos, apariencia y comportamiento.
- Edita `.config/xmobar/` para personalizar la barra de estado.
- Scripts propios en `.local/bin/`.

---

**Autor:** Dilan Grajales
**Repositorio:** <https://github.com/DlanGrajales/dotfiles>
