FROM amutake/satysfi:opam-slim as satysfi_extern

# Various functions
RUN opam install satysfi-base
RUN opam install satysfi-zrbase
RUN opam install satysfi-latexcmds
RUN opam install satysfi-bibyfi

# Libraries for math
RUN opam install satysfi-azmath
RUN opam install satysfi-derive
RUN opam install satysfi-ncsq
RUN opam install satysfi-karnaugh
RUN opam install satysfi-siunitx
RUN opam install satysfi-chemfml

# Libraries for code
RUN opam install satysfi-code-printer

# Libraries for images/tables
RUN opam install satysfi-easytable
RUN opam install satysfi-figbox
RUN opam install satysfi-image
RUN opam install satysfi-enumitem
RUN opam install satysfi-colorbox
RUN opam install satysfi-arrows
RUN opam install satysfi-parallel

# Libraries for typesetting
RUN opam install satysfi-uline
RUN opam install satysfi-ruby

# Install library using satyrographos
RUN opam exec -- satyrographos install

# --------------------------------------------------------------

FROM satysfi_extern as entry

WORKDIR /satysfi

# Setup entrypoint
ENTRYPOINT ["opam", "exec", "--"]
