;; -*- Emacs-Lisp -*-

;; Time-stamp: <2010-04-10 18:15:15 Saturday by ahei>

(defun diff-settings ()
  "settings for `diff'."
  (eal-define-keys
   'diff-mode-map
   `(("C-k" diff-hunk-kill)
     ("SPC" scroll-up)
     ("'"   switch-to-other-buffer)
     ("Q"   kill-this-buffer)
     ("u"   View-scroll-half-page-backward)))

  (eal-define-keys
   'diff-mode-shared-map
   `(("k" previous-line)
     ("K" roll-up)))

  (setq diff-switches "-w"))

(eval-after-load "diff-mode"
  `(diff-settings))

(provide 'diff-settings)
