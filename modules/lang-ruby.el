;;; lang-ruby.el --- My Emacs Config: Ruby support
;;; Commentary:
;;; Code:

(use-package enh-ruby-mode
  :mode "\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'"
  :interpreter "ruby"
  :init
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (setq enh-ruby-deep-indent-paren nil))

(use-package rspec-mode
  :after enh-ruby-mode)

(use-package yard-mode
  :after enh-ruby-mode
  :hook enh-ruby-mode)

(use-package rubocop
  :after enh-ruby-mode)

(use-package rbenv
  :after enh-ruby-mode
  :config
  (global-rbenv-mode))

(provide 'lang-ruby)
;;; lang-ruby.el ends here
