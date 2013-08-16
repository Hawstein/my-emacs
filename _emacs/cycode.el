;;==============================================================
;;gdb-UI配置
;;==============================================================
(setq gdb-many-windows t)
(load-library "multi-gud.el")
(load-library "multi-gdb-ui.el")

;;==================================================
;;cedet插件设置
;;==================================================
(add-to-list 'load-path "~/install/cedet-1.0/speedbar")
(add-to-list 'load-path "~/install/cedet-1.0/eieio")
(add-to-list 'load-path "~/install/cedet-1.0/semantic")
;; Load CEDET.,从cedet的INSTALL中复制过来的
;; See cedet/common/cedet.info for configuration details.
(load-file "~/install/cedet-1.0/common/cedet.el")


;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
;;(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
;;(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberent ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languges only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
 ;;(global-srecode-minor-mode 1)
 
 ;;----------------------------------------------------------------------
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
;;(semantic-load-enable-guady-code-helpers)
;;(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)

(global-ede-mode t)
;;代码折叠
;;(require 'semantic-tag-folding nil 'noerror)
(global-semantic-tag-folding-mode 1)
;;折叠和打开整个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C--") 'semantic-tag-folding-fold-all)
(define-key semantic-tag-folding-mode-map (kbd "C-=") 'semantic-tag-folding-show-all)
;;折叠和打开单个buffer的所有代码
(define-key semantic-tag-folding-mode-map (kbd "C-_") 'semantic-tag-folding-fold-block)
(define-key semantic-tag-folding-mode-map (kbd "C-+") 'semantic-tag-folding-show-block)


;;==============================================================
;;ecb配置
;;==============================================================
;;(require 'ecb)
;;开启ecb用,M-x:ecb-activate
(require 'ecb-autoloads)
;;自动启动ecb并且不显示每日提示
;;(require 'ecb)
;;(setq ecb-auto-activate t)
(setq ecb-tip-of-the-day nil)

(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)


(defun my-c-mode-common-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  ;;; hungry-delete and auto-newline
;;  (c-toggle-auto-hungry-state 1)
  (define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)
 (define-key c-mode-base-map [(return)] 'newline-and-indent)

  (define-key c-mode-base-map [(meta \`)] 'c-indent-command)
;;  (define-key c-mode-base-map [(tab)] 'hippie-expand)
;;  (define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
;;  (define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  (setq hs-minor-mode t)
  (setq abbrev-mode t)
)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(defun my-c++-mode-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  (c-set-style "stroustrup")
;;  (define-key c++-mode-map [f3] 'replace-regexp)
)

;;配置Semantic搜索范围
(setq semanticdb-project-roots
	  (list
	   (expand-file-name "/")))
;;自定义补全命令，如果单词在中间就补全，否则就tab
(defun my-indent-or-complete()
  (interactive)
  (if (looking-at "\\>")
	  (hippie-expand nil)
	  (indent-for-tab-command))
  )
;;补全快捷键，ctrl+tab用senator补全，不显示列表
;;alt+/补全，显示列表让选择
(global-set-key [(control tab)] 'my-indent-or-complete)
(define-key c-mode-base-map [(meta ?/)] 'semantic-ia-complete-symbol-menu)
(autoload 'senator-try-expand-semantic "senator")
(setq hippie-expand-try-functions-list
	  '(
		senator-try-expand-semantic
		try-expand-dabbrev
		try-expand-dabbrev-visible
		try-expand-dabbrev-all-buffers
		try-expand-dabbrev-from-kill
		try-expand-list
		try-expand-list-all-buffers
		try-expand-line
		try-expand-line-all-buffers
		try-complete-file-name-partially
		try-complete-file-name
		try-expand-whole-kill
		)
	  )
;;cc-mode的括号自动匹配
;; (defun my-c-mode-auto-pair ()
;;  (interactive)
;;  (make-local-variable 'skeleton-pair-alist)
;;  (setq skeleton-pair-alist  '(
;;                   (?` ?` _ "''")
;;                   (?\( ?  _ " )")
;; 				  (?\< ?  _ " >")
;;                   (?\[ ?  _ " ]")
;;                   (?{ \n > _ \n ?} >)))
;;  (setq skeleton-pair t)
;;  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "<") 'sleleton-pair-insert-maybe)
;;  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "`") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe))
;; (add-hook 'c-mode-hook 'my-c-mode-auto-pair)
;; (add-hook 'c++-mode-hook 'my-c-mode-auto-pair)

;;单引号自动补全 <自动补全
(setq skeleton-pair-alist  
      '(
        (?\' _ "\'" >)))

(setq skeleton-pair t)

(global-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
;;

;;==========================================================
;;加载cscope
;;==========================================================
(require 'xcscope)

;;==========================================================
;;YASnippet的配置
;;==========================================================
;;太强大了，强大的模板功能
(require 'yasnippet)    ;;not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/install/yasnippet-0.6.1c/snippets")

;;自动补全
;;(require 'auto-complete-config)
;;(ac-config-default)
