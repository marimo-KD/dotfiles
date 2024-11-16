{pkgs, config, ...}: let
  init-el = pkgs.callPackage ./init-el.nix { emacs = config.programs.emacs.finalPackage; };
  fetchFromGitHub = pkgs.fetchFromGitHub;
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
      nerd-icons
      nerd-icons-completion
      rainbow-delimiters
      aggressive-indent
      vertico
      marginalia
      consult
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
      which-key
      hydra
      major-mode-hydra
      avy
      ace-window
      migemo
      ddskk
      ddskk-posframe
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
      citar
      japanese-holidays
      eldoc-box
      eglot
      vterm
      nerd-icons-dired
      diredfl
      dired-preview
      dired-subtree
      dired-collapse
      magit
      treesit-grammars.with-all-grammars
      rust-mode
      tuareg
      julia-mode
      julia-vterm
      ob-julia-vterm
      nushell-mode
      nix-ts-mode
      gnuplot
      auctex
      cdlatex
      pdf-tools
    ] ++ [
      (trivialBuild {
        pname = "vertico-posframe";
        version = "2024-02-02";
        src = fetchFromGitHub {
          owner = "tumashu";
          repo = "vertico-posframe";
          rev = "2e0e09e5bbd6ec576ddbe566ab122575ef051fab";
          hash = "sha256-xBntlulKZizYn6qLXuQR9hhWfuW48cqRAEneA8J0qh0=";
        };
        buildInputs = [
          epkgs.vertico
          epkgs.posframe
        ];
      })
      (trivialBuild {
        pname = "hydra-posframe";
        version = "2023-07-17";
        src = fetchFromGitHub {
          owner = "Ladicle";
          repo = "hydra-posframe";
          rev = "142a04dd588af6c725e331863c3ca7bd5dda13ec";
          hash = "sha256-9nVBnpaWZIYNDvS2WWBED0HsIRIv4AR4as6wEe463tI=";
        };
        buildInputs = [
          epkgs.hydra
          epkgs.posframe
        ];
      })
      (trivialBuild {
        pname = "indent-bars";
        version = "2024-07-27";
        src = fetchFromGitHub {
          owner = "jdtsmith";
          repo = "indent-bars";
          rev = "a86f8eca12d62a4318a60b27f2a5a68231ca9f11";
          hash = "sha256-XCowediIH3hp1K85Y6eZqgrumb39/dvEjav0V1H7Bz4=";
        };
        buildInputs = [
          epkgs.compat
        ];
      })
      (trivialBuild {
        pname = "org-modern-indent";
        version = "2024-03-20";
        src = fetchFromGitHub {
          owner = "jdtsmith";
          repo = "org-modern-indent";
          rev = "f2b859bc53107b2a1027b76dbf4aaebf14c03433";
          hash = "sha256-vtbaa3MURnAI1ypLueuSfgAno0l51y3Owb7g+jkK6JU=";
        };
        buildInputs = [
          epkgs.compat
        ];
      })
      (trivialBuild {
        pname = "eglot-booster";
        version = "2024-04-11";
        src = fetchFromGitHub {
          owner = "jdtsmith";
          repo = "eglot-booster";
          rev = "e19dd7ea81bada84c66e8bdd121408d9c0761fe6";
          hash = "sha256-vF34ZoUUj8RENyH9OeKGSPk34G6KXZhEZozQKEcRNhs=";
        };
        buildInputs = [
          epkgs.eglot
        ];
      })
      (trivialBuild {
        pname = "eglot-x";
        version = "2024-07-07";
        src = fetchFromGitHub {
          owner = "nemethf";
          repo = "eglot-x";
          rev = "ada0c9f32deac90038661f461966aae51707abff";
          hash = "sha256-qZrJkGUBnSvH6w2MuIdYg/2Vb7eowAU0CqTw2LleDhM=";
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
        pname = "meow-tree-sitter";
        version = "2024-07-01";
        src = fetchFromGitHub {
          owner = "skissue";
          repo = "meow-tree-sitter";
          rev = "d8dce964fac631a6d44b650a733075e14854159c";
          hash = "sha256-XdTeUq1J/zKoYaIDbl86LYuhJZJbaLFEpz7i5CxE8js=";
        };
        buildInputs = [ epkgs.meow ];
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
  ];
  fonts.fontconfig.enable = true;
}
