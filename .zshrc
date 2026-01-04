# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zap
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/sudo"
plug "zap-zsh/supercharge"
plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-syntax-highlighting"

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_HIGHLIGHT_MAXLENGTH=50

# alias cm="cmake -B build -G Ninja"
# alias cb="cmake --build build"

# alias gr="go run"
# alias gb="go build"
 
# alias v="nvim"
# alias lg="lazygit"
# alias cls="clear"

autoload -Uz compinit && compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# zsh
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS="
  --height 40% 
  --layout=reverse 
  --border 
  --info=inline 
  --color=bg+:#2e3440,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7 
  --color=fg:#c0caf5,header:#7aa2f7,info:#9ece6a,pointer:#bb9af7 
  --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7
"

export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LDFLAGS="-L/opt/homwbrew/opt/llvm/lib"
export CPPFLAGS="-L/opt/homwbrew/opt/llvm/include"
export CFLAGS="-L/opt/homwbrew/opt/llvm/include"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"

eval "$(zoxide init zsh)"

alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --group-directories-first --git'
alias l='eza -lh --icons --group-directories-first --git'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias ...='z ../../'
alias ....='z ../../../'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
