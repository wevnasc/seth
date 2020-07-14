;; encoding system
(set-language-environment "UTF-8")
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; change the yes or no answer to y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; set font
(set-default-font "JetBrains Mono-14")

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

;; Add new exec-path
(add-to-list 'exec-path "/usr/local/bin")

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
  (load-theme 'doom-dracula t)
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

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'foo-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Languages

(defun clj-refactor-setup ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1)
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'clj-refactor-setup))

(defun cider-format-and-back () (interactive)
  (let (p)
    (setq p (point))
    (cider-format-buffer)
    (goto-char p)))

(defun add-clj-format-before-save () (interactive)
       (add-hook 'before-save-hook
                 'cider-format-and-back
                 t t))

(defun add-clj-eval-after-save () (interactive)
       (add-hook 'after-save-hook
		 'cider-eval-buffer
		 t t))

(use-package cider
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
            'add-clj-format-before-save)
  (add-hook 'clojure-mode-hook
	    'add-clj-eval-after-save))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3a3de615f80a0e8706208f0a71bbcc7cc3816988f971b6d237223b6731f91605" default)))
 '(package-selected-packages
   (quote
    (rainbow-delimiters cider neotree helm-projectile projectile helm magit doom-themes all-the-icons company which-key use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
