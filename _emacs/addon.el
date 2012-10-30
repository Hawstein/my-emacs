;;========== hl-line
(require 'hl-line)
;;(hl-line-mode -1)
;;(global-hl-line-mode -1)
;; for hight line mode
(or (facep 'my-hl-line-face) (make-face 'my-hl-line-face))
(setq hl-line-face 'my-hl-line-face)
(face-spec-set 'my-hl-line-face '((t (
                                      :background "DodgerBlue3"
                                                  ;;:bold
                                                  ;;:weight nil
                                      :inverse-video nil
                                      ))))
(defun color-theme-adjust-hl-mode-face()
  "interactive"
  (let* ((color  (x-color-values (face-attribute 'default :background))))
    (if (null color)
        (error "not support.")
      (let ((my-color (mapcar
                       (lambda (x)
                         (let ((y (/ #XFFFF 4))
                               (delta #X18FF))
                           (cond
                            ((< x (* y 1))
                             (+ x delta))
                            ((< x (* y 2))
                             (+ x delta))
                            ((< x (* y 3))
                             (- x delta))
                            (t
                             (- x delta)))))
                       color)))
        (message "%S %S" color my-color)
        (set-face-attribute
         'my-hl-line-face nil
         :background
         (concat "#"
                 (mapconcat
                  (lambda (c) (format "%04X" c))
                  my-color
                  "")))))))
(color-theme-adjust-hl-mode-face)


;;---------- 
(require 'rect-mark)

;;---------- setnu
(require 'setnu)

;;---------- RST
(require 'rst)
(add-hook 'text-mode-hook 'rst-text-mode-bindings)


(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
                 ("\\.rest$" . rst-mode)) auto-mode-alist))

(add-hook 'rst-adjust-hook 'rst-toc-insert-update)

;;========== buffer name
(load "shell-buffer.el")

;;---------- tabbar
(require 'tabbar)
(tabbar-mode)
(global-set-key (kbd "s-3") 'tabbar-backward-group)
(global-set-key (kbd "s-4") 'tabbar-forward-group)
(global-set-key (kbd "s-1") 'tabbar-backward)
(global-set-key (kbd "s-2") 'tabbar-forward)
;; 新建default组
(load "tabbar-group")



