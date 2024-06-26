(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(setq inhibit-startup-message t)

;; Stop GC
(setq gc-cons-threshold most-positive-fixnum)

(setq make-backup-files nil)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/backup/" t)))
(setq auto-save-timeout 10)
(setq auto-save-interval 100)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)

(setq inhibit-x-resources t)
(setq inhibit-startup-buffer-menu t)
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p (expand-file-name custom-file))
  (load-file (expand-file-name custom-file)))
