
;; ------ Automatic emacs lines -------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dde643b0efb339c0de5645a2bc2e8b4176976d5298065b8e6ca45bc4ddf188b7" "3199be8536de4a8300eaf9ce6d864a35aa802088c0925e944e2b74a574c68fd0" "a0415d8fc6aeec455376f0cbcc1bee5f8c408295d1c2b9a1336db6947b89dd98" default))
 '(package-selected-packages
   '(exwm dirtrack ivy slime avy markdown-mode flycheck-pkg-config undo-tree ivy-xref dumb-jump flycheck modern-cpp-font-lock auto-complete pdf-continuous-scroll-mode pdf-tools paredit parinfer-rust multiple-cursors cmake-mode which-key use-package spacemacs-theme solo-jazz-theme solarized-theme rainbow-delimiters projectile parinfer-rust-mode one-themes modus-themes ivy-rich helpful doom-themes doom-modeline counsel))
 '(undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; ------ Initial frame maximized ------
(add-to-list 'initial-frame-alist '(fullscreen . maximized))


;; ------ Emacs editor changes ------
(setq inhibit-startup-message t)                             ; Disable startup message
(menu-bar-mode -1)                                           ; Disable the menu bar
(scroll-bar-mode -1)                                         ; Disable visible scrollbar
(tool-bar-mode -1)                                           ; Disable the toolbar
(tooltip-mode -1)                                            ; Disable tooltips
(set-fringe-mode 10)                                         ; Give some breathing room
(switch-to-buffer "new-file" nil t)                          ; The initial buffer should be an empty buffer
(add-to-list 'initial-frame-alist '(fullscreen . maximized)) ; Initialize emacs maximized
(setq frame-resize-pixelwise t)
(setq indent-tabs-mode nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(delete-selection-mode 1)
(global-set-key (kbd "C-c d") 'delete-pair)
(set-face-attribute 'default nil :height 100)
(global-set-key (kbd "M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<left>") 'shrink-window-horizontally)

;; ----- Emacs backup and autosave files -----
(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups/" user-emacs-directory))))             ; Put backup files (ie foo~) in ~/.emacs.d/.
(make-directory (expand-file-name "tmp/auto-saves/" user-emacs-directory) t)                                 ; create the autosave dir if necessary, since emacs won't.
(setq auto-save-list-file-prefix (expand-file-name "tmp/auto-saves/sessions/" user-emacs-directory)
      auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/auto-saves/" user-emacs-directory) t))) ; Put autosave files (ie #foo#) in ~/.emacs.d/ (I think)


;; ------ Scrolling ------
(setq mouse-wheel-scroll-amount '(2 ((shift) . 5) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(defun custom-scroll-up ()
  "Scroll up 3 lines."
  (interactive)
  (scroll-up 3))

(defun custom-scroll-down ()
  "Scroll down 3 lines."
  (interactive)
  (scroll-down 3))

(global-set-key (kbd "<M-up>") 'custom-scroll-down)
(global-set-key (kbd "<M-down>") 'custom-scroll-up)


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
(use-package modus-themes
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))
  :bind ("<f5>" . modus-themes-toggle))
(load-theme 'modus-vivendi)

;; ------- Doom modeline -------
(use-package doom-modeline
  :init (doom-modeline-mode 1))


;; ----- cl-lib -----
(require 'cl-lib)

;; ----- thing at point -----
(require 'thingatpt)


;; ----- Undo tree -----
(use-package undo-tree
  :bind (("C-x u" . undo-tree-visualize)
	 ("C-/" . custom-undo-tree-undo)
	 ("C-?" . undo-tree-redo)))

(defun activate-undo-tree-on-window-change (window-or-frame)
  "Activate undo-tree when entering at WINDOW-OR-FRAME."
  (when (or (not (boundp 'undo-tree-mode)) (not undo-tree-mode))
    (undo-tree-mode t)))

(setq window-selection-change-functions (cons #'activate-undo-tree-on-window-change window-selection-change-functions))
;(add-to-list 'undo-tree-history-directory-alist `("." . ,(expand-file-name "undo-tree-history/" user-emacs-directory)))


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


;; ------ Ivy rich ------
(use-package ivy-rich
  :init (ivy-rich-mode 1))


;; ------ Counsel ------
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
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


;; ----- Custom project manager -----
(defvar project-regex-marks '("\\.git$"))
(defvar project-search-for-marks-from '("C:/Users/hecto/Documents/Unreal Projects"))
(defvar initial-project-directories '())
(defvar project-directories nil)
(defvar project-file-regex '("\\.h$"
			     "\\.c$"
			     "\\.hpp$"
			     "\\.cpp$"
			     "\\.lisp$"
			     "\\.asd$"
			     "\\.asd$"
			     "\\.md$"
			     "\\.el$"
			     "\\.emacs$"))
(defvar project-cache-file "~/.emacs.d/project-files-cache")

(defmacro measure-time (&rest body)
  (let ((time (make-symbol "time"))
	(result (make-symbol "result")))
    `(let ((,time (current-time)))
       (let ((result (progn
		       ,@body)))
	 (list (time-to-seconds (time-subtract (current-time) ,time)) result)))))

(defun read-projects-cache ()
  (let ((file-buffer (find-file-noselect project-cache-file :nowarn t)))
    (prog1
	(if (equal (buffer-size file-buffer) 0)
	    nil
	  (read file-buffer))
      (kill-buffer file-buffer))))

(defun print-projects-cache (assoc-directories)
  (let ((cache (find-file-noselect project-cache-file)))
    (with-current-buffer cache
      (erase-buffer)
      (print assoc-directories cache)
      (save-buffer)
      (kill-buffer))))

(defun get-cache-data-project-files (dir assoc-directories)
  (let ((found-files nil)
	(rest-directories assoc-directories))
    (while (and (not found-files) (not (null rest-directories)))
      (let ((current-directory (caar rest-directories)))
	(when (equal current-directory dir)
	  (setq found-files (cadar rest-directories)))
	(setq rest-directories (cdr rest-directories))))
    found-files))

(defun add-cache-data-project-files (dir files assoc-directories)
  (if (null assoc-directories)
      (list (list dir files))
    (let ((current-project (car assoc-directories)))
      (if (equal dir (car current-project))
	  (cons (list dir files) (cdr assoc-directories))
	(cons current-project (add-directory-files dir files (cdr assoc-directories)))))))

(defun remove-cache-data-project-files (dir assoc-directories)
  (if (null assoc-directories)
      nil
    (let ((current-project (car assoc-directories)))
      (if (equal dir (car current-project))
	  (cdr assoc-directories)
	(cons current-project (remove-project-assoc dir (cdr assoc-directories)))))))

(defun add-cache-project-files (dir files)
  (let* ((old-data (read-projects-cache))
	 (new-data (add-cache-data-project-files dir files old-data)))
    (print-projects-cache new-data)))

(defun delete-cache-project-files (dir)
  (let* ((old-data (read-projects-cache))
	 (new-data (remove-cache-data-project-files dir old-data)))
    (print-projects-cache new-data)))

(defun project-search-marks ()
  (let ((all-marked-projects nil))
    (dolist (dir project-search-for-marks-from all-marked-projects)
      (let ((marked-projects (apply #'append (mapcar (lambda (regex-mark)
						       (mapcar #'file-name-directory (directory-files-recursively dir regex-mark t)))
						     project-regex-marks))))
	(setq all-marked-projects (append marked-projects all-marked-projects))))))

(defun priorize-project-directory (dir)
  (setq project-directories (cons dir (remove dir project-directories))))

(defun update-project-directories ()
  (setq project-directories (append initial-project-directories (project-search-marks))))

(defun get-files-recursively (dir pat &optional abs)
  "Return the list of files under the directory DIR whose name matches PAT.
If ABS is non-nil, the path will be absolute, otherwise relative."
  (let (files)
    (cl-labels ((aux (dir path rel-dir)
                     (let ((cur-dir (expand-file-name rel-dir dir)))
                       (dolist (name (directory-files cur-dir nil nil t))
			 (unless (member name '("." ".."))
                           (let ((fn (expand-file-name name cur-dir))
				 (rel-name (if (string= "" rel-dir)
					       name
                                             (concat rel-dir "/" name))))
                             (cond
                              ((file-directory-p fn)
                               (aux dir pat rel-name))
                              ((string-match pat name)
                               (push (if abs
					 (expand-file-name rel-name dir)
				       rel-name)
				     files)))))))))
      (aux dir pat "")
      files)))

(defun get-project-files (dir &optional abs no-cache)
  (let ((cached-files (if no-cache
			  nil
			(get-cache-data-project-files dir (read-projects-cache)))))
    (if cached-files
	cached-files
      (let* ((combined-regex (let ((current-regex (car project-file-regex)))
			       (dolist (regex (cdr project-file-regex) current-regex)
				 (setq current-regex (concat current-regex "\\|" regex)))))
	     (time-and-result (measure-time (get-files-recursively dir combined-regex)))
	     (time (car time-and-result))
	     (files (cadr time-and-result)))
	(when (> time 1.0)
	  (add-cache-project-files dir files))
	files))))

(defun project-parent-directory (file)
  (if (equal file "/")
      nil
      (file-name-directory (directory-file-name file))))

(defun get-current-project ()
  (let ((file (buffer-file-name)))
    (when file
      (setq file (expand-file-name file))
      (let ((parent-dir (project-parent-directory file))
	    (dir-found nil)
	    (directories (mapcar (lambda (dir)
				   (expand-file-name (file-name-as-directory dir)))
				 project-directories)))
	(while (and (not dir-found) parent-dir)
	  (setq dir-found (car (member parent-dir directories)))
	  (setq parent-dir (project-parent-directory parent-dir)))
	dir-found))))

(defun select-project-file-no-cache (&optional dir)
  (interactive)
  (select-project-file dir t))

(defun get-cached-projects ()
  (interactive)
  (mapcar #'car (read-projects-cache)))

(defun clear-project-cache ()
  (interactive)
  (ivy-read "Select a project to clear its cache: " (get-cached-projects)
	    :action (lambda (dir)
		      (delete-cache-project-files dir))
	    :require-match t))

(defun select-project-file (&optional dir no-cache)
  (interactive)
  (unless dir
    (setq dir (get-current-project)))
  (if dir
      (ivy-read "Select a file: " (get-project-files dir nil no-cache)
		:action (lambda (rel-path)
			  (find-file (expand-file-name rel-path dir)))
		:require-match nil)
    (select-project-and-file)))

(defun select-project ()
  (interactive)
  (ivy-read "Select a project: " project-directories
	    :action (lambda (dir)
		      (priorize-project-directory dir)
		      dir)
	    :require-match t))

(defun select-project-and-file ()
  (interactive)
  (ivy-read "Select a project: " project-directories
	    :action (lambda (dir)
		      (priorize-project-directory dir)
		      (select-project-file dir))
	    :require-match t))

(update-project-directories)
(global-set-key (kbd "C-c p p") 'select-project-and-file)
(global-set-key (kbd "C-c p f") 'select-project-file)


;; ----- word at near files -----
(defun parent-directory (dir &optional times)
  (unless times
    (setq times 2))
  (let ((current-dir dir))
    (while (and (> times 0) (directory-file-name (file-name-directory (directory-file-name current-dir))))
      (setq current-dir (directory-file-name (file-name-directory (directory-file-name current-dir))))
      (setq times (1- times)))
    current-dir))

(defun files-with-thing (thing up-levels)
  (let ((dir (parent-directory (buffer-file-name) up-levels)))
    (let* ((file-list nil)
	   (combined-regex (let ((current-regex (car project-file-regex)))
			     (dolist (regex (cdr project-file-regex) current-regex)
			       (setq current-regex (concat current-regex "\\|" regex)))))
	   (project-files (directory-files-recursively dir combined-regex))
	   (total-files (length project-files))
	   (processed-files 0))
      (dolist (file project-files file-list)
	(with-temp-buffer
	  (insert-file-contents file nil nil nil t)
	  (goto-char (point-max))
	  (let ((next-pos (word-search-backward thing nil t)))
	    (while next-pos
	      (let ((line (thing-at-point 'line)))
		(setq file-list (cons
				 (format "%-10d | %s | %s"
					 next-pos
					 (let* ((thing-length (length thing))
						(init-pos (string-match (format ".\\{,%d\\}%s" (/ (- 100 thing-length) 2) thing) line)))
					   (seq-take (concat (seq-drop (seq-take line (1- (length line))) init-pos) (make-string 100 32)) 100))
					 file)
				    file-list)))
	      (setq next-pos (word-search-backward thing nil t)))))
	(setq processed-files (1+ processed-files))
	(message "%d%%" (truncate (* 100.0 (/ (float processed-files) total-files))))))))

(defvar initial-window nil)
(defvar initial-buffer nil)
(defvar initial-position nil)

(defun save-initial-place ()
  (setq initial-window (get-buffer-window))
  (setq initial-buffer (current-buffer))
  (setq initial-position (point)))

(defun restore-initial-place ()
  (when (and initial-buffer initial-position)
    (switch-to-buffer initial-buffer)
    (goto-char initial-position)))

(defun read-position (str)
  (string-to-number (seq-take str 10)))

(defun read-file (str)
  (let ((digits (seq-position str 32)))
    (seq-drop str (+ (max digits 10) 106))))

(defun close-last-visited-file (file closep thing)
  (when file
    (with-current-buffer (get-file-buffer file)
      (hi-lock-unface-buffer thing)
      (when closep
	(kill-buffer)))))

(defun goto-word-at-file (pos file thing)
  (with-selected-window initial-window
    (let ((enable-local-variables nil))
      (find-file file))
    (goto-char pos)
    (hi-lock-face-buffer thing 'hi-yellow)))

(defun select-files-with-thing-at-point (up-levels)
  (interactive "p")
  (unless up-levels
    (setq up-levels 2))
  (unless (> up-levels 0)
    (setq up-levels 1))
  (let ((thing (thing-at-point 'word))
	(line (thing-at-point 'line)))
    (when (not thing)
      (user-error "No word at point"))
    (let ((current-point (car (bounds-of-thing-at-point 'word)))
	  (current-file (buffer-file-name))
	  (files-with-thing (files-with-thing thing up-levels)))
      (if files-with-thing
	  (progn
	    (save-initial-place)
	    (let ((option-selected nil)
		  (last-visited-file nil)
		  (close-after-leave nil))
	      (ivy-read "Select a file where thing is found: " files-with-thing
			:action (lambda (entry)
				  (setq option-selected t)
				  (select-window initial-window)
				  (let* ((word-file (read-file entry))
					 (word-position (read-position entry)))
				    (switch-to-buffer (find-file word-file))
				    (goto-char word-position)))
			:update-fn (lambda ()
				     (let ((entry (ivy-state-current ivy-last)))
				       (when (and entry (> (length entry) 0))
					 (let* ((word-file (read-file entry))
						(word-position (read-position entry)))
					   (when (not (equal word-file last-visited-file))
					     (close-last-visited-file last-visited-file close-after-leave thing)
					     (setq last-visited-file word-file)
					     (setq close-after-leave (not (get-file-buffer word-file))))
					   (goto-word-at-file word-position word-file thing)))))
			:preselect (format "%-10d | %s | %s"
					   current-point
					   (let* ((thing-length (length thing))
						  (init-pos (string-match (format ".\\{,%d\\}%s" (/ (- 100 thing-length) 2) thing) line)))
					     (seq-take (concat (seq-drop (seq-take line (1- (length line))) init-pos) (make-string 100 32)) 100))
					   current-file)
			:unwind (lambda ()
				  (close-last-visited-file last-visited-file close-after-leave thing)
				  (when (not option-selected)
				    (restore-initial-place)))
			:require-match t)))
	(message "Thing not found in any file")))))

(global-set-key (kbd "C-c p .") 'select-files-with-thing-at-point)


;; ------- Multiple cursors -------
(defvar mc/cmds-to-run-for-all nil)
(defvar mc/cmds-to-run-once nil)
(defvar mc--default-cmds-to-run-for-all nil)
(defvar mc--default-cmds-to-run-once nil)
(use-package multiple-cursors
  :config (setq mc/cmds-to-run-for-all nil))
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


;; ----- Shell -----
(global-set-key (kbd "C-c t") 'shell)


;; ----- UE4Editor -----
;; (defvar ue4-projects '())
;; (defvar ue4-editor nil)
(defvar ue5-projects '(("ProceduralTest" "C:/Users/hecto/Documents/Unreal Projects/ProceduralTest")))
(defvar ue5-editor "C:/Users/hecto/Documents/GitHub/UnrealEngine/Engine/Binaries/Win64/UnrealEditor.exe")


;; (defun get-ue4-projects ()
;;   (mapcar #'car ue4-projects))

;; (defun get-ue4-project-directory (project)
;;   (let ((project-found nil)
;; 	(rest-ue4-projects ue4-projects))
;;     (while (and (not project-found) (not (null rest-ue4-projects)))
;;       (let ((current-project (caar rest-ue4-projects)))
;; 	(when (equal current-project project)
;; 	  (setq project-found (cadar rest-ue4-projects)))
;; 	(setq rest-ue4-projects (cdr rest-ue4-projects))))
;;     (directory-file-name project-found)))

;; (defun ue4-compile-project ()
;;   (interactive)
;;   (ivy-read "Select UE4 project: " (get-ue4-projects)
;; 	    :require-match t
;; 	    :action (lambda (project)
;; 		      (if (y-or-n-p (concat "Do you really want to compile " project "?"))
;; 			  (let ((project-dir (get-ue4-project-directory project)))
;; 			    (unless project-dir
;; 			      (error "Project '%s' not found" project))
;; 			    (let* ((makefile (concat project-dir "/Makefile"))
;; 				   (command (concat "make -f" makefile " " project "Editor")))
;; 			      (async-shell-command command)))
;; 			(ue4-compile-project)))))

;; (defun ue4-open-project ()
;;   (interactive)
;;   (ivy-read "Select UE4 project: " (get-ue4-projects)
;; 	    :require-match t
;; 	    :action (lambda (project)
;; 		      (if (y-or-n-p (concat "Do you really want to open " project "?"))
;; 			  (let ((project-dir (get-ue4-project-directory project)))
;; 			    (unless project-dir
;; 			      (error "Project '%s' not found" project))
;; 			    (let* ((uproject (concat project-dir "/" project ".uproject"))
;; 				   (command (concat ue4-editor " " uproject)))
;; 			      (async-shell-command command)))
;; 			(ue4-open-project)))))

;; (defun ue4-run-editor ()
;;   (interactive)
;;   (if (y-or-n-p "Do you really want to open the Unreal Engine 4 editor?")
;;       (async-shell-command ue4-editor)))


(defun get-ue5-projects ()
  (mapcar #'car ue5-projects))

(defun get-ue5-project-directory (project)
  (let ((project-found nil)
	(rest-ue5-projects ue5-projects))
    (while (and (not project-found) (not (null rest-ue5-projects)))
      (let ((current-project (caar rest-ue5-projects)))
	(when (equal current-project project)
	  (setq project-found (cadar rest-ue5-projects)))
	(setq rest-ue5-projects (cdr rest-ue5-projects))))
    (directory-file-name project-found)))

(defun ue5-compile-project (&optional cleanp)
  (interactive)
  (ivy-read "Select UE5 project: " (get-ue5-projects)
	    :require-match t
	    :action (lambda (project)
		      (let ((project-dir (get-ue5-project-directory project)))
			(unless project-dir
			  (error "Project '%s' not found" project))
			(if (y-or-n-p (concat "Do you really want to " (if cleanp "clean and " "") "compile " project "?"))
			    (let ((compile-command (concat "C:/Users/hecto/Documents/GitHub/UnrealEngine/Engine/Build/BatchFiles/RunUAT.bat BuildEditor -project=\"" project-dir "/" project ".uproject\"")))
			      (if cleanp
				  (let ((clean-command (concat "C:/Users/hecto/Documents/GitHub/UnrealEngine/Engine/Build/BatchFiles/Clean.bat -Target=\"" project
							       "Editor Win64 Development\" -Project=\"" project-dir "/" project ".uproject -WaitMutex -FromMSBuild\"")))
				    (async-shell-command (concat clean-command " && " compile-command)))
				(async-shell-command compile-command)))
			  (ue5-compile-project))))))

(defun ue5-clean-compile-project ()
  (interactive)
  (ue5-compile-project t))

(defun ue5-open-project ()
  (interactive)
  (ivy-read "Select UE5 project: " (get-ue5-projects)
	    :require-match t
	    :action (lambda (project)
		      (if (y-or-n-p (concat "Do you really want to open " project "?"))
			  (let ((project-dir (get-ue5-project-directory project)))
			    (unless project-dir
			      (error "Project '%s' not found" project))
			    (let* ((uproject (concat "\"" project-dir "/" project ".uproject" "\""))
				   (command (concat ue5-editor " " uproject)))
			      (async-shell-command command)))
			(ue5-open-project)))))


(defun ue5-run-editor ()
  (interactive)
  (if (y-or-n-p "Do you really want to open the Unreal Engine 5 editor?")
      (async-shell-command ue5-editor)))
