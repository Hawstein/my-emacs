;;===========================================================
;;键绑定
;;===========================================================

;;============================================================
;;必备扩展kkkk
;;============================================================
;;-----------------redo
(require 'redo)
(global-set-key ( kbd "C-;") 'redo)

;;(global-set-key [f1] 'manual-entry)
;;(global-set-key [C-f1] 'info )

;;f3为查找字符串,alt+f3关闭当前缓冲区
;;(global-set-key [f3] 'grep-find)
(global-set-key [f3] 'kill-this-buffer)

;;.emacs中设一个speedbar的快捷键
(global-set-key [(f4)] 'speedbar-get-focus)
;;ctrl-f4,激活,ecb
(global-set-key [C-f4] 'ecb-activate)

;;F7显示/隐藏工具栏 方便调试
(global-set-key [f7] 'tool-bar-mode)
;;ctrl-F5显示/隐藏菜单栏 ;; M-x menu-bar-open
(global-set-key [C-f7] 'menu-bar-mode)

(global-set-key [f6] 'gdb)
;;shell shortcut
(global-set-key [C-f6] 'shell)

;;  C-f5, 设置编译命令; f5, 保存所有文件然后编译当前窗口文件
;; (defun du-onekey-compile ()
;;   "Save buffers and start compile"
;;   (interactive)
;;   (save-some-buffers t)
;;   (switch-to-buffer-other-window "*compilation*")
;;   (compile compile-command))
  
;; (setq-default compile-command "make")    
;; (global-set-key [f5] 'compile)
;; (global-set-key [C-f5] 'du-onekey-compile)
(defun onekey-compile ()
   "Compile current buffer"
  (interactive)
  (let (filename suffix progname compiler)
    (setq filename (file-name-nondirectory buffer-file-name))
    (setq progname (file-name-sans-extension filename))
    (setq suffix (file-name-extension filename))
    (if (or (string= suffix "c") (string= suffix "C")) (setq compiler (concat "gcc -g -o " progname " ")))
    (if (or (or (string= suffix "cc") (string= suffix "cpp")) (string= suffix "CPP")) (setq compiler (concat "g++ -g -o " progname " ")))
    (if (string= suffix "tex") (setq compiler "latex "))
	(if (string= suffix "py") (setq compiler "python "))
	(if (string= suffix "java") (setq compiler "javac "))
    (compile (concat compiler filename))))

(defun onekey-run ()
  "run the program"
  (interactive)
  (let (filename progname cmd suffix))
  (setq filename (file-name-nondirectory buffer-file-name))
  (setq progname (file-name-sans-extension filename))
  (setq suffix (file-name-extension filename))
  (if (string= suffix "java")
	  (setq cmd (concat "java " progname))
	(setq cmd (concat "./" progname)))
  (shell-command cmd)
  )

(global-set-key [f5] 'onekey-compile)
(global-set-key [C-f5] 'onekey-run)


;;目的是开一个shell的小buffer，用于更方便地测试程序(也就是运行程序了)，我经常会用到。
;;f8就是另开一个buffer然后打开shell，C-f8则是在当前的buffer打开shell,shift+f8清空eshell
(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))
(defun my-eshell-clear-buffer ()
  "Eshell clear buffer."
  (interactive)
  (let ((eshell-buffer-maximum-lines 0))
    (eshell-truncate-buffer)))
(global-set-key [(f8)] 'open-eshell-other-buffer)
(global-set-key [C-f8] 'eshell)
(global-set-key [S-f8] 'my-eshell-clear-buffer)

;;设置[C-f9]为调用dired命令
;;f9在其他窗口之间旋转
(global-set-key [C-f9] 'dired)
(global-set-key [f9] 'other-window)

;;注释区域与取消注释
(global-set-key [f10] 'comment-region)
(global-set-key [C-f10] 'uncomment-region)
;;设置F11快捷键指定Emacs 的日历系统
(global-set-key [S-f11] 'calendar) 

;;设置C-F12 快速察看日程安排
;;F12调到函数定义
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [C-f12] 'list-bookmarks)
;;shift-f12跳回去
(global-set-key [S-f12]
	(lambda ()
	(interactive)
	(if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
	(error "Semantic Bookmark ring is currently empty"))
	(let* ((ring (oref semantic-mru-bookmark-ring ring))
	(alist (semantic-mrub-ring-to-assoc-list ring))
	(first (cdr (car alist))))
	(if (semantic-equivalent-tag-p (oref first tag)
	(semantic-current-tag))
	(setq frist (cdr (car (cdr alist)))))
	(semantic-mrub-switch-tags first))))

;;==================ecb的配置=================================
;;为了ecb窗口的切换
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
;;隐藏和显示ecb窗口
(global-set-key [f11] 'ecb-hide-ecb-windows)
(global-set-key [C-f11] 'ecb-show-ecb-windows)



;;设置M-g为goto-line
(global-set-key (kbd "M-g") 'goto-line)

;;取消control+space键设为mark
(global-set-key (kbd "C-SPC") 'nil)

;;这样 我就不用按 C-@ 来 setmark 了, C-@ 很不好按。
(global-set-key (kbd "M-<SPC>") 'set-mark-command)


;;设置home键指向buffer开头，end键指向buffer结尾
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
;; "C-,"设为屏幕左移命令
(global-set-key (kbd "C-,") 'scroll-left)
;; "C-."设为屏幕右移命令
(global-set-key (kbd "C-.") 'scroll-right)


;;C-z 设置标记
;;(global-set-key (kbd "C-z") 'set-mark-command)
;;关闭当前窗口,alt+4
;;(global-set-key (kbd "M-4") 'delete-window)
;;(global-set-key (kbd "M-4") 'kill-this-buffer)
;;关闭其他窗口,alt+1
(global-set-key (kbd "M-1") 'delete-other-windows)
;;水平分割窗口,alt+2
(global-set-key (kbd "M-2") 'split-window-vertically)
;;垂直分割窗口,alt+3
(global-set-key (kbd "M-3") 'split-window-horizontally)
;;切换到其他窗口，alt+0
(global-set-key (kbd "M-0") 'other-window)
;;显示缓冲区完整名称
(global-set-key (kbd "M-5") 'display-buffer-name)

;;================================================================
;;;;;;;;;;;;;;;;;;;;;;;;;;;自动插入括号;;;;;;;;;;;;;;
;;(show-paren-mode t)
;;(setq skeleton-pair t)
;;(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;;(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
;;(global-set-key (kbd  "{") 'skeleton-pair-insert-maybe)
;;(global-set-key (kbd "<" ) 'skeleton-pair-insert-maybe)
;;(global-set-key (kbd "“" ) 'skeleton-pair-insert-maybe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;直接Ctrl＋回车 进入新的一行，光标不必在行尾
(global-set-key [M-return] '(lambda () 
(interactive) 
(move-end-of-line 1) 
(newline-and-indent))) 

;;重新定义 下一个buffer和上一个buffer的快捷键
(global-set-key [C-right] 'next-buffer)
(global-set-key [C-left] 'previous-buffer)
