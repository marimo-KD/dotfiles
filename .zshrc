# Created by newuser for 5.6.2

autoload -Uz add-zsh-hook
autoload -Uz compinit colors
autoload -Uz url-quote-magic
compinit -u
colors

zle -N self-insert url-quote-magic

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zplug/init.zsh

bindkey -e

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

setopt correct
setopt interactive_comments
setopt magic_equal_subst

setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt notify

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Alias
alias ls='ls --color=auto'

#plugins
#zplug "agnoster/agnoster-zsh-theme", as:theme
#zplug "bhilburn/powerlevel9k", as:theme
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure", use:pure.zsh, as:theme
zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-autosuggestions"

zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/archlinux", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

#Install
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

#load plugins
zplug load --verbose
