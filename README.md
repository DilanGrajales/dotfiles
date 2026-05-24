# dotfiles — XMonad + Arch Linux

Configuración completa de mi entorno XMonad en Arch Linux. Este repo se mantiene
sincronizado via `backup.sh` y permite restaurar todo en una PC nueva con `bootstrap.sh`.

## Estructura

```
~/
├── backup.sh              # Respaldar sistema actual → repo
├── bootstrap.sh           # Restaurar repo → PC nueva
├── .bashrc, .xinitrc, .xprofile, .Xresources, .gitconfig, .fehbg, ...
├── .config/               # dunst, kitty, rofi, xmobar, btop, pipewire, systemd, ...
├── .xmonad/               # xmonad.hs, lib/Colors/, xmonadctl.hs
├── .local/bin/            # scripts personalizados (29)
├── .local/share/rofi/     # temas de rofi
├── .screenlayout/         # layouts de monitores (10)
├── etc/                   # respaldo de /etc/
│   ├── grub               # /etc/default/grub
│   ├── fstab              # /etc/fstab
│   ├── pacman.conf        # /etc/pacman.conf
│   ├── tlp/tlp.conf       # TLP power management
│   ├── thinkfan/          # thinkfan.conf (control de ventilador)
│   ├── throttled/         # throttled.conf (Intel throttling fix)
│   ├── modprobe.d/        # módulos del kernel (nvidia, thinkpad_acpi, etc.)
│   ├── udev/rules.d/      # reglas udev (WOL, rapl, low-battery)
│   ├── sysctl.d/          # performance tuning
│   ├── systemd/           # servicios personalizados (ollama, wol, etc.)
│   ├── X11/xorg.conf.d/   # config de GPU NVidia, touchpad, teclado
│   ├── default/earlyoom   # earlyoom config
│   └── mkinitcpio.conf, locale.conf, hostname, hosts, environment...
├── packages/
│   ├── packages-official.txt  # 259 paquetes oficiales
│   └── packages-aur.txt       # 32 paquetes AUR
├── grub/themes/thinkpad/      # tema GRUB ThinkPad
├── themes/README.md           # referencias a temas GTK/Kvantum (sin assets)
└── .gitignore
```

## Backup (sistema actual → repo)

```bash
./backup.sh
```

Respaldar automaticamente:
- Archivos de home, `.config/`, `.xmonad/`, scripts, layouts
- Listas de paquetes (oficiales + AUR)
- Configuraciones de sistema (`/etc/`: grub, fstab, pacman, tlp, thinkfan,
  throttled, modprobe, udev, sysctl, X11, servicios systemd)
- Tema GRUB thinkpad
- Auto-commit con timestamp

Nota: para `etc/` requiere sudo o su (el script hace fallback automatico).

## Restaurar (repo → PC nueva)

```bash
./bootstrap.sh
```

Instala paquetes, restaura configs de home y sistema, recompila xmonad,
habilita servicios, y regenera GRUB.

## Hardware

- ThinkPad P1 Gen 4
- NVIDIA + Intel GPU (optimus via nvidia-drm.modeset)
- Dual NVMe SSDs
- 4K display

## Paquetes clave

| Categoría | Paquetes |
|-----------|----------|
| WM | xmonad, xmonad-contrib, xmobar |
| Terminal | kitty |
| Launcher | rofi, rofi-calc, rofi-power-menu |
| Notificaciones | dunst |
| Compositor | picom-ftlabs-git (AUR) |
| Clipboard | greenclip (AUR), clipmenu |
| Power | tlp, thinkfan, throttled-git (AUR), earlyoom |
| GTK Theme | Graphite-blue-Dark-nord |
| Shell | zsh |
| Audio | pipewire, pipewire-pulse, easyeffects |
| NVIDIA | nvidia-dkms, nvidia-utils, nvidia-settings |

## Notas

- `.xmonad/` es la config activa (sin symlinks). `backup.sh` sincroniza.
- Los temas GTK/Kvantum no estan en el repo (solo referencias). Se instalan
  via AUR/pacman.
- Para hacer backup en el futuro: solo corre `./backup.sh`
