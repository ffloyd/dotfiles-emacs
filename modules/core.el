;;; core.el --- My Emacs Config: essential packages
;;; Commentary:
;;; Code:

;;
;; Tweaks
;;

;; Bigger initial frame
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 120))

;; Better macOS look
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; No ring bell
(setq ring-bell-function 'ignore)

;; Alternate splitting behaviour
;; (setq split-height-threshold nil)
;; (setq split-width-threshold 0)

(use-package better-defaults
  :config
  ;; prevent strange window focus behaviour on macOS
  (menu-bar-mode 1))

;; Preserve recent visited files list
(use-package recentf
  :init
  (setq recentf-max-saved-items 100)
  :config
  (add-to-list 'recentf-exclude package-user-dir))

(use-package no-littering
  :after recentf
  :config
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (add-to-list 'recentf-exclude no-littering-var-directory)

  (setq backup-directory-alist
        `(("." . ,(no-littering-expand-var-file-name "backups/"))))

  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

  ;; Don't pollute init.el with custom settings
  (setq custom-file
        (no-littering-expand-etc-file-name "custom.el"))
  (unless (file-exists-p custom-file)
    (write-region "" nil custom-file))
  (add-hook 'after-init-hook #'(lambda () (load-file custom-file))))

(use-package exec-path-from-shell
  :init
  (setq
   exec-path-from-shell-shell-name "/usr/local/bin/zsh"
   exec-path-from-shell-check-startup-files nil
   exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH" "GOROOT"))
  :config
  (exec-path-from-shell-initialize))

;;
;; Theming
;;

(use-package nord-theme
  :init (progn
          (set-frame-font "FuraCode Nerd Font 14" nil t)
          (add-to-list 'default-frame-alist
                       '(font . "FuraCode Nerd Font 14"))
          (setq nord-comment-brightness 13)
          ;; enable ligatures
          (mac-auto-operator-composition-mode t))
  :config (load-theme 'nord t))

(use-package spaceline-config
  :ensure spaceline
  :after evil
  :init (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  :config (spaceline-spacemacs-theme))

;;
;; Dashboard
;;

(use-package dashboard
  :config (dashboard-setup-startup-hook))

;;
;; Key control
;;

(use-package evil
  :init (setq
         evil-want-keybinding nil
         evil-want-fine-undo t)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :init (setq
         evil-collection-mode-list '())
  :config (evil-collection-init))

(use-package general
  :after evil
  :init (setq
         mac-command-modifier 'super
         mac-option-modifier 'meta)
  :config (progn
            (general-evil-setup)

            ;; macOS essential global bindings
            (general-def
              "s-q" 'save-buffers-kill-terminal
              "s-v" 'yank
              "s-c" 'evil-yank
              "s-a" 'mark-whole-buffer
              "s-x" 'kill-region
              "s-w" 'delete-window
              "s-W" 'delete-frame
              "s-n" 'make-frame
              "s-z" 'undo-tree-undo
              "s-X" 'undo-tree-redo)

            (general-unbind "C-SPC")

            (general-create-definer my/leader
              :states '(normal insert emacs)
              :prefix "SPC"
              :non-normal-prefix "C-SPC")

            (my/leader
              "a" '(:prefix-command spc-app-map :wk "App")
              "b" '(:prefix-command spc-buffer-map :wk "Buffer")
              "f" '(:prefix-command spc-file-map :wk "File")
              "g" '(:prefix-command spc-git-map :wk "Git")
              "h" '(:prefix-command spc-help-map :wk "Help")
              "p" '(:prefix-command spc-project-map :wk "Project")
              "s" '(:prefix-command spc-search-map :wk "Search")
              "t" '(:prefix-command spc-toggle-map :wk "Toggle"))))

(use-package which-key
  :delight
  :config (which-key-mode))

;;
;; Buffer/windows control
;;

(defun my/kill-other-buffers ()
  "Kill all buffers except current."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (seq-filter 'buffer-file-name (buffer-list)))))

(general-def spc-buffer-map
  "p" 'previous-buffer
  "n" 'next-buffer
  "k" 'kill-this-buffer
  "K" 'my/kill-other-buffers)

(use-package winum
  :init (setq winum-auto-setup-mode-line nil)
  :config (winum-mode)
  :general
  (my/leader
    "0" '(winum-select-window-0 :wk "w0")
    "1" '(winum-select-window-1 :wk "w1")
    "2" '(winum-select-window-2 :wk "w2")
    "3" '(winum-select-window-3 :wk "w3")
    "4" '(winum-select-window-4 :wk "w4")
    "5" '(winum-select-window-5 :wk "w5")
    "6" '(winum-select-window-6 :wk "w6")))

(defun my/toggle-osx-fullscreen ()
  "Toggle frame fullscreen (native macOS one)."
  (interactive)
  (set-frame-parameter nil 'fullscreen
                       (if (frame-parameter nil 'fullscreen)
                           nil
                         'fullscreen)))

(general-def spc-toggle-map
  "F" 'my/toggle-osx-fullscreen)

;;
;; HELM
;;

(use-package helm
  :ensure t
  :delight
  :init (progn
          (when (executable-find "curl")
            (setq helm-google-suggest-use-curl-p t))
          (setq helm-split-window-inside-p t))
  :config (progn
            (require 'helm-config)
            (helm-mode 1))
  :general
  ;; Emacs command overrides
  ("C-c h"    'helm-command-prefix
   "M-x"      'helm-M-x
   "M-y"      'helm-show-kill-ring
   "C-x b"    'helm-mini
   "C-x C-f"  'helm-find-files
   "C-s"      'helm-ff-run-grep)

  ;; Helm bindings tuning
  (helm-map
   "TAB"   'helm-execute-persistent-action
   "C-<tab>" 'helm-select-action
   "C-j"   'helm-toggle-visible-mark)

  ;; Add actions to SPC-maps
  (my/leader
    "SPC" 'helm-M-x)

  (spc-buffer-map
   "b" 'helm-mini)

  (spc-file-map
   "f" 'helm-find-files
   "r" 'helm-recentf))

(use-package helm-ag)

;;
;; Projectile
;;

(use-package projectile
  :init
  (setq projectile-mode-line-prefix " P")
  :config (projectile-mode +1))

(use-package helm-projectile
  :config
  (helm-projectile-on)
  :general
  (spc-project-map
   "f" 'helm-projectile-find-file
   "s" 'helm-projectile-ag))

;;
;; Treemacs
;;

(use-package treemacs
  :init
  (setq treemacs-persist-file (expand-file-name "var/treemacs/persist" user-emacs-directory)
        treemacs-follow-after-init t)
  :general
  (spc-project-map
   "t" #'treemacs)
  (spc-file-map
   "t" #'treemacs))

(use-package treemacs-evil
  :after treemacs)

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit)

;;
;; Common editing
;;

(use-package undo-tree
  :delight
  :init
  (setq undo-tree-visualizer-diff t)
  :config
  (global-undo-tree-mode)
  :general
  (spc-app-map
   "u" 'undo-tree-visualize))

(use-package elec-pair
  :config
  (electric-pair-mode))

(use-package display-line-numbers
  :init
  (setq display-line-numbers-type 'relative)
  :general
  (spc-toggle-map
   "n" 'display-line-numbers))

;;
;; prog-mode related
;;

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package company
  :delight
  :hook (prog-mode . company-mode)
  :init
  (setq company-tooltip-align-annotations t)
  (setq company-minimum-prefix-length 1)
  :general
  (company-active-map
   "M-n" nil
   "M-p" nil
   "C-n" 'company-select-next-or-abort
   "C-p" 'company-select-previous-or-abort))

(use-package flycheck
  :delight ;; spaceline already has stats to display flycheck stuff
  :init
  (setq flycheck-emacs-lisp-load-path 'inherit)
  :config
  (global-flycheck-mode))

(use-package yafolding
  :delight
  :hook (prog-mode . yafolding-mode))

(use-package yasnippet
  :delight yas-minor-mode
  :config (yas-reload-all)
  :hook (prog-mode . yas-minor-mode))

(use-package evil-matchit
  :after evil)

(use-package abbrev
  :delight
  :ensure f)

(use-package eldoc
  :delight
  :ensure f)

;;
;; LSP stuff
;;

(use-package lsp-mode
  :commands lsp
  :config (require 'lsp-clients))

(use-package lsp-ui
  :after lsp-mode)

;;
;; GIT
;;

(use-package magit
  :general
  (spc-git-map
   "s" 'magit-status))

(use-package evil-magit)

(use-package gitignore-mode)
(use-package gitconfig-mode)
(use-package gitattributes-mode)

(provide 'core)
;;; core.el ends here
