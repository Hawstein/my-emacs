;;========== Shell Mode 更改 Buffer Name 用于显示当前路径

(make-variable-buffer-local 'shell-mode-directory-changed)
(setq shell-mode-directory-changed t)

(defun shell-mode-auto-rename-buffer-output-filter (text)
  (if (and (eq major-mode 'shell-mode)
           shell-mode-directory-changed)
      (progn
        (let ((bn  (concat "sh:" default-directory)))
          (if (not (string= (buffer-name) bn))
              (rename-buffer bn t)))
        (setq shell-mode-directory-changed nil))))


(defun shell-mode-auto-rename-buffer-input-filter (text)
  (if (eq major-mode 'shell-mode)
      (if ( string-match "^[ \t]*cd *" text)
          (setq shell-mode-directory-changed t))))
(add-hook 'comint-output-filter-functions 'shell-mode-auto-rename-buffer-output-filter)
(add-hook 'comint-input-filter-functions 'shell-mode-auto-rename-buffer-input-filter )

;; exit退出后自动关闭Shell的buffer
(add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)
(defun wcy-shell-mode-hook-func  ()
  (set-process-sentinel (get-buffer-process (current-buffer))
                            #'wcy-shell-mode-kill-buffer-on-exit)
      )
(defun wcy-shell-mode-kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))
