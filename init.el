;; save start time
(defconst start-time (current-time))

;; reduce garbage collections during init
(defconst init-gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold (* 128 1000 1000))
(add-hook 'after-init-hook
          (lambda () (setq gc-cons-threshold init-gc-cons-threshold)))

;;; setup `package'
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; `use-package' is not needed at runtime
(eval-when-compile
  (require 'use-package))

;; required for `use-package' :diminish
;; reduce modeline clutter
(use-package diminish)

;; start `server' if one isn't already running
(use-package server
  :config
  (unless (server-running-p) (server-start)))

;; better emacs defaults
(use-package better-defaults
  :ensure t)

;; undo history as a tree
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)

;; extensible vi layer
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

;; generic completion frontend
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode 1))

;; project interaction library
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode)
  (use-package counsel-projectile
    :ensure t))

;; a git porcelain
(use-package magit
  :ensure t
  :init
  (setq magit-completing-read-function 'ivy-completing-read)
  :commands magit-status
  :config
  (use-package evil-magit
    :ensure t))

;; convenient key definitions
(use-package general
  :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "SPC" '(counsel-M-x :which-key "M-x")

   "f" '(:ignore t :which-key "files")
   "ff" '(counsel-find-file :which-key "find-file")
   "fs" 'save-buffer

   "r" '(:ignore t :which-key "registers")
   "rl" 'ivy-resume
   "ry" 'counsel-yank-pop
   "rm" 'counsel-mark-ring

   "h" '(:ignore t :which-key "help")
   "hi" '(counsel-info-lookup-symbol :which-key "describe-symbol")
   "hf" '(counsel-describe-function :which-key "describe-function")
   "hv" '(counsel-describe-variable :which-key "describe-variable")
   "hk" 'describe-key

   "gs" 'magit-status))

;; print init time
(add-hook 'after-init-hook
          (lambda ()
            (let ((elapsed (float-time (time-subtract (current-time)
                                                      start-time))))
              (message "init finished [%.3fs]" elapsed))))
