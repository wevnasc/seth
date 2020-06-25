;; encoding system
(set-language-environment "UTF-8")
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; change the yes or no answer to y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; set font
(set-default-font "JetBrains Mono-16")

;; change the line spacing
(setq-default line-spacing 5)

;; prettify symbols
(global-prettify-symbols-mode +1)

;; Do not show the startup screen.
(setq inhibit-startup-message t)

;; frames configuration
(tool-bar-mode -1)
(display-time-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; start maximised (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; show line numbers
(global-linum-mode t)

;; show ~ at the end of the file for empty lines
(setq-default indicate-empty-lines t)

(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

(progn
    (define-fringe-bitmap 'tilde [0 0 0 113 219 142 0 0] nil nil 'center)
    (setcdr (assq 'empty-line fringe-indicator-alist) 'tilde))

;; if you close a buffer, it remembers where you were in the file
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))
(save-place-mode 1)

;; Highlight current line.
(global-hl-line-mode t)

;; Save files backup with ~ in a backup folder
(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

;; Require and initialize `package`.
(require 'package)
(setq package-enable-at-startup nil)
(package-initialize)

;; Add `melpa` to `package-archives`.
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode t))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package all-the-icons
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-vibrant t)
  (doom-themes-neotree-config)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package magit
  :ensure t)

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-mini))
  :config (helm-mode t))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-x p") projectile-command-map)
  (projectile-mode t))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package neotree
  :ensure t
  :bind (("C-x t" . 'neotree-toggle)))

(use-package cider
  :ensure t)

(use-package spaceline-all-the-icons
  :ensure t
  :config
  (spaceline-all-the-icons--setup-package-updates) ;; Enable package update indicator
  (spaceline-all-the-icons--setup-git-ahead)       ;; Enable # of commits ahead of upstream in git
  (spaceline-all-the-icons--setup-neotree))         ;; Enable Neotree mode line

;; spaceline configuration
(use-package spaceline
  :ensure t
  :config
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-emacs-theme))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (projectile use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
