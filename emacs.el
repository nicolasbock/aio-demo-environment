;;; package --- Summary

;;; Commentary:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; Code:

;; Add some more package archives.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t) ; Org-mode's repository

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq frame-background-mode 'dark)

(use-package yaml-mode
  :ensure t
  :config (add-hook 'yaml-mode-hook
                    '(lambda ()
                       (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
  :mode (("\\.yml\\'" . yaml-mode)))

(use-package jinja2-mode
  :ensure t
  :mode (("\\.j2\\'" . jinja2-mode)))

(provide '.emacs)
;;; .emacs ends here
