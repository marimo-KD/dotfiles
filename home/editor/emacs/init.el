
;;; -*- lexical-binding: t -*-

;; Disable magic file name temporary
(defconst my-saved-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;;(require 'profiler)
;;(profiler-start 'cpu)


;;(defvar setup-tracker--level 0)
;;(defvar setup-tracker--parents nil)
;;(defvar setup-tracker--times nil)

;;(when load-file-name
;;  (push load-file-name setup-tracker--parents)
;;  (push (current-time) setup-tracker--times)
;;  (setq setup-tracker--level (1+ setup-tracker--level)))
;;(add-variable-watcher
;; 'load-file-name
;; (lambda (_ v &rest __)
;;   (cond ((equal v (car setup-tracker--parents))
;;          nil)
;;         ((equal v (cadr setup-tracker--parents))
;;          (setq setup-tracker--level (1- setup-tracker--level))
;;          (let* ((now (current-time))
;;                 (start (pop setup-tracker--times))
;;                 (elapsed (+ (* (- (nth 1 now) (nth 1 start)) 1000)
;;                             (/ (- (nth 2 now) (nth 2 start)) 1000))))
;;            (with-current-buffer (get-buffer-create "*setup-tracker*")
;;              (save-excursion
;;                (goto-char (point-min))
;;                (dotimes (_ setup-tracker--level) (insert "> "))
;;                (insert
;;                 (file-name-nondirectory (pop setup-tracker--parents))
;;                 " (" (number-to-string elapsed) " msec)\n")))))
;;         (t
;;          (push v setup-tracker--parents)
;;          (push (current-time) setup-tracker--times)
;;          (setq setup-tracker--level (1+ setup-tracker--level))))))

(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; use-package
(setq use-package-enable-imenu-support t)
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; update seq
(defun +elpaca-unload-seq (e) "Unload seq before continuing the elpaca build, then continue to build the recipe E."
  (and (featurep 'seq) (unload-feature 'seq t))
  (elpaca--continue-build e))
(elpaca `(seq :build ,(append (butlast (if (file-exists-p (expand-file-name "seq" elpaca-builds-directory))
                                           elpaca--pre-built-steps
                                         elpaca-build-steps))
                              (list '+elpaca-unload-seq 'elpaca--activate-package))))

(elpaca-wait)

(use-package emacs
  :ensure nil
  :config
  (setq completion-cycle-threshold 3)
  (setq scroll-step 1)
  (setq use-short-answers t)
  (setq native-comp-async-report-warnings-errors nil)
  (setq inhibit-x-resources t)
  (setq inhibit-startup-buffer-menu t)
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (when (file-exists-p (expand-file-name custom-file))
    (load-file (expand-file-name custom-file)))
  (when (file-exists-p "~/.emacs.d/agenda-files.el")
    (load "~/.emacs.d/agenda-files.el"))
  ;; indent
  (setq tab-always-indent 'complete)
  (electric-indent-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  (xterm-mouse-mode 1)
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

(use-package save-sexp :ensure (:host github :repo "emacsattic/save-sexp") :defer t)

(use-package tramp
  :ensure nil
  :defer t
  :custom
  (tramp-default-method "scpx")
  :config
  ;; for nixos machines
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin"))

;; UI
(use-package apropospriate-theme
  :ensure t
  :disabled
  :config
  (load-theme 'apropospriate-light t)
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline line :box nil)
    (set-face-attribute 'mode-line-inactive nil :overline line :underline line :box nil)))

(use-package catppuccin-theme
  :ensure t
  :disabled
  :config
  (setq catppuccin-flavor 'latte)
  (load-theme 'catppuccin t)
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline line :underline line :box nil)
    (set-face-attribute 'mode-line-inactive nil :overline line :underline line :box nil)))

(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-light-medium t))

(use-package nyan-mode
  :ensure t
  :custom
  (nyan-animate-nyancat t)
  (nyan-wavy-trail t)
  :config
  (nyan-mode 1))

(use-package moody
  :ensure t
  :config
  (setq x-underline-at-descent-line t)
  (column-number-mode 0)
  (line-number-mode 0)
  (moody-replace-mode-line-front-space)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function)
  (when (eq system-type 'darwin)
    (setq moody-slant-function 'moody-slant-apple-rgb))
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line          nil :overline line :box nil)
    (set-face-attribute 'mode-line-inactive nil :overline line :underline line :box nil)))

(use-package minions
  :ensure t
  :config
  (minions-mode)
  (setq minions-mode-line-lighter "[+]"))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-items '((recents . 15)
                     (bookmarks . 5)
                     (agenda . 5)))
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-headings-icons t)
  (dashboard-set-file-icons t)
  :hook
  (elpaca-after-init . dashboard-insert-startupify-lists)
  (elpaca-after-init . dashboard-initialize)
  :config
  (dashboard-setup-startup-hook))

(use-package nerd-icons
  :ensure t
  :defer t
  :config
  (ignore-errors (nerd-icons-set-font)))

(use-package nerd-icons-completion
  :ensure t
  :defer t
  :config
  (nerd-icons-completion-mode)
  :hook
  (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package highlight-indent-guides
  :ensure t
  :defer t
  :custom
  (highlight-indent-guides-method 'bitmap)
  (highlight-indent-guides-character 124)
  (highlight-indent-guides-responsive 'top)
  :hook
  (prog-mode . highlight-indent-guides-mode))

(use-package aggressive-indent
  :ensure t
  :defer t
  :hook
  (emacs-lisp-mode . aggressive-indent-mode))

(use-package rainbow-delimiters
  :ensure t
  :defer t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package pulsar
  :ensure t
  :config
  (pulsar-global-mode t))

(use-package uniquify
  :ensure nil
  :custom
  (uniquify-buffer-name-style 'post-forward-angle-brackets))

(use-package undo-fu
  :defer t
  :ensure t)

(use-package vundo
  :defer t
  :ensure t
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))

(use-package origami
  :ensure (:host github :repo "elp-revive/origami.el")
  :defer t
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
  
(use-package expreg :ensure t :defer t)

(use-package meow
  :ensure t
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
  (meow-setup-indicator)
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
   
   '("," . meow-beginning-of-thing)
   '("." . meow-end-of-thing)
   '("<" . meow-inner-of-thing)
   '(">" . meow-bounds-of-thing)

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
   '("[" . indent-rigidly-left-to-tab-stop)
   '("]" . indent-rigidly-right-to-tab-stop)

   ;; command
   '("z" . origami-hydra/body)
   '(";" . main-hydra/body)
   '("m" . major-mode-hydra)
   '("n" . vertico-repeat)
   ;; ignore escape
   '("<escape>" . ignore))
  (meow-global-mode +1))

(use-package which-key
  :ensure t
  :hook (elpaca-after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.7)
  (which-key-show-early-on-C-h t))

(use-package hydra
  :ensure t)

(use-package major-mode-hydra
  :ensure t
  :config
  (pretty-hydra-define main-hydra (:separator "=" :title "Main" :foreign-keys warn :quit-key "q" :exit t)
    ("File"
     (("f" find-file "Find file")
      ("d" find-dired "Find directory")
      ("b" consult-buffer "Buffer")
      ("r" find-recentf "Recent")
      ("s" save-buffer "Save file"))
     "Edit"
     (("e" align-regexp "Align regexp")
      ("z" origami-hydra/body "Origami")
      ("u" vundo "Visual Undo"))
     "Code"
     (("l" eglot-hydra/body "LSP")
      ("v" avy-goto-word-1 "Avy Word")
      ("V" avy-hydra/body "More avy"))
     "View"
     (("D" delete-other-windows "Only this win")
      ("w" ace-window "Window select")
      ("W" window-hydra/body "Window control"))
     "Tool"
     (("j" org-hydra/body "Org")
      ("n" org-capture "Org-capture")
      ("a" org-agenda "Agenda")
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
  :ensure (:host github :repo "Ladicle/hydra-posframe")
  :after (hydra)
  :hook (elpaca-after-init . hydra-posframe-mode)
  :custom-face
  (hydra-posframe-face ((t :inherit solaire-default-face)))
  :custom
  (hydra-posframe-parameters '((left-fringe . 5)
                               (right-fringe . 5)))
  (hydra-posframe-poshandler #'posframe-poshandler-frame-bottom-right-corner))

;; ace/avy
(use-package ace-window
  :ensure t
  :defer t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c")))))

(use-package avy
  :ensure t
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
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

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
  :ensure (:host github :repo "jdtsmith/vertico-truncate")
  :config
  (vertico-truncate-mode t))

(use-package savehist
  :ensure nil 
  :after (vertico)
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :after (vertico)
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package embark
  :ensure t
  :defer 2
  :bind
  (("C-." . embark-act)
   ("M-." . embark-dwim)
   ("C-h B" . embark-bindings))
  :init
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package consult
  :ensure t
  :defer t
  :custom
  (consult-preview-key 'any))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
  
;; code-completion
(use-package corfu
  :ensure t
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
  (global-corfu-mode))

(use-package corfu-popupinfo
  :ensure nil
  :hook (corfu-mode . corfu-popupinfo-mode))

(use-package corfu-terminal
  :ensure t
  :if (not (display-graphic-p))
  :after corfu
  :config
  (corfu-terminal-mode +1))

(use-package cape
  :ensure t
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; skk
(use-package ddskk
  :ensure t
  :bind ("C-x j" . skk-mode)
  :defer t
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
  (setq skk-status-indicator 'left)
  (setq skk-show-annotation t)
  (setq skk-show-icon t)
  (setq skk-show-mode-show t)
  (setq skk-preload t)
  (setq skk-dcomp-activate t)
  (setq skk-dcomp-multiple-activate t)
  :hook
  (find-file . (lambda nil (skk-latin-mode 1)))
  :config
  (use-package ddskk-posframe
    :ensure t
    :config
    (ddskk-posframe-mode t)))

;; org
(use-package org
  :ensure nil
  :defer t
  :custom
  (org-return-follows-link t)
  (org-mouse-1-follows-link t)
  (org-directory "~/Org")
  :init
  (with-eval-after-load 'pretty-hydra
    (pretty-hydra-define org-hydra
      (:title "Org" :separator "=" :quit-key "q" :foreign-keys warn :exit t)
      ("Notes"
       (("a" org-agenda "Agenda")
        ("n" org-capture "Note")
        ("c" calendar "Calendar"))
       "Journal"
       (("j" org-journal-new-entry "New Entry")
        ("t" (org-journal-new-entry '(4)) "Today"))
       "Roam"
       (("f" org-roam-node-find "Find Node")
        ("i" org-roam-node-insert "Insert Node")
        ("g" org-roam-graph-show "Show Graph")
        ("b" org-roam-buffer-toggle "Roam Buffer" :toggle t)))))
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
        ("c" org-toggle-checkbox "Check"))
       "Roam"
       (("f" consult-org-roam-file-find "Find")
        ("i" org-roam-node-insert "Insert")
        ("g" org-roam-graph-show "Show Graph")
        ("b" org-roam-buffer-toggle "Roam Buffer" :toggle t :exit nil)
        ("!" org-id-get-create "Get ID")
        ("@" org-roam-db-sync "Sync")))))
  :config
  (defvar org-export-directory "~/Org/export")

  (defun org-export-output-file-name--set-directory (orig-fn extension &optional subtreep pub-dir)
    (setq pub-dir (or pub-dir org-export-directory))
    (funcall orig-fn extension subtreep pub-dir))
  (advice-add 'org-export-output-file-name :around 'org-export-output-file-name--set-directory))

(use-package org-agenda
  :ensure nil
  :defer t
  :custom
  (org-agenda-span 'day)
  (org-log-done 'time)
  :config
  (require 'org-roam))

(use-package ox-latex
  :ensure nil
  :after org
  :config
  (require 'ox-latex)
  (setq org-latex-pdf-process '("latexmk -f -output-directory=%o -pdfdvi -gg %f"))
  (setq org-export-in-background t)
  (setq org-file-apps '(("pdf" . "zathura %s")))
  (setq org-latex-default-class "jlreq")
  (setq org-latex-compiler "")
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
  :ensure t
  :after org
  :defer t
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :custom
  (org-hide-emphasis-markers t))

(use-package org-roam
  :ensure t
  :after org
  :defer t
  :custom
  (org-roam-db-location "~/.emacs.d/org-roam.db")
  (org-roam-directory "~/Org/roam")
  (org-roam-index-file "~/Org/roam/index.org")
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
  (org-roam-db-autosync-mode t))

(use-package vulpea
  :ensure t
  :defer t
  :hook (org-roam-db-autosync-mode . vulpea-db-autosync-enable))

(use-package consult-org-roam
  :ensure t
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
  :ensure t
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
  :ensure t
  :defer t
  :after calendar
  :config
  (setq calendar-holidays
        (append japanese-holidays holiday-local-holidays holiday-other-holidays))
  (setq calendar-mark-holidays-flag t))

;; lsp
(use-package eglot
  :ensure nil
  :defer t
  :custom
  (eglot-autoshutdown t)
  (eglot-ignored-server-capabilities '(:documentHighlightProvider
                                       :documentOnTypeFormattingProvider))
  (eglot-events-buffer-size 0)
  (eglot-sync-connect nil)
  :hook
  (eglot-managed-mode . my/eglot-capf)
  ((c-mode c++-mode rustic-mode) . eglot-ensure)
  :config
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (list (cape-super-capf
                       #'eglot-completion-at-point
                       ;;#'tempel-expand
                       #'cape-file))))
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(rustic-mode . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '(tex-mode . ("texlab")))
  (setq completion-category-overrides '((eglot (styles orderless basic))))
  (fset #'jsonrpc--log-event #'ignore)
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

(use-package eldoc-box
  :ensure t
  :defer t
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(use-package consult-eglot
  :ensure t
  :defer t
  :after eglot)

;; git
(use-package magit
  :ensure t
  :defer t)

(use-package transient
  :ensure t
  :defer t)

(use-package git-auto-commit-mode
  :ensure t
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

;; flymake
(use-package flymake
  :ensure nil
  :defer t
  :hook (eglot-managed-mode . flymake-mode)
  :bind (nil
         :map flymake-mode-map
         ("C-c n" . flymake-goto-next-error)
         ("C-c p" . flymake-goto-prev-error)))

(use-package flymake-diagnostic-at-point
  :ensure t
  :defer t
  :after flymake
  :hook
  (flymake-mode . flymake-diagnostic-at-point-mode)
  :config
  (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))
  
;; treesitter
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  (treesit-font-lock-level 4)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Rust
(use-package rustic
  :ensure t
  :defer t
  :custom
  (rustic-lsp-client 'eglot)
  :mode ("\\.rs\\'" . rustic-mode))

;; Nix
(use-package nix-mode
  :ensure t
  :defer t
  :mode "\\.nix\\'")

(elpaca-process-queues)

;; Enable magic file name and GC
(setq file-name-handler-alist my-saved-file-name-handler-alist)
(setq gc-cons-percentage 0.2)
(setq gc-cons-threshold 40000000)
(add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages t)

;;(profiler-report)
;;(profiler-stop)

(provide 'init)
