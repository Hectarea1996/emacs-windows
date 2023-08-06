;;; uemacs.el --- Minor mode for Unreal Engine projects -*- lexical-binding: t; -*-

(require 'projectile)
(require 'f)


(defun uemacs--project-directory ()
  "Return Unreal Emacs root directory if this file is part of a project."
  (projectile-project-root))

(defun uemacs--project-target-files ()
  "Return a list with the target files of a project."
  (when-let* ((project-root (projectile-project-root))
			  (source-dir (f-join project-root "Source")))
	(f-files source-dir (lambda (file)
						  (let ((ext (f-ext file))
								(pre-ext (f-ext (f-no-ext file))))
							(string-equal (concat pre-ext "." ext) "Target.cs"))))))

(defun uemacs--target-file-name (file)
  "Return the name of a target file."
  (f-base (f-no-ext file)))


(defun uemacs--module-directory ()
  "Return the module of the current file buffer."
  (let ((current-dir (f-parent (buffer-file-name)))
		(module-dir nil))
	(while (and current-dir (not module-dir))
	  (let ((dir-name (f-filename current-dir)))
		(when (f-exists-p (f-join current-dir (concat dir-name ".Build.cs")))
		  (setq module-dir current-dir)))
	  (setq current-dir (f-parent current-dir)))
	module-dir))

(defun uemacs--project-module-files ()
  "Return a list with the module files of a project"
  (when-let* ((project-root (projectile-project-root))
			  (source-dir (f-join project-root "Source"))
			  (module-dirs (f-directories source-dir
										  (lambda (dir)
											(let ((maybe-module-name (f-filename dir)))
											  (f-exists-p (f-join dir
																  (concat maybe-module-name ".Build.cs"))))))))
	(cl-map 'list (lambda (dir)
					(let ((module-name (f-filename dir)))
					  (f-join dir (concat module-name ".Build.cs"))))
			module-dirs)))

(defun uemacs--module-file-name (file)
  "Return the name of a module file."
  (f-base (f-no-ext file)))

(defun uemacs--module-name ()
  "Return the module's name of the current file buffer."
  (uemacs--module-file-name (uemacs--module-directory)))

(defun uemacs--project-module-names ()
  "Return a list with the module's names of the current project."
  (cl-map 'list (lambda (file)
				  (f-base file))
		  (uemacs--project-module-files)))


(defun uemacs--module-exists-p (module-name)
  "Checks whether a module exists."
  (member module-name (uemacs--project-module-names)))


(defun ue-jump-between-header-and-implementation ()
  "Jump between header and source files in the project."
  (interactive)
  (projectile-find-other-file))

(defun ue-compile-project ()
  "Compile project for the current build target.

If there is no target set, prompt user to choose it and then compile."
  (interactive)
  (ue--compile-project))




(defcustom uemacs-keymap-prefix "C-c u"
  "The prefix for uemacs-mode key bindings."
  :type 'string
  :group 'uemacs)

(defun uemacs--key (key)
  (kbd (concat uemacs-keymap-prefix " " key)))

(defmacro uemacs--define-keys (&rest pairs)
  `(list ,(map (lambda (elem)
				 (let ((key (car elem))
					   (func (cadr elem)))
				   `(cons (uemacs--key ,key) ,func)))
			   pairs)))

(defvar ue-mode-map
  (uemacs--define-keys
   ;; Switch between files with the same name but different extensions.
   ;; Use this to switch between header and source files.
   ("a" #'ue-jump-between-header-and-implementation)
   ;; Compile the project for current build target.
   ;; If there is no target set, prompt a user to select one
   ;; and then compile the project.
   ("c" #'ue-compile-project)
   ;; Run the project using the current build target.
   ;; If there is no target set, prompt a user to select one
   ;; and then run the project.
   ("r" #'ue-run-project)
   ;; Generate project files.
   ("g p" #'ue-generate-project)
   ;; Generate a new project class.
   ("n c" #'ue-generate-class)
   ;; Generate a new project interface.
   ("n i" #'ue-generate-interface)
   ;; Generate a new project struct.
   ("n s" #'ue-generate-struct)))

(define-minor-mode uemacs-mode
  "Minor mode for Unreal Engine projects based on `projectile-mode'.

\\{ue-mode-map}"
  :init-value nil
  :lighter    " uemacs"
  :keymap     ue-mode-map
  (when ue-mode
    (ue--register-keywords)
    (ue--register-snippets)
    (ue--activate-snippets)
    (ue--setup-ignore-lists)
    (ue--update-mode-line)))

(defun uemacs-on ()
  "Enable command `uemacs-mode'."
  (uemacs-mode +1))

(defun uemacs-off ()
  "Disable command `uemacs-mode'."
  (uemacs-mode -1))

;;;###autoload
(define-globalized-minor-mode uemacs-global-mode ue-mode ue-on)


(provide 'uemacs)

;;; uemacs.el ends here
