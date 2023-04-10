
;; ------ Automatic emacs lines -------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dde643b0efb339c0de5645a2bc2e8b4176976d5298065b8e6ca45bc4ddf188b7" "3199be8536de4a8300eaf9ce6d864a35aa802088c0925e944e2b74a574c68fd0" "a0415d8fc6aeec455376f0cbcc1bee5f8c408295d1c2b9a1336db6947b89dd98" default))
 '(package-selected-packages
   '(emr srefactor company-lsp vscode-dark-plus-theme flycheck-clang-tidy yasnippet treemacs-projectile treemacs clang-format+ company ue lsp-ivy lsp-ui lsp-mode all-the-icons-ivy-rich dired-hide-dotfiles all-the-icons-dired all-the-icons exwm dirtrack ivy slime avy markdown-mode flycheck-pkg-config undo-tree ivy-xref dumb-jump flycheck modern-cpp-font-lock auto-complete pdf-continuous-scroll-mode pdf-tools paredit parinfer-rust multiple-cursors cmake-mode which-key use-package spacemacs-theme solo-jazz-theme solarized-theme rainbow-delimiters projectile parinfer-rust-mode one-themes modus-themes ivy-rich helpful doom-themes doom-modeline counsel))
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ------ Starting up emacs ------
(defun initial-setup ()
  (setq inhibit-startup-message t)                             ; Disable startup message
  (setq initial-scratch-message nil)                           ; Disable initial scratch message
  (scroll-bar-mode -1)                                         ; Disable scrollbar
  (horizontal-scroll-bar-mode -1)                              ; Disable scrollbar
  (tool-bar-mode -1)                                           ; Disable the toolbar
  (tooltip-mode -1)                                            ; Disable tooltips
  (menu-bar-mode -1)                                           ; Disable menu bar                          
  (set-fringe-mode 10)                                         ; Give some breathing room
  (add-to-list 'initial-frame-alist '(fullscreen . maximized)) ; Initialize emacs maximized
  (setq frame-resize-pixelwise t)                              ; Adjust to window correctly
  (delete-selection-mode 1)                                    ; Follow the convention of modern editors
  ;; (setq-default indent-tabs-mode nil)                            ; Prevents extraneous tabs
  (setq-default tab-width 4)                                   ; Tabs width being 4 spaces long
  (set-face-attribute 'default nil :height 100)                ; Make font scale a bit larger
  )

(initial-setup)

;; ----- Emacs backup and autosave files -----
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))             ; Put backup files (ie foo~) in ~/.emacs.d/.
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)                                 ; create the autosave dir if necessary, since emacs won't.
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t))) ; Put autosave files (ie #foo#) in ~/.emacs.d/ (I think)


;; ------ Scrolling and window resizing------
(setq mouse-wheel-scroll-amount '(2 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(defun custom-scroll-up ()
  "Scroll up 2 lines."
  (interactive)
  (scroll-up 2))

(defun custom-scroll-down ()
  "Scroll down 2 lines."
  (interactive)
  (scroll-down 2))

(defun fast-scroll-up ()
  "Scroll up 5 lines."
  (interactive)
  (scroll-up 5))

(defun fast-scroll-down ()
  "Scroll down 5 lines."
  (interactive)
  (scroll-down 5))

(global-set-key (kbd "<M-up>") 'custom-scroll-down)
(global-set-key (kbd "<M-down>") 'custom-scroll-up)
(global-set-key (kbd "<M-S-up>") 'fast-scroll-down)
(global-set-key (kbd "<M-S-down>") 'fast-scroll-up)
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)


;; ----- Melpa -----
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))


;; ----- use-package -----
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t) ; Makes a package to be installed if it isn't


;; ----- Theme -----
(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t))


;; ------- Doom modeline -------
(use-package doom-modeline
  :init (doom-modeline-mode 1))


;; ----- thing at point -----
(require 'thingatpt)


;; ----- all-the-icons ------
(use-package all-the-icons
  :if (display-graphic-p))


;; ------ dired ------
(use-package dired
  :ensure nil
  :custom
  ((dired-listing-switches "-agho --group-directories-first")
   (delete-by-moving-to-trash t)
   (dired-dwim-target t)))

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :config
  (define-key dired-mode-map "H" 'dired-hide-dotfiles-mode))


;; ----- Undo tree -----
(use-package undo-tree
  :bind (("C-x u" . undo-tree-visualize)
	 ("C-/" . custom-undo-tree-undo)
	 ("C-?" . undo-tree-redo))
  :config
  (global-undo-tree-mode))

;; (defun activate-undo-tree-on-window-change (window-or-frame)
;;   "Activate undo-tree when entering at WINDOW-OR-FRAME."
;;   (when (or (not (boundp 'undo-tree-mode)) (not undo-tree-mode))
;;     (undo-tree-mode t)))

;; (setq window-selection-change-functions (cons #'activate-undo-tree-on-window-change window-selection-change-functions))
;;(add-to-list 'undo-tree-history-directory-alist `("." . ,(expand-file-name "undo-tree-history/" user-emacs-directory)))


;; -------- Electric pair --------
(add-hook 'emacs-lisp-mode-hook       #'electric-pair-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'electric-pair-mode)
(add-hook 'ielm-mode-hook             #'electric-pair-mode)
(add-hook 'lisp-mode-hook             #'electric-pair-mode)
(add-hook 'lisp-interaction-mode-hook #'electric-pair-mode)
(add-hook 'scheme-mode-hook           #'electric-pair-mode)


;; ------- Show paren -------
(add-hook 'emacs-lisp-mode-hook       #'show-paren-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'show-paren-mode)
(add-hook 'ielm-mode-hook             #'show-paren-mode)
(add-hook 'lisp-mode-hook             #'show-paren-mode)
(add-hook 'lisp-interaction-mode-hook #'show-paren-mode)
(add-hook 'scheme-mode-hook           #'show-paren-mode)


;; ------- Line numbers -------
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(eshell-mode-hook)) ; Indicate in which modes we don't want this mode
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; ------- Which key mode -------
(use-package which-key
  :init (setq which-key-idle-delay 3.0)
  :config (which-key-mode))


;; ------- Ivy mode -------
(use-package ivy
  :init (ivy-mode)
  :bind (("C-s" . swiper)
	 ("C-S-s" . swiper-isearch-thing-at-point)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))


;; ------ all-the-icons-ivy-rich ------
(use-package all-the-icons-ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))


;; ------ Ivy rich ------
(use-package ivy-rich
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))


;; ------ Counsel ------
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
         ("C-x d" . counsel-dired)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))


;; ----- Ivy xref -----
(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))


;; ------ helpful ------
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; ------ projectile ------
(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


;; ------- Multiple cursors -------
(use-package multiple-cursors)
(global-set-key (kbd "C-S-c") 'mc/edit-lines)
(define-key mc/keymap (kbd "<return>") nil)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)


;; ----- Modern C++ font -----
(use-package modern-cpp-font-lock)


;; ----- Dumb jump -----
(use-package dumb-jump)
(setq xref-backend-functions (remq 'etags--xref-backend xref-backend-functions))
(add-to-list 'xref-backend-functions #'dumb-jump-xref-activate)


;; ----- Avy -----
(use-package avy
  :bind ("M-s" . avy-goto-char-2))


;; ---- Dirtrack ----
(use-package dirtrack) 
(add-hook 'shell-mode-hook
	  (lambda ()
            (shell-dirtrack-mode 0) 
            (setq dirtrack-list '(":*\\([A-Za-z]*:*~*[\/\\].*?\\)[^-+A-Za-z0-9_.()//\\ ]" 1)) 
            (dirtrack-mode))) 

(defun shell-dir (name dir)
  (interactive "sShell name: \nDDirectory: ")
  (let ((default-directory dir))
    (shell name)))


;; ----- Markdown -----
(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "pandoc"))


;; ------ yasnippet ------
(use-package yasnippet
  :config
  (yas-global-mode 1)
  (yas-reload-all)
  :bind (:map yas-minor-mode-map
              ("<tab>" . nil)
              ("TAB" . nil)
              ("<backtab>" . yas-expand)))


;; ------ lsp ------
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp)
         (c-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-clangd-binary-path "c:/clangd/bin/clangd.exe")
  (setq lsp-diagnostic-package :none))


;; ------ lsp-ui ------
(use-package lsp-ui :commands lsp-ui-mode)


;; ------ lsp-ivy ------
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)


;; ------ ue ------
;; The Unreal Engine path
(setq unreal-directory "C:/Users/hecto/Documents/GitHub/UnrealEngine/")  ; <- This must end with a slash

;; Returns the command to perform a pseudo compilation (updates UHT info)
(defun pseudo-compile-command ()
  (let* ((project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (cmd (concat unreal-directory "Engine/Build/BatchFiles/Build.bat"))
		 (target (concat project-name "Editor"))
		 (platform "Win64")
		 (project-file (concat project-root project-name ".uproject")))
	(concat cmd " " target " " platform " " "DebugGame" " " "-SkipBuild" " " "-project=\"" project-file "\"")))

;; Pseudo compile process handler
(setq pseudo-compile-process nil)

;; Starts the pseudo compile process
(defun start-pseudo-compile-process ()
  (if (and (boundp 'ue-mode) ue-mode (not (and pseudo-compile-process (process-live-p pseudo-compile-process))))
	  (progn
		(setq pseudo-compile-process
			  (start-process-shell-command "Pseudo compile"
										   nil
										   (pseudo-compile-command)))
		(set-process-sentinel pseudo-compile-process (lambda (p e) (flycheck-buffer))))))


;; Returns the command to compile a project
(defun compile-unreal-project-command ()
  (let* ((project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (cmd (concat unreal-directory "Engine/Build/BatchFiles/RunUAT.bat"))
		 (project-file (concat project-root project-name ".uproject")))
	(concat cmd " " "BuildEditor" " " "-project=\"" project-file "\"")))

;; Compiles a project
(defun compile-unreal-project ()
  (interactive)
  (async-shell-command (print (compile-unreal-project-command) (get-buffer "*scratch*"))))


;; Return the command to run a project
(defun run-unreal-project-command ()
  (let* ((unreal-executable (concat unreal-directory "Engine/Binaries/Win64/UnrealEditor.exe"))
		 (project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (project-file (concat project-root project-name ".uproject")))
	(concat unreal-executable " " "\"" project-file "\"")))

;; Runs a project
(defun run-unreal-project ()
  (interactive)
  (async-shell-command (run-unreal-project-command)))

(use-package ue
  :config
  (define-key ue-mode-map (kbd "C-c u") 'ue-command-map)

  ;; Define a read-only directory class
  (dir-locals-set-class-variables 'read-only '((nil . ((buffer-read-only . t)))))

  ;; Associate directories with the read-only class
  (dolist (dir (list "c:/Users/hecto/Documents/GitHub/UnrealEngine"))
	(dir-locals-set-directory-class (file-truename dir) 'read-only))
  
  :hook
  ((lsp-mode . ue-mode)
   (ue-mode . yas-minor-mode)
   (after-save . start-pseudo-compile-process))

  :bind (:map ue-mode-map
			  ("C-c u c" . compile-unreal-project)
			  ("C-c u r" . run-unreal-project)))


;; ------ clang-format ------
(use-package clang-format
  :config
  (setq clang-format-style-option "llvm"))


;; ------ c-mode ------
(use-package cc-mode
  :config
  (fset 'c-indent-region 'clang-format-region)
  :bind (:map c-mode-base-map
			  ("C-<tab>" . clang-format-buffer)
			  ("C-i" . tab-to-tab-stop)
			  ("<backspace>" . backward-delete-char)))


;; ------ flycheck ------
(use-package flycheck
  :hook (lsp-mode . flycheck-mode))


;; ------ flycheck-clang-tidy ------
(use-package flycheck-clang-tidy
  :after flycheck
  :hook
  (flycheck-mode . flycheck-clang-tidy-setup))


;; ------ company ------
(use-package company
  :hook (lsp . company)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  :config
  (add-to-list 'company-backends '(company-capf :with company-yasnippet))
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 2)
  (setq company-transformers '(company-sort-prefer-same-case-prefix)))


;; ------ semantic refactor ------
(use-package srefactor
  :hook ((c++-mode . semantic-mode)
		 (c-mode . semantic-mode))
  :bind ((:map c++-mode-map ("M-RET" . srefactor-refactor-at-point))
		 (:map c-mode-map ("M-RET" . srefactor-refactor-at-point))))


;; ------ emacs-refactor ------
;; (use-package emr
;;   :config
;;   (define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu))


;; ------ treemacs ------
(use-package treemacs
  :bind (("C-c t t" . treemacs))
  :config
  (setq treemacs-width 40)
  (setq treemacs-position 'right)
  (treemacs-resize-icons 16)
  (setq treemacs-text-scale -1))

(use-package treemacs-projectile
  :after (treemacs projectile))
