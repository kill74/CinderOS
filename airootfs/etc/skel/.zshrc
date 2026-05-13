#
# CinderOS default Zsh profile
#

alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
alias cat='bat'
alias find='fd'
alias grep='rg'
alias top='btop'
alias docker-ps='lazydocker'
alias lg='lazygit'

export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
export CINDEROS_RICE="polished-pixel-ember"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
