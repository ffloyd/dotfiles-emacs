;;; init.el --- My Emacs Configuration: entry point.
;;
;; Copyright (c) 2018-2018 Roman Kolesnev
;;
;; Author: Roman Kolesnev <rvkolesnev@gmail.com>
;; URL: https://github.com/ffloyd/.emacs.d
;; Version: 0.0.1

;;; Commentary:

;; This file simply sets up the modules load path
;; and requires various modules from My Emacs Configuration.

;;; Code:

;;
;; Essential setup
;;

(setq package-enable-at-startup nil)
(setq load-prefer-newer t)

(when (version< emacs-version "25.1")
  (error "Emacs configuration requires GNU Emacs 25.1 or newer, but you're running %s" emacs-version))

;; Also prevents "changed file on disk" dialogs while installing libraries
(global-auto-revert-mode t)

;; straight.el for managing packages in pair with use-package
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(use-package delight)

;; fuck emacs non-modern libs
(use-package dash :config (dash-enable-font-lock))
(use-package s)
(use-package f)

;;
;; Modules setup and loading
;;

(defvar my/modules-dir (f-expand "modules" user-emacs-directory)
  "My Emacs Config modules dir.")

(add-to-list 'load-path
	     my/modules-dir)
(require 'core)
(require 'lang-elixir)
(require 'lang-ruby)
(require 'lang-other)

(server-start)

(provide 'init)
;;; init.el ends here
