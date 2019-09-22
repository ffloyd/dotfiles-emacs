;;; lang-elixir.el --- My Emacs Config: Elixir support
;;; Commentary:
;;; Code:

(use-package elixir-mode
  :init
  (add-to-list 'exec-path "~/Code/elixir-ls/release/"))

(provide 'lang-elixir)
;;; lang-elixir.el ends here
