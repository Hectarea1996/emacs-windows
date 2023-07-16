
;; ------ Automatic emacs lines -------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dde643b0efb339c0de5645a2bc2e8b4176976d5298065b8e6ca45bc4ddf188b7" "3199be8536de4a8300eaf9ce6d864a35aa802088c0925e944e2b74a574c68fd0" "a0415d8fc6aeec455376f0cbcc1bee5f8c408295d1c2b9a1336db6947b89dd98" default))
 '(package-selected-packages
   '(csharp-mode tree-sitter-indent tree-sitter-langs tree-sitter rg emr srefactor company-lsp vscode-dark-plus-theme flycheck-clang-tidy yasnippet treemacs-projectile treemacs clang-format+ company ue lsp-ivy lsp-ui lsp-mode all-the-icons-ivy-rich dired-hide-dotfiles all-the-icons-dired all-the-icons exwm dirtrack ivy slime avy markdown-mode flycheck-pkg-config undo-tree ivy-xref dumb-jump flycheck modern-cpp-font-lock auto-complete pdf-continuous-scroll-mode pdf-tools paredit parinfer-rust multiple-cursors cmake-mode which-key use-package spacemacs-theme solo-jazz-theme solarized-theme rainbow-delimiters projectile parinfer-rust-mode one-themes modus-themes ivy-rich helpful doom-themes doom-modeline counsel))
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
  (prefer-coding-system 'utf-8)                                ; Prevent the select enconding system window
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
  (blink-cursor-mode 0))

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
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-use-git-grep t))


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
  (setq lsp-diagnostic-package :none)
  (setq lsp-clients-clangd-args '("--header-insertion=never")))


;; ------ lsp-ui ------
(use-package lsp-ui :commands lsp-ui-mode)


;; ------ lsp-ivy ------
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)


;; ------ ue ------
;; The Unreal Engine path
(setq source-unreal-directory "C:/Users/hecto/Documents/GitHub/UnrealEngine/")  ; <- These must end with a slash
(setq unreal-directory "C:/Program Files/Epic Games/UE_5.1/")


;; Returns the command to generate the compile_commands.json file
(defun generate-files-command (&optional enginep)
  (let* ((command-name (concat source-unreal-directory "Engine/Build/BatchFiles/Build.bat"))
		 (project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (project-file (concat project-root project-name ".uproject"))
		 (target (concat project-name "Editor"))
		 (platform "Win64"))
	(concat "\"" command-name "\"" " " "-mode=GenerateClangDatabase" (if enginep
																		 ""
																	   (concat " " "-OutputDir=" "\"" project-root "\"" ))
			" " "-project=\"" project-file "\"" " " target " " "Development" " " platform)))

;; The buffer where toprint the results of the following two commands
(setq generate-files-buffer-output "*Output*")

;; Generates the compile_commands.json file
;; (defun generate-project-files (&optional enginep)
;;   (start-process-shell-command "Generate" generate-files-buffer-output (generate-files-command enginep)))

;; Moves the compile_commands.json file
;; (defun copy-project-files ()
;;   (let* ((src-file (concat unreal-directory "compile_commands.json"))
;; 		 (project-root (projectile-project-root))
;; 		 (dst-file (concat project-root "compile_commands.json")))
;; 	(copy-file src-file dst-file t)))

;; Generates the compile_commands.json file
(defun generate-project-files (&optional enginep)
  (interactive)
  (let ((original-buffer (current-buffer)))
	(switch-to-buffer-other-window generate-files-buffer-output)
	(switch-to-buffer-other-window original-buffer))
  (start-process-shell-command "Generate" generate-files-buffer-output (generate-files-command enginep))
  ;; (set-process-sentinel (generate-project-files) (lambda (_ _) (copy-project-files)))
  )


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
  ;; (let* ((project-root (projectile-project-root))
  ;; 		 (project-name (projectile-project-name))
  ;; 		 (cmd (concat unreal-directory "Engine/Build/BatchFiles/RunUAT.bat"))
  ;; 		 (project-file (concat project-root project-name ".uproject")))
  ;; 	(concat cmd " " "BuildEditor" " " "-project=\"" project-file "\""))
  (let* ((project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (cmd (concat unreal-directory "Engine/Build/BatchFiles/Build.bat"))
		 (project-file (concat project-root project-name ".uproject"))
		 (target (concat project-name "Editor"))
		 (platform "Win64")
		 (project-file (concat project-root project-name ".uproject")))
	(concat "\"" cmd "\"" " " "-Target=\"" target "\"" " " platform " " "Development" " " "-Project=\"" project-file "\"" " " "-WaitMutex" " " "-FromMsBuild")))

;; Compiles a project
(defun compile-unreal-project ()
  (interactive)
  (async-shell-command (compile-unreal-project-command)))


;; Returns the command to clean a project
(defun clean-unreal-project-command ()
  (let* ((project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (cmd (concat unreal-directory "Engine/Build/BatchFiles/Clean.bat"))
		 (project-file (concat project-root project-name ".uproject"))
		 (target (concat project-name "Editor"))
		 (platform "Win64")
		 (project-file (concat project-root project-name ".uproject")))
	(concat cmd " " "-Target=\"" target "\"" " " platform " " "Development" " " "-Project=\"" project-file "\"" " " "-WaitMutex" " " "-FromMsBuild")))

;; Cleans a project
(defun clean-unreal-project ()
  (interactive)
  (async-shell-command (print (clean-unreal-project-command) (get-buffer "*scratch*"))))


;; Return the command to run a project
(defun run-unreal-project-command ()
  (let* ((unreal-executable (concat unreal-directory "Engine/Binaries/Win64/UnrealEditor.exe"))
		 (project-root (projectile-project-root))
		 (project-name (projectile-project-name))
		 (project-file (concat project-root project-name ".uproject")))
	(concat "\"" unreal-executable "\"" " " "\"" project-file "\"")))

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
			  ("C-c u r" . run-unreal-project)
			  ("C-c u g" . generate-project-files)))


;; ------ clang-format ------
(use-package clang-format
  :config
  (setq clang-format-style-option "llvm"))


;; ------ c-mode ------
(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  (setq c-syntactic-indentation nil)
  )

(use-package cc-mode
  :config
  (fset 'c-indent-region 'clang-format-region)
  :bind (:map c-mode-base-map
			  ("C-<tab>" . clang-format-buffer)
			  ("C-i" . tab-to-tab-stop)
			  ("<backspace>" . backward-delete-char)
			  ("RET" . newline))
  :hook ((c-mode . my-c-mode-common-hook)
		 (c++-mode . my-c-mode-common-hook)))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; ------ tree-sitter ------
(use-package tree-sitter :ensure t)
(use-package tree-sitter-langs :ensure t)
(use-package tree-sitter-indent :ensure t)
(add-hook 'c++-mode #'tree-sitter-mode)
(add-hook 'c-mode #'tree-sitter-mode)
(add-hook 'tree-sitter-mode #'tree-sitter-hl-mode)
(defvar cpp-language (alist-get 'cpp tree-sitter-languages))

(setq variable-macros-regexp "[[:graph:]]+_API")
(setq function-macros-regexp "GENERATED_BODY\\\|UFUNCTION\\|UCLASS\\\|UPROPERTY\\\|USTRUCT\\\|UENUM\\\|UMETA\\\|UPARAM")

(defmacro with-no-macros-buffer (buffer new-buffer &rest body)
  (unless (symbolp new-buffer)
	(signal 'wrong-type-argument (list 'symbolp new-buffer)))
  (let ((src-buffer (make-symbol "src-buffer"))
		(current-point (make-symbol "current-point")))
	`(let* ((,src-buffer ,buffer)
			(,current-point (with-current-buffer ,src-buffer
							 (point))))
	   (when (not ,src-buffer)
		 (setq ,src-buffer (current-buffer)))
	   (let ((,new-buffer (generate-new-buffer "*no-macros-buffer*" t)))
		 (with-current-buffer ,new-buffer
		   (unwind-protect
			   (let ((critical-regions nil))
				 (insert-buffer ,src-buffer)
				 (while (re-search-forward variable-macros-regexp nil t)
				   (let ((end-macro (point))
						 (start-macro nil))
					 (save-excursion
					   (backward-sexp)
					   (setq start-macro (point)))
					 (push (cons start-macro (- end-macro start-macro)) critical-regions)))
				 (goto-char (point-min))
				 (while (re-search-forward function-macros-regexp nil t)
				   (let ((end-macro nil)
						 (start-macro nil))
					 (save-excursion
					   (backward-sexp)
					   (setq start-macro (point)))
					 (save-excursion
					   (forward-sexp)
					   (setq end-macro (point)))
					 (push (cons start-macro (- end-macro start-macro)) critical-regions)))
				 (dolist (critical-region critical-regions)
				   (let ((start-region  (car critical-region))
						 (length-region (cdr critical-region)))
					 (goto-char start-region)
					 (delete-forward-char length-region)
					 (insert (make-string length-region ?\s))))
				 (goto-char ,current-point)
				 (c++-mode)
				 (tree-sitter-mode)
				 ,@body)
			 (and (buffer-name ,new-buffer)
				  (kill-buffer ,new-buffer))))))))

(defun ue-class-name-at-point ()
  (interactive)
  (with-no-macros-buffer (current-buffer) no-unreal-buffer
						 (when-let* ((uclass-query (tsc-make-query cpp-language "(class_specifier (type_identifier) @x . (base_class_clause)? . (field_declaration_list))"))
									 (node-at-point (tree-sitter-node-at-pos 'class_specifier))
									 (captures (tsc-query-captures uclass-query node-at-point 'tsc--buffer-substring-no-properties)))
						   (tsc-node-text (cdr (aref captures 0))))))

;; "[(field_declaration (function_declarator (field_identifier) @y)) (declaration (function_declarator (identifier) @x))]"

(defun ue-method-name-at-point ()
  (interactive)
  (with-no-macros-buffer (current-buffer) no-unreal-buffer
						 (when-let* ((method-query (tsc-make-query cpp-language "(field_declaration (function_declarator (field_identifier) @y))"))
									 (node-at-point (tree-sitter-node-at-pos 'field_declaration))
									 (captures (tsc-query-captures method-query node-at-point 'tsc--buffer-substring-no-properties)))
						   (if (not (seq-empty-p captures))
							   (tsc-node-text (cdr (elt captures 0)))
							 (when-let* ((constructor-query (tsc-make-query cpp-language "(declaration (function_declarator (identifier) @x))"))
										 (node-at-point (tree-sitter-node-at-pos 'declaration))
										 (captures (tsc-query-captures constructor-query node-at-point 'tsc--buffer-substring-no-properties)))
							   (tsc-node-text (cdr (elt captures 0))))))))

(defun ue-method-node-at-point ()
  (interactive)
  (with-no-macros-buffer (current-buffer) no-unreal-buffer
						 (when-let* ((method-query (tsc-make-query cpp-language "(field_declaration (function_declarator (field_identifier))) @x"))
									 (node-at-point (tree-sitter-node-at-pos 'field_declaration))
									 (captures (tsc-query-captures method-query node-at-point 'tsc--buffer-substring-no-properties)))
						   (if (not (seq-empty-p captures))
							   (cdr (elt captures 0))
							 (when-let* ((constructor-query (tsc-make-query cpp-language "(declaration (function_declarator (identifier))) @x"))
										 (node-at-point (tree-sitter-node-at-pos 'declaration))
										 (captures (tsc-query-captures constructor-query node-at-point 'tsc--buffer-substring-no-properties)))
							   (cdr (elt captures 0)))))))

(defun ue-buffer-node-classes (&optional buffer)
  (when (not buffer)
	(setq buffer (current-buffer)))
  (with-no-macros-buffer buffer no-ue-buffer
						 (when-let* ((uclass-query (tsc-make-query cpp-language "(class_specifier (type_identifier) . (base_class_clause)? . (field_declaration_list)) @x"))
									 (root-node (tsc-root-node tree-sitter-tree))
									 (captures (tsc-query-captures uclass-query root-node 'tsc--buffer-substring-no-properties)))
						   (seq-map (lambda (elem)
									  (print (tsc-node-text (cdr elem)) (get-buffer "*scratch*"))
									  (cdr elem))
									captures))))

(defun ue-node-class-name (class-node)
  (unless (tsc-node-p class-node)
	(signal 'wrong-type-argument (list 'tsc-node-p class-node)))
  (when-let* ((name-query (tsc-make-query cpp-language "(class_specifier (type_identifier) @x . (base_class_clause)? . (field_declaration_list))"))
			  (captures (tsc-query-captures name-query elem 'tsc--buffer-substring-no-properties)))
	(tsc-node-text (cdr (elt captures 0)))))

(defun ue-buffer-class-names (&optional buffer)
  (when (not buffer)
	(setq buffer (current-buffer)))
  (seq-mapcat (lambda (elem)
				(when-let ((name (ue-node-class-name elem)))
				  (list name)))
			  (ue-buffer-node-classes buffer)))

(defun ue-node-class-node-methods (class-node)
  (unless (tsc-node-p class-node)
	(signal 'wrong-type-argument (list 'tsc-node-p class-node)))
  (when-let* ((method-query (tsc-make-query cpp-language "[(field_declaration (function_declarator (field_identifier) @y)) (declaration (function_declarator (identifier) @x))]"))
			  (captures (tsc-query-captures method-query class-node 'tsc--buffer-substring-no-properties)))
	(seq-map (lambda (elem)
			   (cdr elem))
			 captures)))

(defun ue-node-method-name (method-node)
  (unless (tsc-node-p method-node)
	(signal 'wrong-type-argument (list 'tsc-node-p method-node)))
  (when-let* ((method-query (tsc-make-query cpp-language "[(field_declaration (function_declarator (field_identifier) @x)) (declaration (function_declarator (identifier) @y))]"))
			  (captures (tsc-query-captures method-query method-node 'tsc--buffer-substring-no-properties)))
	(seq-map (lambda (elem)
			   (tsc-node-text (cdr elem)))
			 captures)))

(defun ue-node-class-method-names (class-node)
  (unless (tsc-node-p class-node)
	(signal 'wrong-type-argument (list 'tsc-node-p class-node)))
  (seq-map (lambda (elem)
			 (ue-node-method-name elem))
		   (ue-node-class-node-methods class-node)))

(defun ue-buffer-method-names (&optional buffer)
  (when (not buffer)
	(setq buffer (current-buffer)))
  (seq-mapcat (lambda (elem)
				(print (tsc-node-text elem) (get-buffer "*scratch*"))
				(ue-node-class-method-names elem))
			  (ue-buffer-node-classes buffer)))

(defun ue-node-class-declaration-names (class-node)
  (unless (tsc-node-p class-node)
	(signal 'wrong-type-argument (list 'tsc-node-p class-node)))
  (let ((class-name (ue-node-class-name class-node))
		(method-names (ue-node-class-method-names class-node)))
	(seq-map (lambda (method-name)
			   (cons class-name method-name))
			 method-names)))

(defun ue-buffer-declaration-names (&optional buffer)
  "Returns a list of pair (class-name . method-name)"
  (when (not buffer)
	(setq buffer (current-buffer)))
  (let ((node-classes (ue-buffer-node-classes buffer)))
	(seq-mapcat (lambda (node-class)
				  (ue-node-class-declaration-names node-class))
				node-classes)))

(defun ue-buffer-node-definitions (&optional buffer)
  (when (not buffer)
	(setq buffer (current-buffer)))
  (with-no-macros-buffer buffer no-macros-buffer
						 (when-let* ((definition-query (tsc-make-query cpp-language "(function_definition) @x"))
									 (root-node (tsc-root-node tree-sitter-tree))
									 (captures (tsc-query-captures definition-query root-node 'tsc--buffer-substring-no-properties)))
						   (seq-map 'cdr captures))))

(defun ue-node-definition-class-name (definition-node)
  (unless (tsc-node-p definition-node)
	(signal 'wrong-type-argument (list 'tsc-node-p definition-node)))
  (when-let* ((definition-class-query (tsc-make-query cpp-language "(function_declarator (qualified_identifier (namespace_identifier) @x))"))		  
			  (captures (tsc-query-captures definition-class-query definition-node 'tsc--buffer-substring-no-properties)))
	(let ((class-node (cdr (elt captures 0))))
	  (tsc-node-text class-node))))

(defun ue-node-definition-method-name (definition-node)
  (unless (tsc-node-p definition-node)
	(signal 'wrong-type-argument (list 'tsc-node-p definition-node)))
  (when-let* ((definition-method-query (tsc-make-query cpp-language "(function_declarator (qualified_identifier (identifier) @x))"))		  
			  (captures (tsc-query-captures definition-method-query definition-node 'tsc--buffer-substring-no-properties)))
	(let ((method-node (cdr (elt captures 0))))
	  (tsc-node-text method-node))))

(defun ue-node-definition-names-and-positions (definition-node)
  "Returns a list of four elements: (class-name method-name start-position end-position)"
  (unless (tsc-node-p definition-node)
	(signal 'wrong-type-argument (list 'tsc-node-p definition-node)))
  (let ((class-name (ue-node-definition-class-name definition-node))
		(method-name (ue-node-definition-method-name definition-node))
		(start-position (tsc-node-start-position definition-node))
		(end-position (tsc-node-end-position definition-node)))
	(list class-name method-name start-position end-position)))

(defun ue-buffer-definition-names-and-positions (&optional buffer)
  (when (not buffer)
	(setq buffer (current-buffer)))
  (seq-map 'ue-node-definition-names-and-positions (ue-buffer-node-definitions buffer)))

(defun ue-definition-points (current-def-names goal-def-names declaration-names)
  (let ((current-def-class (car current-def-names))
		(current-def-method (cdr current-def-names))
		(goal-def-class (car goal-def-names))
		(goal-def-method (cdr goal-def-names))
		(current-points 0)
		(points-multiplier 1)
		(current-names-found nil))
	(while (and (not (null declaration-names))
				(not current-names-found))
	  
	  (let ((declaration-class (caar declaration-names))
			(declaration-method (cdar declaration-names)))
		(cond
		 ((and (string-equal current-def-class declaration-class)
			   (string-equal current-def-method declaration-method))
		  (setq current-names-found t))
		 ((and (string-equal goal-def-class declaration-class)
			   (string-equal goal-def-method declaration-method))
		  (setq points-multiplier -1))
		 (t
		  (setq current-points (+ current-points 1)))))
	  (setq declaration-names (cdr declaration-names)))
	(if current-names-found
		(* current-points points-multiplier)
	  nil)))

(defun ue-best-definition-info (definitions-info goal-def-names declaration-names)
  (let* ((first-def-names (cons (first (car definitions-info)) (second (car definitions-info))))
		 (max-points (ue-definition-points first-def-names goal-def-names declaration-names))
		 (best-definition (car definitions-info))
		 (declaration-names (cdr declaration-names)))
	(while (not (null definitions-info))
	  (let* ((current-def-names (cons (first (car definitions-info)) (second (car definitions-info))))
			 (current-points (ue-definition-points current-def-names goal-def-names declaration-names)))
		(when (and current-points (> current-points max-points))
		  (setq max-points current-points)
		  (setq best-definition (car definitions-info))))
	  (setq definitions-info (cdr definitions-info)))
	(and max-points
		 (cons best-definition max-points))))

(defun ue-best-definition-position (definitions-info goal-def-names declaration-names)
  (let ((best-definition-and-points (ue-best-definition-info definitions-info goal-def-names declaration-names)))
	(and best-definition-and-points
		 (let* ((best-definition (car best-definition-and-points))
				(points (cdr best-definition-and-points))
				(best-start-position (third best-definition))
				(best-end-position (fourth best-definition)))
		   (if (< points 0)
			   best-start-position
			 best-end-position)))))

(defun ue-implement-function-at-point ()
  (interactive)
  (let ((declaration-at-point (ue-)))))

(defun function-declaration-to-implementation (function-str class-name)
  (with-temp-buffer
	(insert function-str)
	(goto-char (point-min))
	(replace-regexp "virtual\\\|override\\\|static\\\|;" "")
	(c++-mode)
	(tree-sitter-mode)
	(let* ((function-name-query (tsc-make-query tree-sitter-language "(function_declarator (identifier) @x)"))
		   (function-captures (tsc-query-captures function-name-query (tsc-root-node tree-sitter-tree) 'tsc--buffer-substring-no-properties))
		   (function-name-position (tsc-node-start-position (cdr (aref function-captures 0)))))
	  (goto-char function-name-position)
	  (insert class-name "::")
	  (goto-char (point-max))
	  (newline)
	  (insert "{" ?\n "}"))
	(buffer-string)))

(defun ue-implement-function-at-point ()
  (interactive)
  (when-let* ((class-name (ue-get-class-at-point))
			  (method-node (ue-method-node-at-point))
			  (method-name (ue-method-name-at-point))
			  (function-implementation (function-declaration-to-implementation (tsc-node-text method-node)))
			  (declaration-names (ue-buffer-declaration-names))
			  (goal-def-names (cons class-name method-name)))
	(projectile-find-other-file)
	(let* ((definitions-info (ue-buffer-definition-names-and-positions))
		   (best-position (ue-best-definition-position definitions-info goal-def-names declaration-names)))
	  (goto-char (or best-position (point-max)))
	  (insert ?\n ?\n function-implementation ?\n ?\n))))

;; ------ csharp-mode ------
(use-package csharp-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

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
  :hook ((lsp . company)
		 (emacs-lisp-mode . company-mode))
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  :config
  (add-to-list 'company-backends '(company-capf :with company-yasnippet))
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 2)
  (setq company-transformers '(company-sort-prefer-same-case-prefix)))


;; ------ semantic refactor ------
;; (use-package srefactor
;;   :hook ((c++-mode . semantic-mode)
;; 		 (c-mode . semantic-mode))
;;   :bind ((:map c++-mode-map ("M-RET" . srefactor-refactor-at-point))
;; 		 (:map c-mode-map ("M-RET" . srefactor-refactor-at-point))))


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


;; ------ code-slider ------
(defvar *code-slider* nil)
(defvar *observed-buffer* nil)
(defvar *chars-per-second* 100)

(defun ensure-code-slider ()
  (setq *code-slider* (get-buffer-create "*code-slider*"))
  (setq *observed-buffer* (get-buffer-create "*observed-buffer*")))

(defun exists-code-slider-p ()
  (and (buffer-live-p *code-slider*) (buffer-live-p *observed-buffer*)))

(defun erase-slider-buffers ()
  (when (exists-code-slider-p)
	(with-current-buffer *code-slider*
	  (erase-buffer))
	(with-current-buffer *observed-buffer*
	  (erase-buffer))))

(defun initialize-code-slider (buffer)
  (ensure-code-slider)
  (erase-slider-buffers)
  (with-current-buffer *observed-buffer*
	(insert-buffer buffer)))

(defun open-code-slider-buffer ()
  (interactive)
  (initialize-code-slider (current-buffer))
  (switch-to-buffer-other-window *code-slider*))

(defun code-slide-to-line (line)
  (interactive "nWhat line?: ")
  (when (and (exists-code-slider-p) (eq *code-slider* (current-buffer)))
    (with-current-buffer *code-slider*
	  (goto-char (point-max))
	  (let ((total-lines (with-current-buffer *observed-buffer*
						   (count-lines (point-min) (point-max)))))
		(while (<= (line-number-at-pos) (min line total-lines))
		  (let ((next-char-position (point-max)))
			(insert-char (with-current-buffer *observed-buffer*
						   (goto-char next-char-position)
						   (following-char)))
			(sit-for (/ 1.0 *chars-per-second*))))
		(while (> (line-number-at-pos) (max line 0))
		  (delete-backward-char 1)
		  (sit-for (/ 1.0 *chars-per-second*)))))))
