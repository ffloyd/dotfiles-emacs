;;; tool-lsp.el --- My Emacs Config: LSP-related stuff
;;; Commentary:
;;; Code:

(use-package lsp-mode
  :init
  (setq lsp-prefer-flymake nil)
  :config
  (add-hook 'elixir-mode-hook #'lsp))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-doc-enable nil
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t
        lsp-ui-flycheck-list-position 'bottom
        lsp-ui-flycheck-live-reporting t
        lsp-ui-peek-enable t)
  :general
  (spc-lang-map
   "a" #'lsp-execute-code-action
   "g" #'lsp-goto-implementation))

(use-package company-lsp
  :init
  (setq company-transformers nil
        company-lsp-async t
        company-lsp-cache-candidates nil)
  :config
  (push 'company-lsp company-backends))

(provide 'tool-lsp)
;;; tool-lsp.el ends here
