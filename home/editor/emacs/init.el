;;; -*- lexical-binding: t -*-

;; Disable magic file name temporary
(defconst my-saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;;(require 'profiler)
;;(profiler-start 'cpu)

;; package.el
(require 'package)

(add-to-list 'package-archives '("gnu-elpa-devel" . "https://elpa.gnu.org/devel/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq package-archive-priorities
      '(("gnu-elpa-devel" . 3)
        ("melpa" . 2)
        ("nongnu" . 1)))

(setq package-install-upgrade-built-in t
      package-native-compile t)

;; use-package
(use-package use-package
  :custom
  (use-package-enable-imenu-support t)
  (use-package-always-ensure t))

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

(use-package auto-compile
  :config
  (setq load-prefer-newer t)
  (auto-compile-on-load-mode 1)
  (auto-compile-on-save-mode 1))

(use-package emacs
  :ensure nil
  :config
  (setq completion-cycle-threshold 3)
  (setq use-short-answers t)
  (setq native-comp-async-report-warnings-errors 'silent)
  (when (file-exists-p "~/.emacs.d/agenda-files.el")
    (load "~/.emacs.d/agenda-files.el"))
  (setq line-spacing 0.3)
  ;; indent
  (setq tab-always-indent 'complete)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  ;; performance
  (setq process-adaptive-read-buffering t)
  (setq blink-matching-paren nil)
  (setq vc-handled-backends '(Git))
  (setq auto-mode-case-fold nil)
  (setq-default bidi-display-reordering 'left-to-right)
  (setq bidi-inhibit-bpa t)
  (setq-default cursor-in-non-selected-windows nil)
  (setq highlight-nonselected-windows nil)
  (setq fast-but-imprecise-scrolling t)
  (setq ffap-machine-p-known 'reject)
  (setq idle-update-delay 1.0)
  (setq redisplay-skip-fontification-on-input t)
  (setq inhibit-compacting-font-caches t)
  (when (equal window-system 'mac)
    (setq mac-option-modifier 'meta)
    (setq mac-command-modifier 'super)
    (mac-auto-ascii-mode 1))
  ;; font
  (defun my/set-font (size)
    (let* ((asciifont "PlemolJP")
           (asciipropo "IBM Plex Sans JP")
           (jpfont "PlemolJP")
           (h (* size 10))
           (fontspec (font-spec :family asciifont))
           (jp-fontspec (font-spec :family jpfont)))
      (set-face-attribute 'default nil :family asciifont :height h)
      (set-face-attribute 'fixed-pitch nil :family asciifont :height h)
      (set-face-attribute 'variable-pitch nil :family asciipropo :height h)
      (set-fontset-font t 'japanese-jisx0213.2004-1 jp-fontspec)
      (set-fontset-font t 'japanese-jisx0213-2 jp-fontspec)
      (set-fontset-font t 'katakana-jisx0201 jp-fontspec)
      (set-fontset-font t '(#x0080 . #x024F) fontspec)
      (set-fontset-font t '(#x0370 . #x03FF) fontspec)))
  (if (display-graphic-p)
      (my/set-font 12)))

(use-package server
  :ensure nil
  :config
  (unless (server-running-p)
    (server-start)))

(use-package pixel-scroll
  :ensure nil
  :init (pixel-scroll-precision-mode 1)
  :custom
  (mouse-wheel-scroll-amount '(1 ((shift) . 1)))
  (mouse-wheel-progressive-speed nil)
  (mouse-wheel-follow-mouse 't)
  (pixel-scroll-precision-scroll-height 40.0)
  (scroll-step 1))

(use-package xt-mouse
  :ensure nil
  :if (not (display-graphic-p))
  :init (xterm-mouse-mode 1))

(use-package electric
  :ensure nil
  :hook (prog-mode . electric-indent-mode))

(use-package whitespace
  :ensure nil
  :init (global-whitespace-mode 1)
  :custom
  (whitespace-style '(face
                      trailing
                      tabs
                      spaces
                      empty
                      space-mark
                      tab-mark))
  (whitespace-display-mappings '((space-mark ?\u3000 [?\u25a1])
                                 (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
  (whitespace-space-regexp "\\(\u3000+\\)")
  (whitespace-trailing-regexp "\\([ \u00A0]+\\)$")
  (whitespace-action '(auto-cleanup)))

(use-package hl-line
  :ensure nil
  :init (global-hl-line-mode 1))

(use-package lin
  :custom
  (lin-face 'lin-red)
  :config (lin-global-mode))

(use-package autorevert
  :ensure nil
  :init (global-auto-revert-mode 1))

(use-package subword
  :ensure nil
  :init (global-subword-mode 1))

(use-package so-long
  :ensure nil
  :init (global-so-long-mode 1))

(use-package save-sexp :vc (:fetcher github :repo "emacsattic/save-sexp") :defer t)

(use-package tramp
  :ensure nil
  :defer t
  :custom
  (tramp-default-method "scpx")
  :config
  ;; for nixos machines
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin")
  (add-to-list 'tramp-remote-path "/run/wrappers/bin"))

;; UI
(use-package ef-themes
  :custom
  (ef-themes-mixed-fonts nil)
  (ef-themes-variable-pitch-ui nil)
  :config
  (load-theme 'ef-melissa-light t))

(use-package doom-modeline
  :custom
  (doom-modeline-support-imenu t)
  (doom-modeline-icon t)
  (doom-modeline-buffer-name t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-height 26)
  :hook (after-init . doom-modeline-mode)
  :config
  (doom-modeline-def-modeline 'main
    '(bar workspace-name window-number modals matches follow buffer-info remote-host buffer-position word-count)
    '(compilation misc-info github debug lsp input-method buffer-encoding major-mode process vcs check)))

(use-package perfect-margin
  :custom
  (perfect-margin-ignore-filters nil)
  :config
  (perfect-margin-mode 1))

(use-package dashboard
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-items '((recents . 15)
                     (agenda . 5)))
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-headings-icons t)
  (dashboard-set-file-icons t)
  :hook
  (after-init . dashboard-insert-startupify-lists)
  (after-init . dashboard-initialize)
  :config
  (dashboard-setup-startup-hook))

(use-package nerd-icons
  :defer t
  :config
  (ignore-errors (nerd-icons-set-font)))

(use-package nerd-icons-completion
  :defer t
  :config
  (nerd-icons-completion-mode)
  :hook
  (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package highlight-indent-guides
  :defer t
  :custom
  (highlight-indent-guides-method 'bitmap)
  (highlight-indent-guides-character 124)
  (highlight-indent-guides-responsive 'top)
  :hook
  (prog-mode . highlight-indent-guides-mode))

(use-package aggressive-indent
  :defer t
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

(use-package rainbow-delimiters
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets))

(use-package undo-fu :defer t)

(use-package vundo
  :defer t
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))
(use-package origami
  :vc (:fetcher github :repo "elp-revive/origami.el")
  :defer t
  :commands (origami-hydra/body)
  :init
  (with-eval-after-load 'pretty-hydra
    (pretty-hydra-define origami-hydra
      (:separator "-" :quit-key "q" :title "Origami")
      ("Node"
       (("o" origami-open-node "Open")
        ("c" origami-close-node "Close")
        ("s" origami-show-node "Show")
        ("t" origami-toggle-node "Toggle")
        ("S" origami-forward-toggle-node "Forward toggle")
        ("r" origami-recursively-toggle-node "Recursively toggle"))
       "All"
       (("O" origami-open-all-nodes "Open")
        ("C" origami-close-all-nodes "Close")
        ("T" origami-toggle-all-nodes "Toggle"))
       "Move"
       (("n" origami-next-fold "Next")
        ("p" origami-previous-fold "Prev"))
       "Un/Redo"
       (("u" origami-undo "Undo")
        ("U" origami-redo "Redo")
        ("x" origami-reset "Reset")))))
  :config
  (global-origami-mode t))
  
(use-package expreg :defer t)

(use-package meow
  :demand t
  :hook
  ((meow-normal-mode . (lambda nil
                         (if (and (boundp 'skk-mode) skk-mode) (skk-latin-mode-on))))
   (meow-insert-exit . corfu-quit))
  :bind
  (:map meow-normal-state-keymap
        ("C-j" . (lambda ()
                   (interactive)
                   (if (and (boundp 'skk-mode) skk-mode) (skk-j-mode-on))
                   (meow-append))))
  :custom
  (meow-cursor-type-insert '(bar . 3))
  (meow-use-cursor-position-hack t)
  (meow-selection-command-fallback
   '((meow-change . meow-change-char)
     (meow-kill . meow-delete)
     (meow-cancel-selection . keyboard-quit)
     (meow-pop-selection . meow-pop-grab)
     (meow-beacon-change . meow-beacon-change-char)))
  (meow-char-thing-table
   '((?\( . round)
     (?\[ . square)
     (?\{ . curly)
     (?\< . angle)
     (?` . backquote)
     (?s . line)
     (?b . buffer)
     (?g . string)
     (?p . paragraph)))
  (meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  :config
  (meow-thing-register 'angle
                       '(pair ("<") (">"))
                       '(pair ("<") (">")))
  (meow-thing-register 'quote
                       '(pair ("'") ("'"))
                       '(pair ("'") ("'")))
  (meow-thing-register 'wquote
                       '(pair ("\"") ("\""))
                       '(pair ("\"") ("\"")))
  (meow-thing-register 'backquote
                       '(pair ("`") ("`"))
                       '(pair ("`") ("`")))
  
  (defun meow-save-clipboard ()
    "Copy in clipboard."
    (interactive)
    (let ((meow-use-clipboard t))
      (meow-save)))

  (add-to-list 'insert-pair-alist '(?$ "\\(" "\\)"))
  
  (defun insert-pair-region (start end char)
    (interactive
     (list (region-beginning) (region-end)
           (read-char "Wrapping Char (command): ")))
    (let* ((pair (or (assoc char insert-pair-alist)
                     (rassoc (list char) insert-pair-alist)))
           (open (cond ((and pair (nth 2 pair)) (nth 1 pair))
                       (pair (nth 0 pair))
                       (t char)))
           (close (cond ((and pair (nth 2 pair)) (nth 2 pair))
                        (pair (nth 1 pair))
                        (t char))))
      (save-excursion
        (goto-char start)
        (setq start (point-marker))
        (goto-char end)
        (setq end (point-marker))
        (goto-char start)
        (insert open)
        (goto-char end)
        (insert close))
      (goto-char start)))

  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '(";" . main-hydra/body)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  ;; based on udayvir-singh's layout
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . meow-reverse)
   
   ;; basic movement
   '("h" . meow-left)
   '("j" . meow-next)
   '("k" . meow-prev)
   '("l" . meow-right)

   '("{" . scroll-up)
   '("}" . scroll-down)
   
   '("/" . consult-line)
   
   ;; expansion
   '("H" . meow-left-expand)
   '("J" . meow-next-expand)
   '("K" . meow-prev-expand)
   '("L" . meow-right-expand)
   
   '("i" . meow-back-word)
   '("I" . meow-back-symbol)
   '("o" . meow-next-word)
   '("O" . meow-next-symbol)

   '("a" . meow-mark-word)
   '("A" . meow-mark-symbol)
   '("s" . meow-line)
   '("w" . expreg-expand)
   '("q" . meow-join)
   '("g" . meow-grab)
   '("G" . meow-pop-grab)
   '("b" . meow-swap-grab)
   '("B" . meow-sync-grab)
   
   '("z" . meow-beginning-of-thing)
   '("x" . meow-end-of-thing)
   '("Z" . meow-inner-of-thing)
   '("X" . meow-bounds-of-thing)

   ;; editing
   '("d" . meow-kill)
   '("f" . meow-change)
   '("c" . meow-save)
   '("C" . meow-save-clipboard)
   '("v" . meow-yank)
   '("V" . consult-yank-pop)
   
   '("e" . meow-insert)
   '("E" . meow-open-above)
   '("r" . meow-append)
   '("R" . meow-open-below)
   
   '("u" . undo-fu-only-undo)
   '("U" . undo-fu-only-redo)
   '("<" . indent-rigidly-left-to-tab-stop)
   '(">" . indent-rigidly-right-to-tab-stop)

   '("pe" . insert-pair-region)
   '("pd" . delete-pair)
   
   ;; command
   '("," . origami-hydra/body)
   '(";" . main-hydra/body)
   '("." . embark-act)
   '("m" . major-mode-hydra)
   '("n" . vertico-repeat)
   '("\'" . avy-goto-word-1)
   '("\"" . avy-hydra/body)
   ;; ignore escape
   '("<escape>" . ignore))
  (meow-global-mode +1))

(use-package which-key
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.7)
  (which-key-show-early-on-C-h t))

(use-package hydra :defer t)

(use-package major-mode-hydra
  :commands (major-mode-hydra origami-hydra/body main-hydra/body avy-hydra/body)
  :config
  (pretty-hydra-define main-hydra (:separator "=" :title "Main" :foreign-keys warn :quit-key "q" :exit t)
    ("File"
     (("f" find-file "Find file")
      ("d" find-dired "Find directory")
      ("b" consult-buffer "Buffer")
      ("r" find-recentf "Recent")
      ("s" save-buffer "Save file"))
     "Edit"
     (("z" origami-hydra/body "Origami")
      ("u" vundo "Visual Undo"))
     "Code"
     (("l" eglot-hydra/body "LSP")
      ("h" eldoc-box-help-at-point "ElDoc")
      ("i" consult-imenu "Imenu"))
     "View"
     (("D" delete-other-windows "Only this win")
      ("w" ace-window "Window select")
      ("W" window-hydra/body "Window control"))
     "Tool"
     (("j" major-mode-hydras/org-mode/body "Org")
      ("n" org-capture "Org-capture")
      ("a" org-agenda "Agenda")
      ("v" vterm "Terminal")
      ("m" major-mode-hydra "Major Mode Hydra")
      ("g" magit-status "Magit!")
      ("@" dashboard-open "Dashboard"))))
  (pretty-hydra-define window-hydra (:separator "-" :title "Window" :foreign-keys warn :quit-key "q")
    ("Move"
     (("h" windmove-left "Move Left")
      ("j" windmove-down "Move Down")
      ("k" windmove-up   "Move Up" )
      ("l" windmove-right "Move Right"))

     "Split"
     (("v" split-window-vertically "Vertical")
      ("s" split-window-horizontally "Horizontal"))

     "Delete"
     (("d" delete-window "Delete")
      ("D" delete-other-windows "Only This Win")))))

(use-package hydra-posframe
  :vc (:fetcher github :repo "Ladicle/hydra-posframe")
  :init
  (hydra-posframe-mode)
  :custom
  (hydra-posframe-parameters '((left-fringe . 5)
                               (right-fringe . 5)
                               (alpha-background . 80)))
  (hydra-posframe-poshandler #'posframe-poshandler-frame-bottom-right-corner))

;; ace/avy
(use-package ace-window
  :defer t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c")))))

(use-package avy
  :defer t
  :init
  (with-eval-after-load 'pretty-hydra
    (pretty-hydra-define avy-hydra
      (:separator "-" :title "avy" :foreign-keys warn :quit-key "q" :exit t)
      ("Char"
       (("c" avy-goto-char "Char")
        ("C" avy-goto-char-2 "Char 2")
        ("t" avy-goto-char-timer "Char Timer"))
       "Word"
       (("w" avy-goto-word-1 "Word")
        ("W" avy-goto-word-0 "Word 0"))
       "Line"
       (("l" avy-goto-line "Line"))
       "Appx"
       (("r" avy-resume "Resume"))))))

;; mini-buffer completion
(use-package vertico
  :custom
  (vertico-cycle t)
  :config
  (defvar +vertico-current-arrow t)

  (cl-defmethod vertico--format-candidate :around
    (cand prefix suffix index start &context ((and +vertico-current-arrow
                                                   (not (bound-and-true-p vertico-flat-mode)))
                                              (eql t)))
    (setq cand (cl-call-next-method cand prefix suffix index start))
    (if (bound-and-true-p vertico-grid-mode)
        (if (= vertico--index index)
            (concat (nerd-icons-faicon "nf-fa-hand_o_right") " " cand)
          (concat #("_" 0 1 (display " ")) cand))
      (if (= vertico--index index)
          (concat " " (nerd-icons-faicon "nf-fa-hand_o_right") " " cand)
        (concat "    " cand))))
  (vertico-mode))

(use-package vertico-posframe
  :vc (:fetcher github :repo "tumashu/vertico-posframe")
  :init
  (vertico-posframe-mode 1)
  :custom
  (vertico-posframe-parameters
   '((left-fringe . 5)
     (right-fringe . 5)
     (alpha-background . 90))))

(use-package vertico-repeat
  :ensure nil
  :after vertico
  :hook (minibuffer-setup . vertico-repeat-save))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind
  (:map vertico-map
        ("<backspace>" . vertico-directory-delete-char)))

(use-package vertico-truncate
  :vc (:fetcher github :repo "jdtsmith/vertico-truncate")
  :config
  (vertico-truncate-mode t))

(use-package savehist
  :ensure nil 
  :after (vertico)
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after (vertico)
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package embark
  :defer 2
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package consult
  :defer t
  :custom
  (consult-preview-key 'any))

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
  
;; code-completion
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary nil)
  (corfu-scroll-margin 2)
  :bind (:map corfu-map
              ("RET" . nil))
  :init
  (global-corfu-mode 1))

(use-package corfu-popupinfo
  :ensure nil
  :hook (corfu-mode . corfu-popupinfo-mode))

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :after corfu
  :config
  (corfu-terminal-mode +1))

(use-package cape
  :after corfu
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; snippet
(use-package yasnippet
  :init
  (yas-global-mode 1))

(use-package yasnippet-capf
  :vc (:fetcher github :repo "elken/yasnippet-capf")
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

;; skk
(use-package ddskk
  :bind ("C-x j" . skk-mode)
  :init
  (setq default-input-method "japanese-skk")
  (setq skk-user-directory "~/SKK")
  (setq skk-large-jisyo "~/SKK/SKK-JISYO.L")
  (setq skk-jisyo (cons "~/SKK/skk-jisyo" 'utf-8))
  (setq skk-delete-implies-kakutei nil)
  (setq skk-henkan-strict-okuri-precedence t)
  (setq skk-egg-like-newline t)
  (setq skk-kutouten-type 'jp)
  (setq skk-use-auto-kutouten t)
  (setq skk-check-okurigana-on-touroku 'ask)
  (setq skk-status-indicator 'minor-mode)
  (setq skk-show-icon nil)
  (setq skk-show-annotation t)
  (setq skk-show-mode-show t)
  (setq skk-dcomp-activate t)
  (setq skk-dcomp-multiple-activate t)
  (setq skk-azik-keyboard-type 'us101)
  (setq skk-use-azik t)
  (setq skk-rom-kana-rule-list
        '(("q" nil skk-toggle-characters)
          ("!" nil skk-purge-from-jisyo)
          ("[" nil ("「" . "「"))))
  :hook
  (find-file . (lambda nil (skk-latin-mode 1))))

(use-package ddskk-posframe
  :init
  (ddskk-posframe-mode 1))

;; org
(use-package org
  :ensure nil
  :defer t
  :custom
  (org-return-follows-link t)
  (org-mouse-1-follows-link t)
  (org-directory "~/Org")
  (org-preview-latex-default-process 'dvisvgm)
  (org-preview-latex-image-directory "~/Org/resources/ltximg/")
  (org-id-method 'ts)
  :init
  (with-eval-after-load 'major-mode-hydra
    (major-mode-hydra-define org-mode
      (:separator "-" :title "Org" :quit-key "q" :exit t)
      ("Navi"
       (("o" consult-outline "Outline"))
       "Edit"
       (("l" org-insert-link "Link")
        ("t" org-insert-todo-heading "Todo")
        ("h" org-insert-heading-respect-content "Heading")
        ("p" org-set-property "Property")
        ("r" org-refile "Refile")
        ("q" org-set-tags-command "Tag"))
       "Task"
       (("s" org-schedule "Schedule")
        ("d" org-deadline "Deadline")
        ("x" org-toggle-checkbox "Check"))
       "Roam"
       (("f" consult-org-roam-file-find "Find")
        ("i" org-roam-node-insert "Insert")
        ("g" org-roam-graph-show "Show Graph")
        ("b" org-roam-buffer-toggle "Roam Buffer" :toggle t :exit nil)
        ("!" org-id-get-create "Get ID")
        ("@" org-roam-db-sync "Sync")))))
  (defun my/org-capf ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'cape-tex
                       #'cape-dabbrev
                       #'pcomplete-completions-at-point))))
  (add-hook 'org-mode-hook #'my/org-capf)
  :config
  (defvar org-export-directory "~/Org/export")

  (defun org-export-output-file-name--set-directory (orig-fn extension &optional subtreep pub-dir)
    (setq pub-dir (or pub-dir org-export-directory))
    (funcall orig-fn extension subtreep pub-dir))
  (advice-add 'org-export-output-file-name :around 'org-export-output-file-name--set-directory))

(use-package ob
  :ensure nil
  :defer t
  :after org
  :custom
  (org-babel-load-languages nil)
  :init
  ;; ob lazy loading
  ;; https://misohena.jp/blog/2022-08-16-reduce-org-mode-startup-time-org-babel.html
  (with-eval-after-load 'org
    (defvar my-org-babel-languages
      ;;(<langname> . ob-<filename>.el)
      '((elisp . emacs-lisp)
        (emacs-lisp . emacs-lisp)
        (makefile . makefile)
        (ditaa . ditaa)
        (dot . dot)
        (plantuml . plantuml)
        (perl . perl)
        (cpp . C)
        (C++ . C)
        (D . C)
        (C . C)
        (js . js)
        (java . java)
        (org . org)
        (R . R)
        (gnuplot . gnuplot)
        (julia . julia-vterm)
        (julia-vterm . julia-vterm)
        (python . python)
        (shell . shell)
        (sh . shell)
        (bash . shell)
        (zsh . shell)
        (fish . shell)
        (csh . shell)
        (ash . shell)
        (dash . shell)
        (ksh . shell)
        (mksh . shell)
        (posh . shell)))

    (defun my-org-babel-language-files ()
      "重複しない全ての言語バックエンドファイル名を返す。"
      (seq-uniq (mapcar #'cdr my-org-babel-languages)))

    ;; my-org-babel-languagesからorg-babel-load-languagesを設定する。
    ;; org-lintやorg-pcompleteにorg-babel-load-languagesを使った処理がある
    ;; ようなので。
    ;; このときcustom-set-variablesを使わないようにすること。
    ;; org-babel-do-load-languagesが呼ばれて全部読み込まれてしまうので。
    (setq org-babel-load-languages
          (mapcar (lambda (lang) (cons lang t)) ;;(emacs-lisp . t)のような形式
                  (my-org-babel-language-files)))

    (defun my-org-require-lang-file (lang-file-name)
      "ob-LANG-FILE-NAME.elを読み込む。"
      (when lang-file-name
        (require (intern (format "ob-%s" lang-file-name)) nil t)))

    (defun my-org-require-lang (lang)
      "LANGを読み込む。"
      (my-org-require-lang-file
       (alist-get
        (if (stringp lang) (intern lang) lang)
        my-org-babel-languages)))

    (defun my-org-require-lang-all ()
      "全ての言語を読み込む。"
      (mapc #'my-org-require-lang-file
            (my-org-babel-language-files)))

    ;; org-elementで言語名を返す時、その言語をロードする。
    (advice-add #'org-element-property :around #'my-org-element-property)
    (defun my-org-element-property (original-fun property element)
      (let ((value (funcall original-fun property element)))
        (when (eq property :language)
          (my-org-require-lang value))
        value))

    ;; ob-table.elに(org-babel-execute-src-block nil (list "emacs-lisp" "results" params))
    ;; のような呼び出し方をする所があるので。
    (advice-add #'org-babel-execute-src-block :around
                #'my-org-babel-execute-src-block)
    (defun my-org-babel-execute-src-block (original-fun
                                           &optional arg info params)
      (my-org-require-lang (nth 0 info))
      (funcall original-fun arg info params))

    ;; (match-string)の値を直接langとして渡しているので。
    (advice-add #'org-babel-enter-header-arg-w-completion :around
                #'my-org-babel-enter-header-arg-w-completion)
    (defun my-org-babel-enter-header-arg-w-completion (original-fun
                                                       lang)
      (my-org-require-lang lang)
      (funcall original-fun lang))

    ;; org-lint(org-lint-wrong-header-argument, org-lint-wrong-header-value)内で参照しているので。
    ;; 面倒なので全部読み込んでしまう。
    (advice-add #'org-lint :around #'my-org-lint)
    (defun my-org-lint (original-fun &rest args)
      (my-org-require-lang-all)
      (apply original-fun args)))
  :config
  (add-to-list 'org-babel-default-header-args '(:output-dir . "~/Org/resources"))
  
  ;; https://github.com/gmoutso/dotemacs/blob/master/lisp/tanglerc.el
  ;; tangle functions org version 9.4
  ;;
  ;; to be used with header arguments :tangle yes :comments yes :noweb yes

  (setq org-babel-tangle-comment-format-beg
        "%% [[%link][%source-name]]")

  (defun gm/org-babel-get-block-header (&optional property)
    "Returns alist of header properties of this block or specific PROPERTY.

Eg., use with PROPERTY :results or :session.
"
    (let* ((info (org-babel-get-src-block-info 'light))
	         (properties (nth 2 info)))
      (if property (cdr (assq property properties))
        properties)))


  ;; To be able to go to jump to the link in tangled file from a given block in org
  ;; we need the comment link using 'gm/org-babel-tangle-get-this-comment-link
  ;; most functions here try to get this (viz. getting the counter used in the link)

  (defun gm/org-babel-tangle-count-this ()
    "Count source block number in section.

Note, does not give correct file search field in orglink as in the tangled file if before all headings!"
    (let ((here (point))
	        (beg (org-with-wide-buffer
		            (org-with-limited-levels (or (outline-previous-heading) (point-min))))))
      (let ((case-fold-search nil))
	      (count-matches "^ *#\\+begin_src" beg here))))

  (defun gm/org-babel-tangle-get-this-comment-link ()
    "Extracts the org link that comments the source block in the tangled file."
    (pcase-let*
        ((counter (gm/org-babel-tangle-count-this))
         (tangled-block (org-babel-tangle-single-block counter))
         (`(,start ,file ,link ,source ,info ,body ,comment) tangled-block)
         (link-data `(("start-line" . ,(number-to-string start))
		                  ("file" . ,file)
		                  ("link" . ,link)
		                  ("source-name" . ,source))))
      (org-fill-template
		   org-babel-tangle-comment-format-beg link-data)))

  (defun gm/goto-tangled-block ()
    "The opposite of `org-babel-tangle-jump-to-org'. Jumps at tangled code from org src block.

https://emacs.stackexchange.com/a/69591"
    (interactive)
    (if (org-in-src-block-p)
        (let* ((header (car (org-babel-tangle-single-block 1 'only-this-block)))
	             ;; ("test.py" ("python" 9 "test.org" "file:test.org::*a" "a:1" properties code nil))
	             ;; if tangle is no then car will be nil!
	             (tangle (car header))
	             (rest (cadr header))
               (lang (car rest))
               (org-buffer (nth 2 rest))
               (org-id (nth 3 rest))
               (source-name (nth 4 rest))
               (search-comment (gm/org-babel-tangle-get-this-comment-link))
               (file (expand-file-name
                      (org-babel-effective-tangled-filename org-buffer lang tangle))))
          (if (not (file-exists-p file))
              (message "File does not exist. 'org-babel-tangle' first to create file.")
            (find-file file)
            (beginning-of-buffer)
            (search-forward search-comment)))
      (message "Cannot jump to tangled file because point is not at org src block.")))

  (defun gm/tangle-and-goto-block ()
    "Goes to the tangled file at the source block."
    (interactive)
    (let ((current-prefix-arg 8))
      (call-interactively 'org-babel-tangle))
    (gm/goto-tangled-block))

  (defun gm/detangle-and-goto-block ()
    "Detangle and go to block at point.

Note sure why this was written: all languages must be the same in org file."
    (interactive)
    (let ((org-src-preserve-indentation t))
      (org-babel-detangle))
    (org-babel-tangle-jump-to-org)))

(use-package org-indent
  :ensure nil
  :after org
  :disabled
  :hook (org-mode . org-indent-mode))

(use-package ob-async :after org)

(use-package org-tempo :ensure nil :after org)

(use-package org-src
  :ensure nil
  :after org
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-src-preserve-indentation t)
  (org-edit-src-content-indentation 0))

(use-package org-noter
  :after (:any org pdf-view)
  :custom
  (org-noter-notes-window-location 'vertical-split)
  (org-noter-always-create-frame nil)
  :config
  (org-noter-enable-org-roam-integration))

(use-package org-attach
  :ensure nil
  :after org
  :custom
  (org-attach-id-dir "~/Org/resources")
  (org-attach-id-to-path-function-list
   '(org-attach-id-ts-folder-format
     org-attach-id-uuid-folder-format)))

(use-package org-agenda
  :ensure nil
  :defer t
  :custom
  (org-agenda-span 'day)
  (org-log-done 'time))

(use-package ox-latex
  :ensure nil
  :after org
  :defer t
  :config
  (setq org-latex-pdf-process '("latexmk -f -pdfdvi -gg -output-directory=%o %f"))
  (setq org-export-in-background t)
  (setq org-file-apps '(("pdf" . "evince %s")))
  (setq org-latex-default-class "jlreq")
  (add-to-list 'org-latex-classes
               '("jlreq"
                 "\\documentclass[11pt,paper=a4]{jlreq}
[NO-DEFAULT-PACKAGES]
\\usepackage{amsmath}
\\ifdefined\\kanjiskip
  \\usepackage[dvipdfmx]{graphicx}
  \\usepackage[dvipdfmx]{hyperref}
  \\usepackage{pxjahyper}
  \\hypersetup{colorlinks=true}
\\else
  \\usepackage{graphicx}
  \\usepackage{hyperref}
  \\hypersetup{pdfencoding=auto,colorlinks=true}
\\fi"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(use-package org-modern
  :after org
  :defer t
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :custom
  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  ;; (org-ellipsis '…')
  (org-agenda-tags-column 0)
  (org-agenda-block-separator ?─)
  (org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  (org-agenda-current-time-string
   "◀── now ─────────────────────────────────────────────────"))

(use-package org-modern-indent
  :vc (:fetcher github :repo "jdtsmith/org-modern-indent")
  :disabled
  :defer t
  :init
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(use-package org-roam
  :defer t
  :custom
  (org-roam-db-location "~/.emacs.d/org-roam.db")
  (org-roam-directory "~/Org/roam")
  (org-roam-index-file "~/Org/roam/index.org")
  (org-roam-completion-functions '())
  (org-roam-node-display-template
   (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-capture-templates
   '(("m" "main" plain
      "%?"
      :if-new (file+head "main/%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n")
      :immediate-finish t
      :unnarrowed t)
     ("r" "reference" plain "%?"
      :if-new
      (file+head "reference/%<%Y%m%d%H%M%S>-${title}.org"
                 "#+title: ${title}\n")
      :immediate-finish t
      :unnarrowed t)
     ("a" "article" plain "%?"
      :if-new
      (file+head "article/%<%Y%m%d%H%M%S>-${title}.org"
                 "#+title: ${title}\n#+filetags: :article:\n")
      :immediate-finish t
      :unnarrowed t)))
  :config
  (require 'vulpea-buffer)
  (defun vulpea-project-p ()
    "Return non-nil if current buffer has any todo entry.
    TODO entries marked as done are ignored, meaning the this
    function returns nil if current buffer contains only completed
    tasks."
    (org-element-map
        (org-element-parse-buffer 'headline)
        'headline
      (lambda (h)
        (eq (org-element-property :todo-type h)
            'todo))
      nil 'first-match))

  (defun vulpea-project-update-tag ()
    "Update PROJECT tag in the current buffer."
    (when (and (not (active-minibuffer-window))
               (vulpea-buffer-p))
      (save-excursion
        (goto-char (point-min))
        (let* ((tags (vulpea-buffer-tags-get))
               (original-tags tags))
          (if (vulpea-project-p)
              (setq tags (cons "task" tags))
            (setq tags (remove "task" tags)))

          ;; cleanup duplicates
          (setq tags (seq-uniq tags))
          
          ;; update tags if changed
          (when (or (seq-difference tags original-tags)
                    (seq-difference original-tags tags))
            (apply #'vulpea-buffer-tags-set tags))))))

  (defun vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is a note."
    (and buffer-file-name
         (string-prefix-p
          (expand-file-name (file-name-as-directory org-roam-directory))
          (file-name-directory buffer-file-name))))

  (defun vulpea-project-files ()
    "Return a list of note files containing 'task' tag." ;
    (seq-uniq
     (seq-map
      #'car
      (org-roam-db-query
       [:select [nodes:file]
                :from tags
                :left-join nodes
                :on (= tags:node-id nodes:id)
                :where (like tag (quote "%\"task\"%"))]))))

  (defun vulpea-agenda-files-update (&rest _)
    "Update the value of `org-agenda-files'."
    (setq org-agenda-files (vulpea-project-files))
    (require 'save-sexp)
    (save-sexp-save-setq "~/.emacs.d/agenda-files.el" 'org-agenda-files))

  (add-hook 'find-file-hook #'vulpea-project-update-tag)
  (add-hook 'before-save-hook #'vulpea-project-update-tag)

  (advice-add 'org-agenda :before #'vulpea-agenda-files-update)
  (advice-add 'org-todo-list :before #'vulpea-agenda-files-update)
  (add-to-list 'org-tags-exclude-from-inheritance "task")
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))
  (defun org-roam-tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'org-roam-tag-new-node-as-draft)
  (org-roam-db-autosync-mode t))

(use-package vulpea
  :defer t
  :hook (org-roam-db-autosync-mode . vulpea-db-autosync-enable))

(use-package consult-org-roam
  :defer t
  :after org-roam
  :custom
  (consult-org-roam-grep-func #'consult-ripgrep)
  (consult-org-roam-buffer-narrow-key ?n)
  (consult-org-roam-buffer-after-buffers t)
  :config
  (consult-org-roam-mode t))

(use-package org-capture
  :ensure nil
  :defer t
  :after org
  :custom
  (org-capture-templates
   '(("n" "Notes" entry (file+headline "~/Org/notes.org" "Notes")
      "* %U\n%?")
     ("t" "Todo" entry (file+headline "~/Org/todo.org" "Todos")
      "* TODO %?\n %i\n %a"))))

(use-package org-journal
  :defer t
  :bind
  (nil :map calendar-mode-map
       ("C-j n" . org-journal-new-date-entry)
       ("C-j r" . org-journal-read-entry)
       ("C-j d" . org-journal-display-entry))
  :custom
  (org-journal-dir "~/Org/journal")
  (org-journal-date-format "%A, %d %B %Y")
  (org-journal-file-type 'daily))

(use-package calendar
  :ensure nil
  :defer t
  :custom
  (calendar-remove-frame-by-deleteing t)
  :init
  (with-eval-after-load 'major-mode-hydra
    (major-mode-hydra-define calendar-mode
      (:separator "-" :title "Calendar" :exit nil :quit-key "q" :exit nil)
      ("Move"
       (("h" calendar-backward-day "←" :exit nil)
        ("j" calendar-forward-week "↓" :exit nil)
        ("k" calendar-backward-week "↑" :exit nil)
        ("l" calendar-forward-day "→" :exit nil)
        ("o" calendar-forward-month "→→" :exit nil)
        ("i" calendar-backward-month "←←" :exit nil)
        (",w" calendar-beginning-of-week "|←" :exit nil)
        (".w" calendar-end-of-week "→|" :exit nil)
        (",m" calendar-beginning-of-month "|←←" :exit nil)
        (".m" calendar-end-of-month "→→|" :exit nil)
        (">" calendar-scroll-left ">>" :exit nil)
        ("<" calendar-scroll-right "<<" :exit nil)
        ("gd" calendar-goto-date "Date" :exit nil)
        ("t" calendar-goto-today "Today" :exit nil))
       "Journal"
       (("n" org-journal-new-date-entry "New" :exit t)
        ("r" org-journal-read-entry "Read" :exit t)
        ("d" org-journal-display-entry "Display" :exit t)
        ("[" org-journal-previous-entry "Prev")
        ("]" org-journal-next-entry "Next")
        ("sf" org-journal-search-forever "Future")
        ("sm" org-journal-search-month "Month"))))))
         
(use-package japanese-holidays
  :defer t
  :after calendar
  :config
  (setq calendar-holidays
        (append japanese-holidays holiday-local-holidays holiday-other-holidays))
  (setq calendar-mark-holidays-flag t))

;; lsp
(use-package eglot
  :defer t
  :custom
  (eglot-autoshutdown t)
  (eglot-ignored-server-capabilities '(:documentHighlightProvider
                                       :documentOnTypeFormattingProvider))
  (eglot-events-buffer-size 0)
  (eglot-sync-connect nil)
  :hook
  (eglot-managed-mode . my/eglot-capf)
  ((c-ts-mode c++-ts-mode rust-ts-mode) . eglot-ensure)
  :config
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'eglot-completion-at-point
                       #'yasnippet-capf
                       #'cape-file))))
  ;; (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(rustic-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(tex-mode . ("texlab")))
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless))))
  :init
  (with-eval-after-load 'pretty-hydra
    (pretty-hydra-define eglot-hydra
      (:exit t :separator "=" :title "LSP" :foreign-keys warn :quit-key "q")
      ("Server"
       (("+" eglot "Start Server")
        ("@" eglot-reconnect "Restart Server")
        ("!" eglot-shutdown "Shutdown Server"))
       "Actions"
       (("r" eglot-rename "Rename")
        ("f" eglot-format "Format")
        ("a" eglot-code-action "Code actions")
        ("q" eglot-code-action-quickfix "Quickfix")
        ("i" eglot-code-action-organize-imports "Organize imports"))
       "Symbols"
       (("/" consult-eglot-symbols "Symbol")))
      )))

(use-package jsonrpc
  :defer t
  :config
  (setq jsonrpc-default-request-timeout 3000)
  (fset #'jsonrpc--log-event #'ignore))

(use-package eglot-booster
  :vc (:fetcher github :repo "jdtsmith/eglot-booster")
  :after eglot
  :config
  (eglot-booster-mode 1))

(use-package eglot-x
  :vc (:fetcher github :repo "nemethf/eglot-x")
  :after eglot
  :config
  (eglot-x-setup))

(use-package eglot-signature-eldoc-talkative
  :after (eldoc-box eglot)
  :config
  (advice-add #'eglot-signature-eldoc-function
              :override #'eglot-signature-eldoc-talkative))

(use-package consult-eglot
  :defer t
  :after eglot)

;; eldoc
(use-package eldoc-box
  :defer t
  :bind ("<f5>" . eldoc-box-help-at-point)
  :init
  (remove-hook 'eldoc-display-functions #'eldoc-display-in-echo-area))

;; git
(use-package magit :defer t)

(use-package transient :defer t)

(use-package git-auto-commit-mode
  :defer t
  :custom
  (gac-automatically-add-new-files-p t)
  :config
  (defun gac-pull-before-push (&rest _args)
    (let ((current-file (buffer-file-name)))
      (shell-command "git pull")
      (when current-file
        (with-current-buffer (find-buffer-visiting current-file)
          (revert-buffer t t t)))))
  (advice-add 'gac-push :before #'gac-pull-before-push))

;; terminal
(use-package vterm
  :ensure nil ;; installed by Nix
  :defer t
  :hook
  (vterm-mode . (lambda ()
                  (setq-local global-hl-line-mode nil)
                  (hl-line-mode -1)))
  :custom
  (vterm-shell "nu --config ~/.config/nushell/emacs-config.nu")
  (vterm-timer-delay 0.01))

(use-package meow-vterm
  :vc (:fetcher github :repo "accelbread/meow-vterm")
  :defer t
  :init
  (defun my/meow-vterm-setup ()
    "Modified meow-vterm-setup for lazy loading"
    (require 'meow-vterm)
    (define-key vterm-mode-map (kbd "C-c ESC") #'vterm-send-escape)
    (dolist (c '((yank . vterm-yank)
                 (xterm-paste . vterm-xterm-paste)
                 (yank-pop . vterm-yank-pop)
                 (mouse-yank-primary . vterm-yank-primary)
                 (self-insert-command . vterm--self-insert)
                 (beginning-of-defun . vterm-previous-prompt)
                 (end-of-defun . vterm-next-prompt)))
      (define-key meow-vterm-normal-mode-map (vector 'remap (car c)) (cdr c)))
    (meow-vterm-setup))
  (defun my/meow-vterm-enable ()
    "Modified meow-vterm-enable for lazy loading"
    (setq vterm-keymap-exceptions '("C-c"))
    (add-hook 'vterm-mode-hook #'my/meow-vterm-setup))
  (my/meow-vterm-enable))

;; flymake
(use-package flymake
  :ensure nil
  :defer t
  :hook (eglot-managed-mode . flymake-mode)
  :bind (nil
         :map flymake-mode-map
         ("C-c n" . flymake-goto-next-error)
         ("C-c p" . flymake-goto-prev-error)))

;; dired
(use-package async
  :defer t
  :init
  (with-eval-after-load 'dired (dired-async-mode 1)))

;; treesitter
(use-package treesit
  :ensure nil
  :custom
  (treesit-font-lock-level 4))

(use-package treesit-auto
  :custom
  (treesit-auto-install t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; PDF
(use-package pdf-tools
  :ensure nil ;; installed by Nix
  :defer t
  :custom
  (pdf-annot-activate-created-annotations t)
  (pdf-cache-image-limit 15)
  (image-cache-eviction-delay 15)
  (pdf-view-resize-factor 1.1)
  :init
  (pdf-loader-install))

;; Rust
(use-package rust-mode
  :mode "\\.rs\\'"
  :custom
  (rust-mode-treesitter-derive t))

;; Julia
(use-package julia-mode
  :mode "\\.jl\\'")

(use-package julia-vterm
  :hook (julia-mode . julia-vterm-mode))

(use-package ob-julia-vterm
  :defer t
  :config
  (defalias 'org-babel-execute:julia 'org-babel-execute:julia-vterm)
  (defalias 'org-babel-variable-assignments:julia 'org-babel-variable-assignments:julia-vterm))

;; Ocaml
(use-package tuareg :defer t)

;; Nushell
(use-package nushell-mode
  :mode "\\.nu\\'")

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'")

;; Gnuplot
(use-package gnuplot
  :mode ("\\.gp\\'" . gnuplot-mode))

;; Enable magic file name and GC
(setq file-name-handler-alist my-saved-file-name-handler-alist)
(setq gc-cons-percentge 0.2)
(setq gc-cons-threshold 100000000) ;; 100mb
(add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages t)

;;(profiler-report)
;;(profiler-stop)

(provide 'init)
