# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export PATH="$PATH:/Users/dkol/.local/bin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
PROMPT='%n:~$ %1~ %# '
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

alias vi="nvim"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word


alias ls="eza --icons=always"
alias cd="z"
alias lg="lazygit"
alias ld="lazydocker"


function fdvi() {
  local dir="${1:-$HOME}"
  fd . "$dir" --type f --extension txt --extension md --extension py --extension go --extension ts --extension js --follow --hidden --exclude .git \
    | fzf --preview "bat --style=numbers --color=always --line-range=:500 {}" \
    --bind "enter:execute(nvim {})"
  }

export EDITOR="vi"

 

alias src_env="set -a; source .env; set +a"


fpath+=~/.zfunc
autoload -Uz compinit && compinit

# alias for poetry run
function pr() {
   poetry run "$@"
}


export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib"
export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include"

export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dkol/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/dkol/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/dkol/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/dkol/google-cloud-sdk/completion.zsh.inc'; fi
