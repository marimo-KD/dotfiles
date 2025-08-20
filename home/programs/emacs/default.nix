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
            then (pkgs.emacs-unstable.override { withNativeCompilation = false; } ).overrideAttrs (old: {
              withXwidgets = true;
              # withNativeCompilation = false; # ad-hoc fix for libgccjit issue
              buildInputs = old.buildInputs ++ [
                pkgs.darwin.apple_sdk.frameworks.WebKit
              ];
              configureFlags = old.configureFlags ++ ["--with-xwidgets"];
              patches = (old.patches or [ ]) ++ [
                ./emacs-29.1-inline.patch
              ];
            })
            else pkgs.emacs-unstable-pgtk
      );
      in myemacs
    );
    overrides = (self: super: {
      lsp-mode = super.lsp-mode.overrideAttrs (old: {
        buildPhase = ''
          export LSP_USE_PLISTS=true
        '' + old.buildPhase;
      });
    });
    extraPackages = (epkgs: with epkgs; [
      ligature
      ef-themes
      nano-modeline
      moody
      minions
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
      corfu
      corfu-terminal
      cape
      nerd-icons-corfu
      undo-fu
      vundo
      expreg
      puni
      which-key
      avy
      ace-window
      popper
      migemo
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
      calfw
      calfw-org
      eldoc-box
      lsp-mode
      lsp-ui
      yasnippet
      eat
      vterm
      nerd-icons-dired
      diredfl
      dired-preview
      dired-subtree
      dired-collapse
      magit
      diff-hl
      treesit-grammars.with-all-grammars
      treesit-fold
      envrc
      rust-mode
      tuareg
      julia-mode
      nushell-ts-mode
      nix-ts-mode
      markdown-mode
      faust-mode
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
      ((melpaBuild {
        pname = "lean4-mode";
        version = "1.1.2";
        src = fetchFromGitHub {
          owner = "leanprover-community";
          repo = "lean4-mode";
          rev = "76895d8939111654a472cfc617cfd43fbf5f1eb6";
          hash = "sha256-DLgdxd0m3SmJ9heJ/pe5k8bZCfvWdaKAF0BDYEkwlMQ=";
        };
        buildInputs = [
          epkgs.lsp-mode
          epkgs.dash
          epkgs.magit
        ];
        recipe = pkgs.writeText "recipe" ''
          (lean4-mode
          :repo "leanprover-community/lean4-mode" :fetcher github
          :files ("lean4-*.el" "data"))
        '';
      }).overrideAttrs (old: {
        buildPhase = ''
          export LSP_USE_PLISTS=true
        '' + old.buildPhase;
      }))
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
    nerd-fonts.symbols-only
  ];
  fonts.fontconfig.enable = true;
}
