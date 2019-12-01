# Created by newuser for 5.6.2

autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit
autoload -Uz url-quote-magic
colors
compinit

zle -N self-insert url-quote-magic

bindkey -e

setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

setopt interactive_comments
setopt magic_equal_subst

setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt notify

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs status virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(  )

# Alias
alias ls='ls --color=auto'

xonsh

# #plugins
# source ~/.zplug/init.zsh
# #zplug "agnoster/agnoster-zsh-theme", as:theme
# #zplug "sindresorhus/pure", use:pure.zsh, as:theme
# zplug "bhilburn/powerlevel9k", as:theme
# zplug "mafredri/zsh-async"
# zplug "b4b4r07/enhancd", use:init.sh
# zplug "zsh-users/zsh-autosuggestions"
# zplug "zsh-users/zsh-completions"
# zplug "zsh-users/zsh-syntax-highlighting"
#
# zplug "plugins/gnu-utils", from:oh-my-zsh
# zplug "plugins/archlinux", from:oh-my-zsh
# zplug "plugins/pip", from:oh-my-zsh
# zplug "plugins/colored-man-pages", from:oh-my-zsh
#
# #Install
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi
#
# #load plugins
# zplug load --verbose
#

