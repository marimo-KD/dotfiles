# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz compinit

colors
compinit

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

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

# {{{ Functions
comppdf(){
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/printer -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$2 $1
}
_nvim_or_nvr(){
  if [ -z "$NVIM" ] || type nvr > /dev/null 2>&1; then
    \nvim ${@}
  else
    nvr --remote-silent $1
  fi
}
nvcd(){
  [ "$NVIM" ] && nvr -c "cd $(pwd)"
}
chpwd_functions+=( nvcd )
_nvimcmp(){
  _arguments \
    '-h[help]' \
    '*: :_files'
  return 1;
}
# }}}

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
export BAT_THEME="Catppuccin-macchiato"

#}}}

#{{{ Aliases

# others
alias exa='exa --icons --color=auto'
alias grep=rg
# enable to use aliases when using sudo
alias sudo='sudo '

alias vim=nvim
#}}}

#{{{ OS-wise config
case ${OSTYPE} in
    darwin*)
        # Mac
        alias ls='ls -G'
        export PATH=/opt/homebrew/bin:$PATH
        ;;
    linux*)
        # Linux
        alias ls='ls --color=auto'
        ;;
esac
#}}}

eval "$(sheldon source)"

[[ ! -r ~/.opam/opam-init/init.zsh ]] || source ~/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

compdef _nvimcmp _nvim_or_nvr

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f "/home/marimo-kd/.ghcup/env" ] && source "/home/marimo-kd/.ghcup/env" # ghcup-env
