;;; lang-ruby.el --- My Emacs Config: Ruby support
;;; Commentary:
;;; Code:

(use-package enh-ruby-mode
  :mode "\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'"
  :interpreter "ruby"
  :init
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (setq enh-ruby-deep-indent-paren nil)
  :general
  (my/leader
    :keymaps 'enh-ruby-mode-map
    "m" '(:prefix-command spc-ruby-map :wk "Ruby")))

(use-package rspec-mode
  :after enh-ruby-mode
  :general
  (spc-ruby-map
   "t" '(:prefix-command spc-ruby-rspec-map :wk "RSpec"))
  (spc-ruby-rspec-map
   "b" #'rspec-verify-matching
   "a" #'rspec-verify-all
   "c" #'rspec-verify-continue
   "t" #'rspec-verify-single))

(use-package yard-mode
  :after enh-ruby-mode
  :hook enh-ruby-mode)

(use-package rubocop
  :after enh-ruby-mode
  :general
  (spc-ruby-map
   "=" #'rubocop-autocorrect-current-file
   "r" '(:prefix-command spc-ruby-rubocop-map :wk "Rubocop"))
  (spc-ruby-rubocop-map
   "a" #'rubocop-check-project
   "A" #'rubocop-autocorrect-project
   "d" #'rubocop-check-directory
   "D" #'rubocop-autocorrect-directory
   "f" #'rubocop-check-current-file
   "F" #'rubocop-autocorrect-current-file))

(use-package rbenv
  :after enh-ruby-mode
  :config
  (global-rbenv-mode)
  :general
  (spc-ruby-map
   "R" '(:prefix-command spc-ruby-rbenv-map))
  (spc-ruby-rbenv-map
   "u" #'rbenv-use
   "g" #'rbenv-use-global
   "c" #'rbenv-use-corresponding))

(provide 'lang-ruby)
;;; lang-ruby.el ends here
