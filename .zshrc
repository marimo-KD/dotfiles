autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit

colors
compinit

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

#{{{ Keybinds

# emacs keybind
bindkey -e

# history completion
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# kill line
bindkey "^u" backward-kill-line

# edit line with vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^x" edit-command-line

#}}}

#{{{ Options

setopt auto_pushd
setopt auto_cd
setopt pushd_ignore_dups
setopt extended_glob

setopt interactive_comments
setopt magic_equal_subst

setopt no_beep
setopt no_hist_beep
setopt no_list_beep
setopt notify

#}}}

#{{{ History

HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000
HISTORY_IGNORE="(ls|pwd|cd|rm|rmdir|mv|cp|export|exit)"
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_verify
zshaddhistory(){
  local line cmd exist
  line=${1%%$'\n'}
  cmd=${line%% *}
  type ${cmd} > /dev/null 2>&1
  exist=$?
  [[ $line != ${~HISTORY_IGNORE} && ${exist} == "0" ]]
}

#}}}

#{{{ Environments

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(background_jobs status time)

#}}}

#{{{ Aliases

# Global aliases
alias -g G='| grep'
alias -g H='| head'
alias -g L="| ${PAGER}"
alias -g V='| vim -R -'

# others
alias exa='exa --icons --color=auto'
alias grep=rg
# enable to use aliases when using sudo
alias sudo='sudo '

# Commands
alias start_sway='~/Bin/start_sway'
alias trans='~/Bin/Translation.py'

alias vim=nvim
#}}}

#{{{ Prompt

function fg_color() {
  echo "%{$fg[$1]%}"
}
function bg_color() {
  echo "%{$bg[$1]%}"
}
function fg_bg_color() {
  echo "%{$fg[$1]$bg[$2]%}"
}

function left-prompt {
  reset="%{$reset_color%}"
  fg_blue=`fg_color blue`
  fg_green=`fg_color green`
  bg_green=`bg_color green`
  echo "${fg_green}[%n@%m]${reset} ${fg_blue}%~${reset}:%# "
}

function right-prompt {
  echo "[%D %*]"
}

PROMPT=`left-prompt`
RPROMPT=`right-prompt`
SPROMPT="correct> %R -> %r [n,y,a,e]? "

function precmd() {
  if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
    NEW_LINE_BEFORE_PROMPT=1
  elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
    echo ""
  fi
}

#}}}

#{{{ ZPlug

source ~/.zplug/init.zsh

# zplug "mafredri/zsh-async"
zplug "b4b4r07/enhancd", use:init.sh
zplug "arzzen/calc.plugin.zsh", use:calc.plugin.zsh
zplug "zsh-users/zsh-completions", lazy:true
zplug "zsh-users/zsh-syntax-highlighting"

zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh

case ${OSTYPE} in
    darwin*)
        # Mac
        alias ls='ls -G'
        export PATH=/opt/homebrew/bin:$PATH
        # zplug "sindresorhus/pure", use:pure.zsh, as:theme
        ;;
    linux*)
        # Linux
        alias ls='ls --color'
        zplug "plugins/archlinux", from:oh-my-zsh
        # zplug "romkatv/powerlevel10k", as:theme, depth:1
        ;;
esac

#Install
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

#load plugins
zplug load --verbose

# }}}

# opam configuration
[[ ! -r /Users/marimo-kd/.opam/opam-init/init.zsh ]] || source /Users/marimo-kd/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
