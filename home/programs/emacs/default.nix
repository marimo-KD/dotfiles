{pkgs, config, ...}: let
  init-el = pkgs.callPackage ./init-el.nix { emacs = config.programs.emacs.finalPackage; };
  fetchFromGitHub = pkgs.fetchFromGitHub;
  fetchgit = pkgs.fetchgit;
in {
  programs.emacs = {
    enable = true;
    package = (
      let myemacs = (
            if pkgs.stdenv.isDarwin
            then pkgs.emacs-macport
            else pkgs.emacs29-pgtk
          );
      in myemacs
    );
    extraPackages = (epkgs: with epkgs; [
      ligature
      ef-themes
      nano-modeline
      perfect-margin
      spacious-padding
      indent-bars
      nerd-icons
      nerd-icons-completion
      rainbow-delimiters
      aggressive-indent
      vertico
      marginalia
      consult
      consult-ghq
      consult-eglot
      embark
      embark-consult
      orderless
      prescient
      corfu-prescient
      # hotfuzz
      corfu
      corfu-terminal
      cape
      nerd-icons-corfu
      tempel
      eglot-tempel
      undo-fu
      vundo
      expreg
      meow
      meow-tree-sitter
      which-key
      hydra
      major-mode-hydra
      avy
      ace-window
      migemo
      ddskk
      ddskk-posframe
      fcitx
      org-nix-shell
      org-roam
      org-roam-ql
      org-roam-ql-ql
      org-modern
      org-superstar
      org-ql
      org-noter
      org-appear
      org-fragtog
      org-download
      ox-gfm
      citar
      japanese-holidays
      eldoc-box
      eglot
      lsp-bridge
      yasnippet
      acm-terminal
      vterm
      nerd-icons-dired
      diredfl
      dired-preview
      dired-subtree
      dired-collapse
      magit
      treesit-grammars.with-all-grammars
      envrc
      rust-mode
      tuareg
      julia-mode
      julia-vterm
      ob-julia-vterm
      nushell-mode
      nix-ts-mode
      markdown-mode
      gnuplot
      auctex
      cdlatex
      pdf-tools
    ] ++ [
      (trivialBuild {
        pname = "org-modern-indent";
        version = "2024-11-05";
        src = fetchFromGitHub {
          owner = "jdtsmith";
          repo = "org-modern-indent";
          rev = "37939645552668f0f79a76c9eccc5654f6a3ee6c";
          hash = "sha256-fnaWLnXfVpPB3ggQOqLSl/ykHfrJbwdoLdFwInHmg1U=";
        };
        buildInputs = [
          epkgs.compat
        ];
      })
      (trivialBuild {
        pname = "eglot-booster";
        version = "2024-10-29";
        src = fetchFromGitHub {
          owner = "jdtsmith";
          repo = "eglot-booster";
          rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
          hash = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
        };
        buildInputs = [
          epkgs.eglot
        ];
      })
      (trivialBuild {
        pname = "eglot-x";
        version = "2024-10-23";
        src = fetchFromGitHub {
          owner = "nemethf";
          repo = "eglot-x";
          rev = "295c0309dc836966467c95867d1593f1376507b6";
          hash = "sha256-G/jnEQRVo6xpBaW5cBrcAD03P65stgGMhTM21pxdNvE=";
        };
        buildInputs = [
          epkgs.eglot
          epkgs.project
          epkgs.xref
        ];
      })
      (trivialBuild {
        pname = "meow-vterm";
        version = "2023-04-29";
        src = fetchFromGitHub {
          owner = "accelbread";
          repo = "meow-vterm";
          rev = "fc7e86a268b523ca12ff451e91aabe5485fbc975";
          hash = "sha256-oWWnyxTT/xdMq4CxLKb8BtjsPajg5sMctOq4dPHZzJk=";
        };
        buildInputs = [
          epkgs.meow
          epkgs.vterm
        ];
      })
      (trivialBuild {
        pname = "satysfi-ts-mode";
        version = "2024-03-19";
        src = fetchFromGitHub {
          owner = "Kyure-A";
          repo = "satysfi-ts-mode";
          rev = "b40d55ebd6ffeadadb85aabaf2e636110c85370c";
          hash = "sha256-7NY0Au5GUJnHXEw7VAmVrHb587+nwcnvFmrubE0I1lA=";
        };
      })
      (trivialBuild {
        pname = "org-src-context";
        version = "2024-02-20";
        src = fetchFromGitHub {
          owner = "karthink";
          repo = "org-src-context";
          rev = "625fc800950ed16dbf77c666e5129087b2315e2a";
          hash = "sha256-znfBXCWpooZTOMuP4ap2wjUsSpaz41NS2h9YSdgZacQ=";
        };
      })
      (trivialBuild {
        pname = "typst-ts-mode";
        version = "2024-11-21";
        src = fetchgit {
          url = "https://codeberg.org/meow_king/typst-ts-mode";
          rev = "d3e44b5361ed1bbb720a38dafdb29cb8d8b6d8be";
          hash = "sha256-fECXfTjbckgS+kEJ3dMQ7zDotqdxxBt3WFl0sEM60Aw=";
        };
      })
      (trivialBuild {
        pname = "typst-preview";
        version = "2024-10-26";
        src = fetchFromGitHub {
          owner = "havarddj";
          repo = "typst-preview.el";
          rev = "4091dc5bbb281335ce03e4cecaae26495275f7e3";
          hash = "sha256-AJRWw8c13C6hfwO28hXERN4cIc6cFTbNBcz2EzqqScg=";
        };
        buildInputs = [
          epkgs.websocket
        ];
      })
      (pkgs.callPackage ./setup.nix {
        inherit (pkgs) fetchFromGitHub;
        inherit (epkgs) trivialBuild;
      })
    ]);
  };
  home.file.".emacs.d/init.el".source = "${init-el}/share/emacs/init.el";
  home.file.".emacs.d/init.elc".source = "${init-el}/share/emacs/init.elc";
  home.file.".emacs.d/early-init.el".source = "${init-el}/share/emacs/early-init.el";
  home.file.".emacs.d/templates".source = ./templates;
  home.packages = with pkgs; [
    cmigemo
    emacs-lsp-booster
    graphviz
    sqlite
    udev-gothic
    noto-fonts-cjk-serif
    (nerdfonts.override { fonts = [
      "NerdFontsSymbolsOnly"
    ]; })
  ];
  fonts.fontconfig.enable = true;
}
