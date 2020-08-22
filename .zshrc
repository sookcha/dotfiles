autoload -Uz compinit && compinit
setopt auto_cd

eval "$(pyenv init -)"
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit wait lucid for \
                        OMZ::lib/git.zsh \
    atload"unalias grv" OMZ::plugins/git/git.plugin.zsh

setopt promptsubst

zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

zinit pack for ls_colors

zplugin ice wait"0" silent pick"history.zsh" lucid
zplugin snippet OMZ::lib/history.zsh
zplugin ice wait"0" silent pick"history.plugin.zsh" lucid
zplugin snippet OMZ::plugins/history/history.plugin.zsh

# search history via substring
zplugin load zsh-users/zsh-history-substring-search

zplugin ice from"gh" wait"0" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting
zplugin ice from"gh" wait"0" zsh-users/zsh-syntax-highlighting 

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
