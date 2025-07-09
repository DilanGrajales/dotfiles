# Dotfiles para XMonad + Xmobar

Este repositorio contiene los archivos de configuración necesarios para instalar y personalizar un entorno de escritorio basado en **XMonad** y **Xmobar** en Linux.

## Requisitos

- Linux (probado en distribuciones basadas en Arch)
- [XMonad](https://xmonad.org/)
- [Xmobar](https://xmobar.org/)
- [Zsh](https://www.zsh.org/) (opcional, recomendado)
- Otros programas sugeridos: `feh`, `rofi`, `kitty`, etc.

## Instalación

### Clona este repositorio

```zsh
git clone https://github.com/DilanGrajeles/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Instala XMonad, Xmobar y programas requeridos en la configuracion

```zsh
# Principal
sudo pacman -S xmonad xmonad-contrib xmobar yay kitty

# Programas secundarios necesarios
yay -S rofi greenclip xclip scrot rofi-power-menu rofi-calc betterlockscreen google-chrome amixer brightnessctl thunderbird

```

### Copia los archivos de configuración

Es importante copiar los siguientes directorios y archivos a tu home (`~`):

```zsh
cp -r .xmonad ~/
cp -r .config ~/
cp -r .local ~/
cp .zshrc ~/
```

Si ya tienes archivos previos, haz un respaldo antes de sobrescribirlos.

### Instala dependencias adicionales

- Instala fuentes recomendadas (ejemplo: `otf-apple-fonts`, `nerd-fonts-sf-mono-ligatures` `ttf-font-awesome`).
- Instala otros programas que uses en tu configuración (`feh`, `rofi`, `tidal`, `emacs`, etc).

### Inicia XMonad

- Desde un gestor de sesiones, selecciona XMonad.

### Configura grub

#### Cambia la configuración de grub para seleccionar el boot menu

1. Abrir el archivo grub

    ```plaintext
    .
    ├── grub
    │   ├── grub -> Modificar este archivo
    │   └── themes/
    ├── ...
    ```

2. Ubica el UUID de la particion de SWAP

    ```zsh
    lsblk -f
    ```

    ```plaintext
    NAME        FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
    nvme0n1                                                                            
    ├─nvme0n1p1 vfat   FAT32       98CC-4844                                           
    ├─nvme0n1p2                                                                        
    ├─nvme0n1p3 ntfs               121CD1CE1CD1ACCB                                    
    ├─nvme0n1p4 ntfs               A4041A48041A1E3C                                    
    ├─nvme0n1p5 vfat   FAT32       C84C-0675                             598.5M     0% /boot/efi
    ├─nvme0n1p6 swap   1           961a57bd-c8c1-4044-8531-d703c266589e                [SWAP]     -- Copiar este UUID
    ├─nvme0n1p7 ext4   1.0         3fe18c4e-325b-4684-862a-64707e4ca284   89.7G    17% /
    └─nvme0n1p8 ext4   1.0         83a28f36-1b5d-4158-92b8-1b172554160b   85.2G    10% /home
    ```

3. Cambia la linea `GRUB_CMDLINE_LINUX_DEFAULT` para que no de error la hibernacion

    Pega el UUID de la particion SWAP

    ```plaintext
    GRUB_CMDLINE_LINUX_DEFAULT='quiet ... resume=UUID=SWAP_UUID'
    ```

4. Mueve el archivo a `/etc/default/

5. Compila los cambios para que se efectuen

    ```zsh
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ```

#### Temas

Mueve la carpeta de `themes` dentro de grub al sistema

```zsh
sudo cp -r ./grub/themes/thinkpad/ /usr/share/grub/themes
```

### Temas del sistema

Mueve las carpetas correspondientes

#### GTK

1. Mueve la carpeta

    ```zsh
    sudo cp -r ./themes/gtk/Graphite-blue-Dark-nord/ /usr/share/themes/
    ```

2. Selecciona el tema

    Ve a `lxappearance` y selecciona el tema

#### Kvantum

1. Mueve la carpeta

    ```zsh
    cp -r ./themes/kvantum/Layan-solid/ /.local/share/themes/
    ```

2. Selecciona el tema

    Ve a `kvantummanager` y selecciona el tema

## Personalización

- Modifica los archivos en `.xmonad/` para cambiar atajos, apariencia y comportamiento.
- Edita `.config/xmobar/` para personalizar la barra de estado.
- Cambia `.zshrc` para personalizar tu shell.

## Notas

- Si tienes problemas con la configuración, revisa los logs de XMonad y Xmobar.
- Puedes adaptar estos archivos a tus necesidades.

---

**Autor:** Dilan Grajales
**Repositorio:** <https://github.com/DlanGrajales/dotfiles>
