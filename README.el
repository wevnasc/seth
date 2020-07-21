(set-language-environment "UTF-8")
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; change the yes or no answer to y or n
(defalias 'yes-or-no-p 'y-or-n-p)(defalias 'yes-or-no-p 'y-or-n-p)

;; disable startup screen
(setq inhibit-startup-message t)

;; disable some views
(tool-bar-mode -1)
(display-time-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; start screen in the max size
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

;; Highlight current line.
(global-hl-line-mode t)

;; if you close a buffer, it remembers where you were in the file
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))
(save-place-mode 1)

;; Save files backup with ~ in a backup folder
(setq backup-directory-alist `(("." . "~/.emacs.d/backup")))

;; Add new exec-path
(add-to-list 'exec-path "/usr/local/bin")

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode t))

(use-package company
  :ensure t
  :config
  (global-company-mode))

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

(set-default-font "JetBrains Mono-14")
(setq-default line-spacing 5)
(global-prettify-symbols-mode +1)

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

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  :config
  (setq-default flycheck-highlighting-mode 'lines)
  (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
      (vector #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00011100
              #b00111110
              #b00111110
              #b00111110
              #b00011100
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000))
    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-error)
    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-warning)
    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'flycheck-fringe-bitmap-ball
      :fringe-face 'flycheck-fringe-info))

(use-package flycheck-clj-kondo
  :ensure t
  :after flycheck
  :config
  (dolist (checker '(clj-kondo-clj clj-kondo-cljs clj-kondo-cljc clj-kondo-edn))
    (setq flycheck-checkers (cons checker (delq checker flycheck-checkers)))))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'foo-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(defun cider-format-and-back () (interactive)
  (let (p)
    (setq p (point))
    (cider-format-buffer)
    (goto-char p)))

(defun add-clj-format-before-save () (interactive)
       (add-hook 'before-save-hook
                 'cider-format-and-back
                 t t))

(use-package cider
  :init 
  (add-to-list 'exec-path "/usr/local/bin")
  :ensure t
  :config
  (add-hook 'clojure-mode-hook
            'add-clj-format-before-save)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (setq cider-repl-use-pretty-printing t))

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(use-package elixir-mode
  :ensure t
  :mode (("\\.ex\\'" . elixir-mode)
         ("\\.exs\\'" . elixir-mode)))

(use-package alchemist
  :ensure t
  :hook (elixir-mode . alchemist-mode)
  :config
  (setq alchemist-mix-env "dev")
  (setq alchemist-hooks-compile-on-save t)
  (setq alchemist-mix-command "~/.asdf/shims/mix")
  (setq alchemist-iex-program-name "~/.asdf/shims/iex")
  (setq alchemist-execute-command "~/.asdf/shims/elixir")
  (setq alchemist-compile-command "~/.asdf/shims/elixirc"))

(setq lsp-keymap-prefix "C-c l")

(use-package lsp-mode
    :init
    (add-to-list 'exec-path "~/lsp/elixir-ls/release")
    :hook ((clojure-mode . lsp)
	   (clojurec-mode . lsp)
	   (clojurescript-mode . lsp)
           (elixir-mode . lsp)
	   (lsp-mode . lsp-enable-which-key-integration))
    :bind (("M-." . lsp-find-definition))
    :commands lsp
    :config
    (setenv "PATH" (concat "~/.asdf/shims" path-separator (getenv "PATH")))
    (setenv "PATH" (concat "/usr/local/bin" path-separator (getenv "PATH")))
    (dolist (m '(clojure-mode
		 clojurec-mode
		 clojurescript-mode
		 clojurex-mode))
      (add-to-list 'lsp-language-id-configuration `(,m . "clojure"))
      (add-to-list 'lsp-language-id-configuration `(elixir-mode . "elixir"))))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company-lsp
  :ensure t
  :commands company-lsp)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
