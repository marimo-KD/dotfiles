;; -*- lexical-binding: t -*-

(with-eval-after-load 'scroll-bar
  (scroll-bar-mode -1))
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(setq frame-inhibit-implied-resize t)
(add-to-list 'default-frame-alist '(font . "UDEV Gothic 35JPDOC-12"))

(setq make-backup-files nil)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/backup/" t)))
(setq auto-save-timeout 10)
(setq auto-save-interval 100)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)

(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-buffer-menu t)
(setq inhibit-startup-screen t)

(setq read-process-output-max (* 8 1024 1024))

(setq gc-cons-threshold (* 128 1024 1024))
(setq garbage-collection-messages nil)

(advice-add 'x-apply-session-resources :override 'ignore)

(setq custom-file "~/.emacs.d/custom.el")

(setq package-enable-at-startup nil)

(provide 'early-init)
