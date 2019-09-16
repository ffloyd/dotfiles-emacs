;;; lang-elixir.el --- My Emacs Config: Elixir support
;;; Commentary:
;;; Code:

(use-package elixir-mode
  :init
  (add-to-list 'exec-path "~/Code/elixir-ls/release/")
  (add-hook 'elixir-mode-hook #'lsp-mode))

(provide 'lang-elixir)
;;; lang-elixir.el ends here
