;;; ue-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ue" "ue.el" (0 0 0 0))
;;; Generated autoloads from ue.el

(put 'ue-global-mode 'globalized-minor-mode t)

(defvar ue-global-mode nil "\
Non-nil if Ue-Global mode is enabled.
See the `ue-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `ue-global-mode'.")

(custom-autoload 'ue-global-mode "ue" nil)

(autoload 'ue-global-mode "ue" "\
Toggle Ue mode in all buffers.
With prefix ARG, enable Ue-Global mode if ARG is positive; otherwise,
disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Ue mode is enabled in all buffers where `ue-on' would do it.

See `ue-mode' for more information on Ue mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "ue" '("ue-"))

;;;***

;;;### (autoloads nil nil ("ue-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ue-autoloads.el ends here
