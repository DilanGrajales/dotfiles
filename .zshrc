# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
ZSH_THEME="powerlevel10k/powerlevel10k"
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Plugins
source /usr/share/zsh-sudo/sudo.plugin.zsh

# Alias
alias run="python manage.py runserver"
alias tracking="cd /home/dilan/Documentos/Projects/tracking-crm && source env/bin/activate && export GOOGLE_APPLICATION_CREDENTIALS=google-key.json"
alias microimport="cd /home/Microanalisis/microimport"
alias cenpos="cd /home/dilan/Documentos/Projects/app.cenpos && source env/bin/activate"
alias cadena="cd /home/Microanalisis/coc"
alias iluminacion="cd /home/Microanalisis/iluminacion"
alias secret="python ~/secretKeysGen.py"
alias icat="kitten icat"
alias venv="source env/bin/activate"
alias ssdhealth="sudo smartctl -A /dev/nvme0n1"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
source /usr/share/nvm/init-nvm.sh
autoload -U add-zsh-hook

# Tyy colors
source /home/dilan/.config/tty/one-dark-tty.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc

# pnpm
export PNPM_HOME="/home/dilan/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# copy the terminal output
xcat() {
    if [ -f "$1" ]; then
        cat "$1" | xclip -selection clipboard
    else
        echo "El archivo $1 no existe."
    fi
}

