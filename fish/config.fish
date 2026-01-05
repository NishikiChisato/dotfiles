fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/llvm/bin

set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
set -gx CFLAGS "-I/opt/homebrew/opt/llvm/include"
set -gx LDFLAGS "$LDFLAGS -L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"

if status is-interactive
    
    abbr -a v 'nvim'
    abbr -a lg 'lazygit'
    abbr -a cls 'clear'
    abbr -a cm 'cmake -B build -G Ninja'
    abbr -a cb 'cmake --build build'
    abbr -a gr 'go run'
    abbr -a gb 'go build'
    
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first --git'
    alias l='eza -lh --icons --group-directories-first --git'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    
    abbr -a ... 'cd ../../'
    abbr -a .... 'cd ../../../'

    zoxide init fish | source

    set fzf_fd_opts --hidden --exclude .git
    set fzf_preview_file_cmd bat --style=numbers --color=always --line-range :500
    set fzf_preview_dir_cmd tree -C
    
    set -gx FZF_DEFAULT_OPTS "
      --height 40% 
      --layout=reverse 
      --border 
      --info=inline 
      --color=bg+:#2e3440,bg:#1a1b26,spinner:#bb9af7,hl:#7aa2f7 
      --color=fg:#c0caf5,header:#7aa2f7,info:#9ece6a,pointer:#bb9af7 
      --color=marker:#9ece6a,fg+:#c0caf5,prompt:#7aa2f7,hl+:#7aa2f7
    "

    set -g fish_greeting ""

    fish_vi_key_bindings
    set -g fish_escape_delay_ms 10

    bind \cf accept-autosuggestion
    bind -M insert \cf accept-autosuggestion

    bind \cp up-or-search
    bind \cn down-or-search

    bind -M insert \cp up-or-search
    bind -M insert \cn down-or-search
    
    bind -M default \cp up-or-search
    bind -M default \cn down-or-search

    bind \cl 'clear; commandline -f repaint'
end
