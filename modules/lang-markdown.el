;;; lang-markdown.el --- My Emacs Config: Markdown support
;;; Commentary:
;;; Code:

(use-package markdown-mode
  :demand t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(provide 'lang-markdown)
;;; lang-markdown.el ends here
