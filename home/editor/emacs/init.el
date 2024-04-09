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
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(elpaca-wait)

(use-package emacs
  :ensure nil
  :config
  (setq completion-cycle-threshold 3)
  (setq scroll-step 1)
  (setq use-short-answers t)
  (setq native-comp-async-report-warnings-errors nil)
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
  ;; font
  (defun my/set-font (size)
    (let* ((asciifont "PlemolJP35 NF")
           (asciipropo "IBM Plex Sans JP")
           (jpfont "PlemolJP35 NF")
           (h (* size 10))
           (fontspec (font-spec :family asciifont))
           (jp-fontspec (font-spec :family jpfont)))
      (set-face-attribute 'default nil :family asciifont :height h)
      (set-face-attribute 'variable-pitch nil :family asciipropo :height h)
      (set-fontset-font t 'japanese-jisx0213.2004-1 jp-fontspec)
      (set-fontset-font t 'japanese-jisx0213-2 jp-fontspec)
      (set-fontset-font t 'katakana-jisx0201 jp-fontspec)
      (set-fontset-font t '(#x0080 . #x024F) fontspec)
      (set-fontset-font t '(#x0370 . #x03FF) fontspec)))
  (if (display-graphic-p)
      (my/set-font 12)))

;; UI
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-solarized-light t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode t))

(use-package nyan-mode
  :ensure t
  :custom
  (nyan-animate-nyancat t)
  (nyan-wavy-trail t)
  :config
  (nyan-mode 1))

(use-package doom-modeline
  :ensure t
  :hook
  (elpaca-after-init . doom-modeline-mode)
  :custom
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-modal-icon t)
  (doom-modeline-modal-modern-icon t)
  :config
  (line-number-mode 0)
  (column-number-mode 0))

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

(use-package nerd-icons :ensure t :defer t)

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
  (meow-insert-exit . (lambda nil
                        (if (and (boundp 'skk-mode) skk-mode) (skk-latin-mode-on))))
  (meow-insert-exit . corfu-quit)
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
      ("g" avy-goto-word-1 "Avy Word")
      ("G" avy-hydra/body "More avy"))
     "View"
     (("D" delete-other-windows "Only this win")
      ("w" ace-window "Window select")
      ("W" window-hydra/body "Window control"))
     "Tool"
     (("j" org-hydra/body "Org")
      ("n" org-capture "Org-capture")
      ("a" consult-org-agenda "Agenda")
      ("m" major-mode-hydra "Major Mode Hydra")
      ("d" dashboard-open "Dashboard"))))
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
  :after (hydra solaire-mode)
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
  :after vertico)

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
  (setq prefix-help-command #'embark-prefix-help-command)
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
  :custom
  (skk-large-jisyo
        "~/SKK/SKK-JISYO.L")
  (skk-jisyo "~/SKK/skk-jisyo")
  (skk-jisyo-code 'utf-8)
  (skk-delete-implies-kakutei nil)
  (skk-henkan-strict-okuri-precedence t)
  (skk-kutouten-type 'jp)
  (skk-use-auto-kutouten t)
  (skk-check-okurigana-on-touroku 'ask)
  (skk-show-annotation t)
  (skk-show-icon t)
  (skk-show-mode-show t)
  (skk-status-indicator 'minor-mode)
  (skk-preload t)
  (skk-show-inline 'vertical)
  (skk-dcomp-activate t)
  (skk-dcomp-multiple-activate t)
  (default-input-method "japanese-skk"))

(use-package ddskk-posframe
  :ensure t
  :after ddskk
  :custom
  (ddskk-posframe-mode t))

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
        ("@" org-roam-db-sync "Sync"))))))

(use-package org-agenda
  :ensure nil
  :defer t
  :custom
  (org-agenda-span 'day)
  (org-log-done 'time)
  (org-agenda-files '("~/Org/todo.org")))
  
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
  (add-to-list 'org-tags-exclude-from-inheritance "task")
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
    (setq org-agenda-files (vulpea-project-files)))

  (add-hook 'find-file-hook #'vulpea-project-update-tag)
  (add-hook 'before-save-hook #'vulpea-project-update-tag)

  (advice-add 'org-agenda :before #'vulpea-agenda-files-update)
  (advice-add 'org-todo-list :before #'vulpea-agenda-files-update)
  (org-roam-mode)
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
(add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages t)

;;(profiler-report)
;;(profiler-stop)

(provide 'init)
