(defun ue--yas-can-expand-p ()
  "Check if UE snippet can be expanded"
  (and ue-expand-snippets
       (or (derived-mode-p 'c++-mode)
		   (derived-mode-p 'c-mode))))

(defun ue--component-class-p (class-name)
  (and (> (length class-name) 9)
	   (string= (substring class-name -9 nil) "Component")))

(defun ue--class-properties-from-base-class (class-name)
  (when (ue--component-class-p yas-text)
	"ClassGroup=\"Custom\", meta=(BlueprintSpawnableComponent)"))
