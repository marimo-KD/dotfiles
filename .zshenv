export PAGER=less

if [[ -n ${EDITOR} && ${EDITOR[(w)0]} = 'nvr' ]]; then
    export EDITOR
elif (( $+commands[nvim] )); then
    export EDITOR=nvim
fi

export VISUAL=nvim
export W3MIMGDISPLAY=/usr/lib/w3m/w3mimgdisplay
export path=($HOME/Bin/(N-/) $HOME/.local/bin/(N-/) $HOME/.rustup/toolchains/(N-/) $HOME/.cargo/bin/(N-/) $path)

export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
