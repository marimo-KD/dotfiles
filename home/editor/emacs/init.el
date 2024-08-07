;;; -*- lexical-binding: t -*-

(eval-when-compile
  (require 'cl-lib)
  (require 'setup)
  (setq setup-silent t
        ;; setup-use-profiler t
        ;; setup-use-load-history-tracker t
        setup-delay-interval 0.5
        setup-disable-magic-file-name t)
  (defmacro setup--checkenv ()))
(setup-initialize)

;(defmacro ensure (pkg)
;  (unless (package-installed-p pkg)
;    `(package-install ,pkg)))
;(defmacro ensure-vc (arg)
;  (unless (package-installed-p (car arg))
;    `(package-vc-install ,arg)))
(defmacro ensure (pkg) `())
(defmacro ensure-vc (pkg) `())

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

(!-
 (setup "server"
  (unless (server-running-p)
    (server-start))))

(setup-lazy '(whitespace-mode) "whitespace"
  :prepare (setup-hook 'find-file-hook 'whitespace-mode)
  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           empty
                           space-mark
                           tab-mark)
        whitespace-display-mappings '((space-mark ?\u3000 [?\u25a1])
                                      (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t]))
        whitespace-space-regexp "\\(\u3000+\\)"
        whitespace-trailing-regexp "\\([ \u00A0]+\\)$"
        whitespace-action '(auto-cleanup)))

(!-
 (setup "autorevert"
   (setq auto-revert-avoid-polling t)
   (global-auto-revert-mode 1)))

(setup-lazy '(subword-mode) "subword"
  :prepare (setup-hook 'prog-mode-hook #'subword-mode))

(setup-after "tramp"
  (setq tramp-default-method "scpx")
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin")
  (add-to-list 'tramp-remote-path "/run/wrappers/bin"))

(setup-after "comp"
  (setq native-comp-async-report-warnings-errors 'silent))

(!-
  (set-fontset-font
    "fontset-startup"
    'unicode
    "UDEV Gothic 35JPDOC-12"
    nil
    'append))

(ensure 'ef-themes)
(setup "ef-themes"
  (setq ef-themes-mixed-fonts nil
        ef-themes-variable-pitch-ui nil)
  (load-theme 'ef-melissa-light t))

(ensure 'nano-modeline)
(setup "nano-modeline"
  (setq nano-modeline-padding '(0.25 . 0.3))
  (setq-default mode-line-format nil)
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

(ensure 'nerd-icons)
(setup-after "nerd-icons"
  (ignore-errors (nerd-icons-set-font)))

(ensure 'nerd-icons-completion)
(setup-after "marginalia"
  (setup "nerd-icons-completion"
    (nerd-icons-completion-mode)
    (setup-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup)))

(!-
 (setup "pixel-scroll"
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil
        mouse-wheel-follow-mouse t
        pixel-scroll-precision-large-scroll-height 40.0
        scroll-step 1)
  (pixel-scroll-precision-mode 1)))

(ensure 'rainbow-delimiters)
(setup-lazy '(rainbow-delimiters-mode) "rainbow-delimiters")
(setup-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(ensure 'lin)
;(!-
; (setup "lin"
;   (setq lin-face 'lin-blue)
;   (lin-global-mode)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

(ensure 'highlight-indent-guides)
(setup-lazy '(highlight-indent-guides-mode) "highlight-indent-guides"
  :prepare
  (progn
    (setup-hook 'prog-mode-hook 'highlight-indent-guides-mode)
    (setup-hook 'yaml-mode-hook 'highlight-indent-guides-mode))
  (setq highlight-indent-guides-method 'bitmap
        highlight-indent-guides-character 124
        highlight-indent-guides-responsive 'top))

(ensure 'aggressive-indent)
(setup-lazy '(aggressive-indent-mode) "aggressive-indent"
  :prepare (setup-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode))

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

(setup-after "vertico"
  (setup-lazy '(vertico-directory-delete-char
                vertico-directory-enter
                vertico-directory-delete-word)
    "vertico-directory"
    :prepare
    (setup-keybinds vertico-map
      "<backspace>" 'vertico-directory-delete-char)))

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
     (defvar corfu-terminal-mode nil)
     (setup "corfu-terminal"
       (corfu-terminal-mode 1)))

   (setup "corfu-popupinfo"
     (setup-hook 'corfu-mode-hook #'corfu-popupinfo-mode))

   (setup "nerd-icons-corfu"
     (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

   (setup "cape"
     (setup "cape-keyword"
       (setq-default completion-at-point-functions
                     '(cape-dabbrev
                       cape-file
                       cape-keyword))))

   (global-corfu-mode 1)

   (keymap-unset corfu-map "<remap> <next-line>")
   (keymap-unset corfu-map "<remap> <previous-line>")
   (setup-keybinds corfu-map
     "<tab>" 'corfu-next
     "<backtab>" 'corfu-previous)))

(ensure 'tempel)
(setup-lazy '(tempel-complete
              tempel-expand
              tempel-setup-capf)
  "tempel"
  :prepare
  (progn
    (setup-in-idle "tempel")
    (defun tempel-setup-capf ()
      (when (or (derived-mode-p 'conf-mode)
                (derived-mode-p 'prog-mode)
                (derived-mode-p 'text-mode))
        (setq-local completion-at-point-functions
                    (cons #'tempel-complete
                          completion-at-point-functions))))
    (add-hook 'after-change-major-mode-hook #'tempel-setup-capf 90)
    )
  (setup-after "eglot"
    (setup "eglot-tempel"))
  )

(ensure 'eglot-tempel)
(setup-after "eglot-tempel"
  (eglot-tempel-mode))

(ensure 'undo-fu)
(ensure 'vundo)
(setup-lazy '(undo-fu-only-undo
              undo-fu-only-redo) "undo-fu")
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

  (defun meow-surround-delete ()
    (interactive)
    (let* ((ch (meow-thing-prompt "Delete thing: "))
           (inner (meow--parse-inner-of-thing-char ch))
           (outer (meow--parse-bounds-of-thing-char ch)))
      (delete-region (cdr inner) (cdr outer))
      (kill-region (car inner) (cdr inner))
      (delete-region (car outer) (car inner))))

  (defun meow-surround-squeeze ()
    (interactive)
    (let* ((ch (meow-thing-prompt "Delete thing: "))
           (inner (meow--parse-inner-of-thing-char ch))
           (outer (meow--parse-bounds-of-thing-char ch)))
      (delete-region (cdr inner) (cdr outer))

      (delete-region (car outer) (car inner))))

  (make-variable-buffer-local 'meow-char-thing-table)
  (setq-default meow-char-thing-table
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
                (cons '(?o . org-md-block)
                      meow-char-thing-table)))
  (setup-hook 'markdown-mode-hook
    (setq-local meow-char-thing-table
                (cons '(?o . org-md-block)
                      meow-char-thing-table)))
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
(setup-after "treesit"
  (setup "meow-tree-sitter"
    (meow-tree-sitter-register-defaults)))

(ensure 'which-key)
(!-
 (setup "which-key"
   (setq which-key-idle-delay 0.5
         which-key-show-early-on-C-h t)))

(ensure 'hydra)
(ensure 'major-mode-hydra)
(ensure-vc '(hydra-posframe :url "https://github.com/Ladicle/hydra-posframe"))
(setup-lazy '(major-mode-hydra
              main-hydra/body
              avy-hydra/body
              org-hydra/body)
  "hydra"
  (setup "major-mode-hydra")
  (defun my/ace-window-always-dispatch ()
    (interactive)
    (let ((aw-dispatch-always t))
      (call-interactively 'ace-window)))
  (pretty-hydra-define main-hydra
    (:separator "=" :title "Main" :foreign-keys warn :quit-key "q" :exit t)
    ("File"
     (("f" find-file "Find file")
      ("r" recentf "Recent")
      ("s" save-buffer "Save"))
     "Window"
     (("b" consult-buffer "Buffer")
      ("d" delete-other-windows "Only")
      ("w" my/ace-window-always-dispatch "Ace Window"))
     "Org"
     (("o" org-hydra/body "Org")
      ("a" my/org-agenda "Agenda")
      ("n" org-roam-node-find "Roam node"))
     "Tool"
     (("u" vundo "Undo Tree")
      ("v" vterm "Terminal")
      ("m" major-mode-hydra "Major Hydra"))))
  (setup-expecting "avy"
    (pretty-hydra-define avy-hydra
      (:separator "-" :title "Avy" :foreign-keys warn :quit-key "q" :exit t)
      ("Char"
       (("c" avy-goto-char "Char")
        ("C" avy-goto-char-2 "Char 2")
        ("t" avy-goto-char-timer "Timer"))
       "Word"
       (("w" avy-goto-word-0 "Word")
        ("W" avy-goto-word-1 "Word 1"))
       "Line"
       (("l" avy-goto-line "Line")))))
  (setup-expecting "org"
    (pretty-hydra-define org-hydra
      (:separator "-" :title "Org" :foreign-keys warn :quit-key "q" :exit t)
      ("Babel"
       (("t" org-babel-tangle "Tangle")
        ("e" org-babel-execute-src-block "Execute"))
       "Roam"
       (("n" org-roam-node-find "Find Node")
        ("i" org-roam-node-insert "Insert Node")
        ("t" org-roam-tag-add "Add tag")))))
  )

(ensure 'avy)
(setup-lazy '(avy-goto-char
              avy-goto-char-2
              avy-goto-char-timer
              avy-goto-word-1
              avy-goto-word-0
              avy-goto-line
              avy-resume) "avy")

(ensure 'ace-window)
(setup-lazy '(ace-window) "ace-window"
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(ensure 'ddskk)
(ensure 'ddskk-posframe)


(!-
 (setup "ddskk-autoloads"
  (setup-keybinds nil "C-x C-j" 'skk-mode)
  (setq default-input-method "japanese-skk")))

(setup-after "skk"
  (setq skk-preload t)
  (setup "ddskk-posframe"
    (setup-hook 'skk-mode-hook 'ddskk-posframe-mode))
  ;; disable system im
  (when (equal window-system 'pgtk)
    (setq pgtk-use-im-context-on-new-connection nil)
    (pgtk-use-im-context nil))
  (when (equal window-system 'mac)
    (add-hook 'focus-in-hook
              #'(lambda ()
                  (when (fboundp 'mac-auto-ascii-setup-input-source)
                    (mac-auto-ascii-setup-input-source))))))

(setup-after "skk-vars"
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
          ("[" nil ("「" . "「")))))

(setup-after "org"
  (setq org-return-follows-link t
        org-mouse-1-follows-link t
        org-directory "~/Org"
        org-preview-latex-default-process 'dvisvgm
        org-preview-latex-image-directory
        (file-name-concat org-directory "resources/ltximg")
        org-format-latex-header
        "
\\documentclass{article}
\\usepackage[usenames]{color}
[DEFAULT-PACKAGES]
[PACKAGES]
% --- edit ---
\\usepackage{physics2}
\\usepackage{diffcoeff}
\\usephysicsmodule{ab, ab.braket}
% vector analysis
\\DeclareMathOperator{\\grad}{\\nabla}
\\DeclareMathOperator{\\divergence}{\\nabla\\cdot}
\\let\\divisionsymbol\\div
\\renewcommand{\\div}{\\divergence}
\\DeclareMathOperator{\\rot}{\\nabla\\times}
%
\\renewcommand{\\Re}{\\operatorname{Re}}
\\renewcommand{\\Im}{\\operatorname{Im}}
\\newcommand{\\Tr}{\\operatorname{Tr}}
\\newcommand{\\rank}{\\operatorname{rank}}
% --- end ---
\\pagestyle{empty}             % do not remove
% The settings below are copied from fullpage.sty
\\setlength{\\textwidth}{\\paperwidth}
\\addtolength{\\textwidth}{-3cm}
\\setlength{\\oddsidemargin}{1.5cm}
\\addtolength{\\oddsidemargin}{-2.54cm}
\\setlength{\\evensidemargin}{\\oddsidemargin}
\\setlength{\\textheight}{\\paperheight}
\\addtolength{\\textheight}{-\\headheight}
\\addtolength{\\textheight}{-\\headsep}
\\addtolength{\\textheight}{-\\footskip}
\\addtolength{\\textheight}{-3cm}
\\setlength{\\topmargin}{1.5cm}
\\addtolength{\\topmargin}{-2.54cm}"
        org-id-method 'ts
        org-todo-keywords
        '((sequence "TODO(t)" "INPROGRESS(p!)" "WAIT(w)" "SOMEDAY(s)"
                    "|" "DONE(d!)" "CANCELED(c)")))
  )

(setup-after "org-src"
  (setq org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-src-preserve-indentation t
        org-edit-src-content-indentation 0))

(setup-after "org"
  (setup "ob"))
(setup-after "ob"
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
      (ocaml . ocaml)
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
                                         &optional arg info params executor-type)
    (my-org-require-lang (nth 0 info))
    (funcall original-fun arg info params executor-type))
  
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
    (apply original-fun args))
  ;; to be used with header arguments :tangle yes :comments yes :noweb yes
  
  (setq org-babel-tangle-comment-format-beg
        "%% [[%link][%source-name]]")
  
  (defun gm/org-babel-get-block-header (&optional property)
    "Returns alist of header properties of this block or specific PROPERTY.
     Eg., use with PROPERTY :results or :session."
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
    (org-babel-tangle-jump-to-org))
  (defun my/org-babel-temp-stable-file-fixed (data prefix &optional suffix)
    "Fixed version of org-babel-temp-stable-file.
     Original function uses sxhash, but
     sxhash see only head 7 elements of list.
     This behavior is not appropriate for file name."
    (let ((path (format "%s%s%s%s"
                        (file-name-as-directory (org-babel-temp-stable-directory))
                        prefix
                        (secure-hash 'md5 (format "%s" data))
                        ;; use md5 instead of sxhash
                        ;; this function will not be called frequently,
                        ;; so hash performance doesn't matter.
                        (or suffix ""))))
      (with-temp-file path)
      path))
  (advice-add 'org-babel-temp-stable-file :override #'my/org-babel-temp-stable-file-fixed)
  )

(ensure 'org-nix-shell)
(setup-lazy '(org-nix-shell-mode) "org-nix-shell"
  :prepare (setup-hook 'org-mode-hook 'org-nix-shell-mode))

(setup-after "ox"
  (defvar org-export-directory "~/Org/export")
  (defun org-export-output-file-name--set-directory
      (orig-fn extension &optional subtreep pub-dir)
    (setq pub-dir (or pub-dir org-export-directory))
    (funcall orig-fn extension subtreep pub-dir))
  (advice-add 'org-export-output-file-name
              :around 'org-export-output-file-name--set-directory))

(setup-after "ox-latex"
  (setq org-latex-pdf-process '("latexmk -f -pdfdvi -gg -output-directory=%o %f"))
  (setq org-export-in-background t)
  (setq org-file-apps '(("pdf" . emacs)))
  (setq org-latex-default-class "jlreq")
  (add-to-list 'org-latex-classes
               '("jlreq"
                 "
\\documentclass[11pt,paper=a4]{jlreq}
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
\\fi
[PACKAGES]"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(ensure 'org-roam)
(setup-after "org-roam"
  (setq org-roam-db-location "~/.emacs.d/org-roam.db"
        org-roam-directory "~/Org/roam"
        org-roam-index-file "~/Org/roam/index.org"
        org-roam-completion-functions '()
        org-roam-verbose nil
        org-roam-node-display-template
          (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag))
        org-roam-capture-templates
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
  (org-roam-db-autosync-mode t))

(ensure 'vulpea)
(setup-lazy '(vulpea-db-autosync-enable) "vulpea"
  :prepare (setup-hook 'org-roam-db-autosync-mode-hook 'vulpea-db-autosync-mode))

(setup-lazy '(vulpea-agenda-files-update) "vulpea"
  (setup "vulpea-buffer")
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
  (add-to-list 'org-tags-exclude-from-inheritance "task")
  (defun org-roam-tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'org-roam-tag-new-node-as-draft))

(ensure 'org-superstar)
(setup-lazy '(org-superstar-mode)
  "org-superstar"
  :prepare (setup-hook 'org-mode-hook 'org-superstar-mode))

(setup-after "org-agenda"
  (setq org-agenda-span 'week
        org-log-done 'time)
  (setup-after "org"
    (advice-add 'org-agenda :before #'vulpea-agenda-files-update)))

(ensure 'org-ql)
(setup-lazy '(org-ql-view) "org-ql-view")
(setup-lazy '(org-ql-search) "org-ql-search")
(setup-lazy '(my/org-agenda
              my/org-todo-list)
  "org-ql"
  (defun my/org-agenda ()
    (interactive)
    (org-ql-search (org-agenda-files)
      '(or (and (not (done))
                (or (scheduled :to +7)
                    (deadline auto)))
           (todo "INPROGRESS" "SOMEDAY" "WAIT")
           (habit))
      :title "Agenda for this week"
      :sort '(todo date priority)
      :super-groups '((:name "Overdue"
                             :deadline past)
                      (:name "Today's TODO"
                             :scheduled today
                             :time-grid t)
                      (:name "Habit"
                             :habit t)
                      (:name "In progress"
                             :todo "INPROGRESS")
                      (:name "Deadline is coming"
                             :deadline future)
                      (:name "Schedule for this week"
                             :scheduled future)
                      (:todo ("WAIT" "SOMEDAY")))))
  (defun my/org-todo-list ()
    (interactive)
    (org-ql-search (org-agenda-files)
      '(and (not (done))
            (todo))
      :title "Todo List"
      :sort '(todo date)
      :super-groups '((:name "Overdue"
                             :deadline past))))
  (with-eval-after-load 'org-roam
    (advice-add 'my/org-agenda :before #'vulpea-agenda-files-update)
    (advice-add 'my/org-todo-list :before #'vulpea-agenda-files-update)))

(setup-after "org-attach"
  (setq org-attach-id-dir "~/Org/resources"
        org-attach-id-to-path-function-list
        '(org-attach-id-ts-folder-format
          org-attach-id-uuid-folder-format)))

(setup-after "org"
  (setup "org-noter"))
(setup-after "org-noter"
  (setq org-noter-notes-window-location 'horizontal-split
        org-noter-always-create-frame nil)
  (org-noter-enable-org-roam-integration))

(ensure 'citar)
(setup-after "oc"
  (setq org-cite-global-bibliography '("~/Zotero/reference.bib")
        org-cite-insert-processor 'citar
        org-cite-follow-processor 'citar
        org-cite-activate-processor 'citar)
  (setup "citar"))
(setup-lazy '(citar-capf-setup) "citar-capf"
   :prepare
   (progn
     (setup-hook 'LaTeX-mode-hook 'citar-capf-setup)
     (setup-hook 'org-mode-hook 'citar-capf-setup)))
(setup-after "citar"
   (setq citar-bibliography org-cite-global-bibliography
         citar-open-entry-function #'citar-open-entry-in-zotero))

(ensure "japanese-holidays")
(setup-after "calendar"
  (setup "japanese-holidays"
    (setq calendar-holidays
          (append japanese-holidays holiday-local-holidays holiday-other-holidays)
          calendar-mark-holidays-flag t)
    (setq japanese-holiday-weekend '(0 6)
          japanese-holiday-weekend-marker
          '(holiday nil nil nil nil nil japanese-holiday-saturday))
    (setup-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
    (setup-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)))

(setup-after "pdf-tools"
  (setopt pdf-cache-image-limit 15
          image-cache-eviction-delay 15
          pdf-view-resize-factor 1.1))
(setup-after "pdf-annot"
  (setopt pdf-annot-activate-created-annotations t))
(!-
 (setup "pdf-loader"
   (pdf-loader-install)))

(ensure 'eglot)
(setup-lazy '(eglot-ensure) "eglot"
  :prepare (!foreach '(c-ts-mode
                       c++-ts-mode
                       rust-ts-mode
                       tuareg-mode)
             (setup-hook ,it 'eglot-ensure))
  (setq eglot-autoshutdown t
        eglot-ignored-server-capabilities '(:documentHighlightProvider
                                            :documentOnTypeFormattingProvider)
        eglot-events-buffer-size 0
        eglot-sync-connect nil)
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
                (list (cape-capf-super
                       #'tempel-complete
                       #'eglot-completion-at-point
                       #'cape-file))))
  (setup-hook 'eglot-managed-mode-hook 'my/eglot-capf)
  (setup-after "orderless"
    (setq completion-category-overrides '((eglot (styles orderless))
                                          (eglot-capf (styles orderless))))))

(setup-after "jsonrpc"
  (setq jsonrpc-default-request-timeout 3000)
  (fset #'jsonrpc--log-event #'ignore))

(ensure-vc '(eglot-booster :url "https://github.com/jdtsmith/eglot-booster"))
(setup-after "eglot"
  (setup "eglot-booster"
    (eglot-booster-mode)))

(ensure-vc '(eglot-x :url "https://github.com/nemethf/eglot-x"))
(setup-after "eglot"
  (setup "eglot-x"
    (eglot-x-setup)))

(setup-lazy '(flymake-mode) "flymake"
  :prepare (setup-hook 'eglot-managed-mode-hook 'flymake-mode)
  (setup-keybinds flymake-mode-map
    "C-c n" 'flymake-goto-next-error
    "C-c p" 'flymake-goto-prev-error))

(setup-lazy '(vterm) "vterm"
  :prepare (setup-hook 'vterm-mode-hook
             (progn
               (setq-local global-hl-line-mode nil)
               (hl-line-mode -1)))
  (setq vterm-shell "nu --config ~/.config/nushell/emacs-config.nu"
        vterm-timer-delay 0.01))

(ensure-vc '(meow-vterm :url "https://github.com/accelbread/meow-vterm"))
(setup-lazy '(my/meow-vterm-setup) "meow-vterm"
  :prepare (progn
             (setq vterm-keymap-exceptions '("C-c"))
             (setup-hook 'vterm-mode-hook 'my/meow-vterm-setup))
  (defun my/meow-vterm-setup ()
    "Modified meow-vterm-setup for lazy loading"
    (define-key vterm-mode-map (kbd "C-c ESC") #'vterm-send-escape)
    (dolist (c '((yank . vterm-yank)
                 (xterm-paste . vterm-xterm-paste)
                 (yank-pop . vterm-yank-pop)
                 (mouse-yank-primary . vterm-yank-primary)
                 (self-insert-command . vterm--self-insert)
                 (beginning-of-defun . vterm-previous-prompt)
                 (end-of-defun . vterm-next-prompt)))
      (define-key meow-vterm-normal-mode-map (vector 'remap (car c)) (cdr c)))
    (meow-vterm-setup)))

(setup-after "dired"
  (setopt dired-mouse-drag-files t
          mouse-drag-and-drop-region-cross-program t
          dired-listing-switches "-alh"))

(ensure 'diredfl)
(setup-lazy '(diredfl-mode) "diredfl"
  :prepare (setup-hook 'dired-mode-hook 'diredfl-mode))

(ensure 'nerd-icons-dired)
(setup-lazy '(nerd-icons-dired-mode) "nerd-icons-dired"
  :prepare (setup-hook 'dired-mode-hook 'nerd-icons-dired-mode))

(ensure 'dired-subtree)
(setup-after "dired"
  (setup "dired-subtree"
    (setup-keybinds dired-mode-map
      "i" 'dired-subtree-insert
      ";" 'dired-subtree-remove)))

(ensure 'dired-collapse)
(setup-lazy '(dired-collapse-mode)
  "dired-collapse"
  :prepare (setup-hook 'dired-mode-hook 'dired-collapse-mode))

(ensure 'dired-preview)
(setup-lazy '(dired-preview-mode) "dired-preview"
  :prepare (setup-hook 'dired-mode-hook 'dired-preview-mode))

(ensure 'magit)

(ensure 'git-auto-commit-mode)
(setup-after "git-auto-commit-mode"
  (setq gac-automatically-add-new-files-p t)
  (defun gac-pull-before-push (&rest _args)
    (let ((current-file (buffer-file-name)))
      (shell-command "git pull")
      (when current-file
        (with-current-buffer (find-buffer-visiting current-file)
          (revert-buffer t t t)))))
  (advice-add 'gac-push :before #'gac-pull-before-push))

(setup-after "treesit"
  (setq treesit-font-lock-level 4))
(dolist (lang '((bash-mode bash-ts-mode)
                (c-mode c-ts-mode)
                (c++-mode c++-ts-mode)
                (csharp-mode csharp-ts-mode)
                (cmake-mode cmake-ts-mode)
                (css-mode css-ts-mode)
                (dockerfile-mode dockerfile-ts-mode)
                (python-mode python-ts-mode)))
  (add-to-list 'major-mode-remap-alist lang))

(ensure 'rust-mode)
(setup-lazy '(rust-mode) "rust-mode"
  :prepare (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
  (setq rust-mode-treesitter-derive t))

(ensure 'tuareg)
(setup-lazy '(tuareg-mode
              tuareg-opam-mode) "tuareg"
  :prepare (progn
             (add-to-list 'auto-mode-alist '("[./]opam_?\\'" . tuareg-opam-mode))
             (add-to-list 'auto-mode-alist '("\\.ml[ip]?\\'" . tuareg-mode))))

(ensure 'julia-mode)
(ensure 'julia-vterm)
(ensure 'ob-julia-vterm)
(setup-lazy '(julia-vterm-mode) "julia-vterm"
  :prepare (setup-hook 'julia-mode-hook 'julia-vterm-mode))
(setup-after "ob-julia-vterm"
  (defalias 'org-babel-execute:julia 'org-babel-execute:julia-vterm)
  (defalias 'org-babel-variable-assignments:julia
    'org-babel-variable-assignments:julia-vterm))

(ensure 'nushell-mode)
(setup-lazy '(nushell-mode) "nushell-mode"
  :prepare
  (progn
    (add-to-list 'auto-mode-alist '("\\.nu\\'" . nushell-mode))
    (add-to-list 'interpreter-mode-alist '("nu" . nushell-mode))))

(ensure 'nix-mode)
(setup-lazy '(nix-mode) "nix-mode"
  :prepare (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(ensure 'gnuplot-mode)

(ensure-vc '(satysfi-ts-mode :url "https://github.com/Kyure-A/satysfi-ts-mode"))
(setup-lazy '(satysfi-ts-mode) "satysfi-ts-mode"
  :prepare (progn
             (add-to-list 'auto-mode-alist '("\\.saty$" . satysfi-ts-mode))
             (add-to-list 'auto-mode-alist '("\\.satyh$" . satysfi-ts-mode))
             (add-to-list 'auto-mode-alist '("\\.satyg$" . satysfi-ts-mode))))

(ensure 'auctex)
(ensure 'cdlatex)
(setup-lazy '(texmathp) "texmathp")

(provide 'init)
