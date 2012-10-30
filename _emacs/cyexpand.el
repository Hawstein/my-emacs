
;; 一些基本的小函数
(require 'ahei-misc)
;; 利用`eval-after-load'加快启动速度的库
;; 用eval-after-load避免不必要的elisp包的加载
;; http://emacser.com/eval-after-load.htm
(require 'eval-after-load)

(require 'util)


;; 一些Emacs的小设置, 已经有了
;;(require 'misc-settings)

;; 编码设置
(require 'coding-settings)

;; `mode-line'显示格式
(require 'mode-line-settings)

;; 各种语言开发方面的设置,这个设置牵涉到太多配置....
(require 'dev-settings)


;; 显示行号
(require 'linum-settings)

;; color theme Emacs主题,很多face文件
(require 'color-theme-settings)

(require 'ahei-face)
(require 'color-theme-ahei)
(require 'face-settings)

;; 高亮当前行
(require 'hl-line-settings)

;; 字体配置
(require 'font-settings)
;; diff
(require 'diff-settings)
;; Emacs的diff: ediff,有个my-fontest-win的文件很关键
(require 'ediff-settings)

;; 在buffer中方便的查找字符串: color-moccur
(require 'moccur-settings)
;; Emacs超强的增量搜索Isearch配置
(require 'isearch-settings)

;; 非常酷的一个扩展。可以“所见即所得”的编辑一个文本模式的表格
(if is-before-emacs-21 (require 'table "table-for-21"))

;; 把文件或buffer彩色输出成html
(require 'htmlize)

;; time-stamp, 在文件头记录修改时间, 并动态更新
(require 'time-stamp-settings)

;; Emacs可以做为一个server, 然后用emacsclient连接这个server,
;; 无需再打开两个Emacs
(require 'emacs-server-settings)

(require 'apropos-settings)
(require 'completion-list-mode-settings)

;; 显示ascii表
(require 'ascii)

;; 所有关于查看帮助方面的配置,很多文件
(require 'all-help-settings)

;; 定义一些emacs 21没有的函数
(if is-before-emacs-21 (require 'for-emacs-21))

;; 简写模式
(setq-default abbrev-mode t)
(setq save-abbrevs nil)

;; 可以为重名的buffer在前面加上其父目录的名字来让buffer的名字区分开来，而不是单纯的加一个没有太多意义的序号
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; 以目录形式显示linkd文档
;;(require 'linkd-settings)

;; Emacs的超强文件管理器
(require 'dired-settings)

;; 方便的切换major mode
(defvar switch-major-mode-last-mode nil)

(defun major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun switch-major-mode (mode)
  "切换major mode"
  (interactive
   (let ((fn switch-major-mode-last-mode) val)
     (setq val
           (completing-read
            (if fn (format "切换major-mode为(缺省为%s): " fn) "切换major mode为: ")
            obarray 'major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq switch-major-mode-last-mode last-mode)))
(global-set-key (kbd "C-x q") 'switch-major-mode)

(defun get-mode-name ()
  "显示`major-mode'及`mode-name'"
  (interactive)
  (message "major-mode为%s, mode-name为%s" major-mode mode-name))
(global-set-key (kbd "C-x m") 'get-mode-name)

;; 查看Emacs内进程
(autoload 'list-processes+ "list-processes+" "增强的`list-processes'命令" t)

(require 'view-mode-settings)

(defun revert-buffer-no-confirm ()
  "执行`revert-buffer'时不需要确认"
  (interactive)
  (when (buffer-file-name)
    (let ((emaci emaci-mode))
      (revert-buffer buffer-file-name t)
      (emaci-mode (if emaci 1 -1)))))
(eal-define-keys-commonly
 global-map
 `(("C-x u"   revert-buffer-no-confirm)
   ("C-x M-K" revert-buffer-with-gbk)
   ("C-x U"   revert-buffer-with-coding-system-no-confirm-sb)))

(defun count-brf-lines (&optional is-fun)
  "显示当前buffer或region或函数的行数和字符数"
  (interactive "P")
  (let (min max)
    (if is-fun
        (save-excursion
          (beginning-of-defun) (setq min (point))
          (end-of-defun) (setq max (point))
          (message "当前函数%s内共有%d行, %d个字符" (which-function) (count-lines min max) (- max min)))
      (if mark-active
          (progn
            (setq min (min (point) (mark)))
            (setq max (max (point) (mark))))
        (setq min (point-min))
        (setq max (point-max)))
      (if (or (= 1 (point-min)) mark-active)
          (if mark-active
              (message "当前region内共有%d行, %d个字符" (count-lines min max) (- max min))
            (message "当前buffer内共有%d行, %d个字符" (count-lines min max) (- max min)))
        (let ((nmin min) (nmax max))
          (save-excursion
            (save-restriction
              (widen)
              (setq min (point-min))
              (setq max (point-max))))
          (message "narrow下buffer内共有%d行, %d个字符, 非narrow下buffer内共有%d行, %d个字符"
                   (count-lines nmin nmax) (- nmax nmin) (count-lines min max) (- max min)))))))
(eal-define-keys-commonly
 global-map
 `(("C-x l" count-brf-lines)
   ("C-x L" (lambda () (interactive) (count-brf-lines t)))))

;; 增加更丰富的高亮
(require 'generic-x)

;; spell check
(setq-default ispell-program-name "aspell")

;; Emacs中的包管理器
(require 'package)
(package-initialize)

;; 在Emacs里面使用shell
(require 'term-settings)
(require 'multi-term-settings)

;; 可以把光标由方块变成一个小长条
(require 'bar-cursor)

(defun goto-my-emacs-lisps-dir ()
  "Goto `my-emacs-lisps-path'."
  (interactive)
  (dired my-emacs-lisps-path))
(defun goto-my-emacs-my-lisps-dir ()
  "Goto `my-emacs-my-lisps-path'."
  (interactive)
  (dired my-emacs-my-lisps-path))
(defun goto-my-emacs-dir ()
  "Goto `my-emacs-path'."
  (interactive)
  (dired my-emacs-path))
(defun goto-my-home-dir ()
  "Goto my home directory."
  (interactive)
  (dired "~"))
(define-key-list
 global-map
 `(("C-x G l" goto-my-emacs-lisps-dir)
   ("C-x G m" goto-my-emacs-my-lisps-dir)
   ("C-x G e" goto-my-emacs-dir)
   ("C-x M-H" goto-my-home-dir)))

(define-key global-map (kbd "C-x M-c") 'describe-char)

;; 启动Emacs的时候最大化Emacs
(require 'maxframe-settings)

(defun dos2unix ()
  "dos2unix on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'unix))

(defun unix2dos ()
  "unix2dos on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'dos))

(define-key global-map (kbd "C-x M-D") 'dos2unix)

(define-key-list
 global-map
 `(("C-x M-k" Info-goto-emacs-key-command-node)
   ("C-x ESC ESC" repeat-complex-command-sb)))

;; Emacs才是世界上最强大的IDE － 智能的改变光标形状
;; http://emacser.com/cursor-change.htm
(require 'cursor-change)
(cursor-change-mode 1)

;; 大纲mode
(require 'outline-settings)

;; 关闭buffer的时候, 如果该buffer有对应的进程存在, 不提示, 烦
(delq 'process-kill-buffer-query-function kill-buffer-query-functions)

;; 王纯业的desktop, 比desktop快多了,保留上次关闭时的buffer
;;(require 'wcy-desktop-settings)

;;(require 'zjl-hl-settings)
