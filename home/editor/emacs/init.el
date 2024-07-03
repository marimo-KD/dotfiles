;;; -*- lexical-binding: t -*-

(eval-when-compile
  (require 'setup)
  (setq setup-silent t
        setup-delay-interval 0.5
        setup-disable-magic-file-name t))
(setup-initialize)

(eval-and-compile
  (setq package-archives '(("org" . "https://orgmode.org/elpa/")
                          ("melpa" . "https://melpa.org/packages/")
                          ("gnu" . "https://elpa.gnu.org/packages/"))
        package-install-upgrade-built-in t
        package-native-compile t)
  (mapc #'(lambda (add) (add-to-list 'load-path add))
        (eval-when-compile
          (require 'package)
          (package-initialize)
          (let ((package-user-dir-real (file-truename package-user-dir)))
            (nreverse (apply #'nconc
                             (mapcar #'(lambda (path)
                                         (if (string-prefix-p package-user-dir-real path)
                                             (list path)
                                           nil))
                                     load-path)))))))

(eval-when-compile
  (defmacro ensure (pkg)
    (unless (package-installed-p pkg)
      `(package-install ,pkg)))
  (defmacro ensure-vc (arg)
    (unless (package-installed-p (car arg))
      `(package-install ,arg))))

(setq process-adaptive-read-buffering t)
(setq blink-matching-paren nil)
(setq vc-handled-backends '(Git))
(setq auto-mode-case-fold nil)
(setq-default bidi-display-reordering 'left-to-right)
(setq bidi-inhibit-bpa t)
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq idle-update-delay 1.0)
(setq redisplay-skip-fontification-on-input t)
(setq inhibit-compacting-font-caches t)

(setq line-spacing 0.3)

(!when (equal window-system 'mac)
  (setq mac-option-modifier 'meta
        mac-command-modifier 'super)
  (mac-auto-ascii-mode 1))

(setq completion-cycle-threshold 3
      use-short-answers t)

(defun my/set-font (size)
  (let* ((asciifont "UDEV Gothic 35JPDOC")
         (asciipropo "IBM Plex Sans JP")
         (jpfont "UDEV Gothic 35JPDOC")
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
    (my/set-font 12))

(setup "server"
  (unless (server-running-p)
    (server-start)))

(setup "whitespace"
  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           empty
                           space-mark
                           tab-mark)
        whitespace-space-regexp "\\(\u3000+\\)"
        whitespace-trailing-regexp "\\([ \u00A0]+\\)$"
        whitespace-action '(auto-cleanup))
  (global-whitespace-mode 1))

(setup "autorevert"
  (setq auto-revert-avoid-polling t)
  (global-auto-revert-mode 1))

(setup-lazy '(subword-mode) "subword"
  :prepare (setup-hook 'prog-mode-hook #'subword-mode))

(setup-after "tramp"
  (setq tramp-default-method "scpx")
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin")
  (add-to-list 'tramp-remote-path "/run/wrappers/bin"))

(setup-after "comp"
  (setq native-comp-async-report-warnings-errors 'silent))

(ensure 'ef-themes)
(setup "ef-themes"
  (setq ef-themes-mixed-fonts nil
        ef-themes-variable-pitch-ui nil)
  (load-theme 'ef-melissa-light t))

(ensure 'nano-modeline)
(setup "nano-modeline"
  (setq nano-modeline-padding '(0.25 . 0.3)
        mode-line-format nil)
  (setup-after "meow"
    (defun nano-modeline-meow-state ()
      (propertize (meow-indicator)
                  'face (nano-modeline-face 'primary)))
    (defun my/nano-modeline-generic-mode (&optional default)
      "Generic Nano modeline"
      (funcall nano-modeline-position
               '((nano-modeline-meow-state)
                 (nano-modeline-buffer-status) " "
                 (nano-modeline-buffer-name) " "
                 (nano-modeline-git-info))
               '((nano-modeline-cursor-position)
                 (nano-modeline-window-dedicated))
               default))
    (my/nano-modeline-generic-mode t)))

(ensure 'perfect-margin)
(setup "perfect-margin"
  (setq perfect-margin-ignore-filters nil)
  (perfect-margin-mode 1))

(ensure 'nerd-icons)
(setup-after "nerd-icons"
  (ignore-errors (nerd-icons-set-font)))

(ensure 'nerd-icons-completion)
(setup-after "marginalia"
  (setup "nerd-icons-completion"
    (nerd-icons-completion-mode)
    (setup-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)))

(setup "pixel-scroll"
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil
        mouse-wheel-follow-mouse t
        pixel-scroll-precision-large-scroll-height 40.0
        scroll-step 1)
  (pixel-scroll-precision-mode 1))

(ensure 'rainbow-delimiters)
(setup-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(ensure 'lin)
(!-
 (setup "lin"
   (setq lin-face 'lin-blue)
   (lin-global-mode)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(ensure 'highlight-indent-guides)
(setup-lazy '(highlight-indent-guides-mode) "highlight-indent-guides"
  (setq highlight-indent-guides-method 'bitmap
        highlight-indent-guides-character 124
        highlight-indent-guides-responsive 'top))
(setup-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setup-hook 'yaml-mode-hook 'highlight-indent-guides-mode)

(ensure 'aggressive-indent)
(setup-hook 'emacs-lisp-mode 'aggressive-indent-mode)

(setup-hook 'prog-mode-hook 'electric-indent-mode)

(ensure 'vertico)
(ensure 'marginalia)
(setup-lazy '(vertico--advice) "vertico"
  :prepare (progn
             (advice-add 'completing-read-default :around 'vertico--advice)
             (advice-add 'completing-read-multiple :around 'vertico--advice))
  (setq vertico-cycle t)

  (setup "orderless")
  (setup "savehist")
  (setup "marginalia" (marginalia-mode))
  (setup-keybinds vertico-map
    "<backspace>" '("vertico-directory" vertico-directory-delete-char))

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
        (concat "    " cand)))))

(setup-lazy '(vertico-repeat-save) "vertico-repeat"
  :prepare (setup-hook 'minibuffer-setup-hook
             (vertico-repeat-save)))

(ensure 'consult)
(setup-lazy
  '(consult-recent-file
    consult-outline
    consult-line
    consult-buffer
    consult-imenu
    consult-yank-pop)
  "consult"
  (setq consult-preview-key 'any))

(ensure 'embark)
(ensure 'embark-consult)
(setup-lazy
  '(embark-act
    embark-dwim
    embark-bindings)
  "embark"
  :prepare (setup-keybinds nil
             "C-." 'embark-act
             "M-." 'embark-dwim
             "C-h B" 'embark-bindings)
  (setup-after "consult"
    (setup "embark-consult"
      (setup-hook 'embark-collect-mode-hook
        'consult-preview-at-point-mode))))

(ensure 'orderless)
(setup-after "orderless"
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(ensure 'corfu)
(ensure 'corfu-terminal)
(ensure 'cape)
(ensure 'nerd-icons-corfu)
(!-
 (setup "corfu"
   (setup "orderless")
   (setq corfu-auto t
         corfu-auto-prefix 2
         corfu-cycle t
         corfu-preselect 'prompt
         corfu-quit-no-match t
         corfu-quit-at-boundary nil
         corfu-scroll-margin 2
         tab-always-indent 'complete)

   (unless (display-graphic-p)
     (setup "corfu-terminal"
       (corfu-terminal-mode 1)))

   (setup "corfu-popupinfo"
     (setup-hook 'corfu-mode-hook #'corfu-popupinfo-mode))

   (setup "nerd-icons-corfu"
     (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

   (setup "cape"
     (add-to-list 'completion-at-point-functions #'cape-dabbrev)
     (add-to-list 'completion-at-point-functions #'cape-file)
     (add-to-list 'completion-at-point-functions #'cape-keyword))

   (global-corfu-mode 1)

   (setup-keybinds corfu-map
     "<tab>" 'corfu-next
     "<backtab>" 'corfu-prev
     "<remap> <next-line>" nil
     "<remap> <prev-line>" nil)))

(ensure 'tempel)
(setup-lazy '(tempel-complete
              tempel-expand
              tempel-setup-capf)
  "tempel"
  (setup-after "eglot"
    (setup "eglot-tempel"))
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
                (cons #'tempel-complete
                      completion-at-point-functions)))
  (add-hook 'conf-mode-hook #'tempel-setup-capf 90)
  (add-hook 'prog-mode-hook #'tempel-setup-capf 90)
  (add-hook 'org-mode-hook #'tempel-setup-capf 90)
  (add-hook 'text-mode-hook #'tempel-setup-capf 90))

(ensure 'tempel)
(setup-after "eglot-tempel"
  (eglot-tempel-mode))

(ensure 'undo-fu)
(ensure 'vundo)
(setup-after "vundo"
  (setq vundo-glyph-alist vundo-unicode-symbols))

(ensure 'expreg)

(ensure 'meow)
(setup "meow"
  (setq meow-cursor-type-insert '(bar . 3)
        meow-use-cursor-position-hack t
        meow-selection-command-fallback
        '((meow-change . meow-change-char)
          (meow-kill . meow-delete)
          (meow-cancel-selection . keyboard-quit)
          (meow-pop-selection . meow-pop-grab)
          (meow-beacon-change . meow-beacon-change-char)))
  (setq meow-char-thing-table
        '((?\( . round)
          (?\[ . square)
          (?\{ . curly)
          (?\< . angle)
          (?` . backquote)
          (?\' . quote)
          (?\" . wquote)
          (?s . line)
          (?b . buffer)
          (?g . string)
          (?p . paragraph)))
  
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
  (meow-thing-register 'org-md-block
                     '(regexp "^[ \\|\t]*\\(#\\+begin_\\|```\\)[^\n]*\n" "^[ \\|\t]*\\(#\\+end_[^\n]*\\|```\\)$")
                     '(regexp "^[ \\|\t]*\\(#\\+begin_\\|```\\)[^\n]*\n" "^[ \\|\t]*\\(#\\+end_[^\n]*\\|```\\)$")
                     )
  (meow-thing-register 'inline-math
                       '(pair ("\\(") ("\\)"))
                       '(pair ("\\(") ("\\)")))
  (meow-thing-register 'display-math
                       '(pair ("\\[") ("\\]"))
                       '(pair ("\\[") ("\\]")))
  
  
  (setup-hook 'org-mode-hook
    (setq-local meow-char-thing-table
                (cons meow-char-thing-table
                      '(?o . org-md-block))))
  (setup-hook 'markdown-mode-hook
    (setq-local meow-char-thing-table
                (cons meow-char-thing-table
                      '(?o . org-md-block))))
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
  
  (defun meow-surround-squeeze ()
    (interactive)
    (let* ((ch (meow-thing-prompt "Delete thing: "))
           (inner (meow--parse-inner-of-thing-char ch))
           (outer (meow--parse-bounds-of-thing-char ch)))
      (delete-region (cdr inner) (cdr outer))
      (kill-region (car inner) (cdr inner))
      (delete-region (car outer) (car inner))))
  (defun meow-setup ()
    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
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
  
     ;; basic
     '("h" . meow-left)
     '("j" . meow-next)
     '("k" . meow-prev)
     '("l" . meow-right)
  
     '("H" . meow-left-expand)
     '("J" . meow-next-expand)
     '("K" . meow-prev-expand)
     '("L" . meow-right-expand)
  
     '("i" . meow-insert)
     '("I" . meow-open-above)
     '("a" . meow-append)
     '("A" . meow-open-below)
     '("q" . meow-quit)
  
     ;; selection
     '("v" . meow-line)
     '("V" . set-mark-command)
  
     '("o" . expreg-expand)
     '("m" . meow-join)
  
     '("e" . meow-next-word)
     '("E" . meow-next-symbol)
     '("b" . meow-back-word)
     '("B" . meow-back-symbol)
     '("w" . meow-mark-word)
     '("W" . meow-mark-symbol)
  
     '("," . meow-inner-of-thing)
     '("." . meow-bounds-of-thing)
     '("<" . meow-beginning-of-thing)
     '(">" . meow-end-of-thing)
  
     '("g" . meow-grab)
     '("G" . meow-cancel-selection)
  
     '("t" . meow-find)
     '("T" . meow-till)
  
     ;; editing
     '("d" . meow-kill)
     '("c" . meow-change)
     '("v" . meow-yank)
     '("V" . consult-yank-pop)
  
     '("r" . meow-replace)
     '("R" . meow-swap-grab)
  
     '("p" . meow-yank)
     '("P" . consult-yank-pop)
     '("y" . meow-save)
     '("Y" . meow-save-clipboard)
  
     '("u" . undo-fu-only-undo)
     '("U" . undo-fu-only-redo)
  
     '("=" . indent-region)
  
     '("se" . insert-pair-region)
     '("sd" . meow-surround-squeeze)
  
     ;; command
     '("/" . consult-line)
     '(";" . main-hydra/body)
     '("ss" . major-mode-hydra)
     '("n" . vertico-repeat)
     '("f" . avy-goto-word-1)
     '("F" . avy-hydra/body)
     ;; ignore escape
     '("<escape>" . ignore)))
  (meow-setup)
  (meow-global-mode)
  )

(ensure 'meow-tree-sitter)
(setup "meow-tree-sitter"
  (meow-tree-sitter-register-defaults))

(ensure 'which-key)
(!-
 (setup "which-key"
   (setq which-key-idle-delay 0.5
         which-key-show-early-on-C-h t)))

(ensure 'hydra)
(ensure 'major-mode-hydra)

(provide 'init)
