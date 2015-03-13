; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;  these packages are requied: auto-complete, color-theme, anything
;; ------------------------------------------------------------------------
;; @ load-path

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
;(add-to-load-path "elisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; encode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 基本キーバインド
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
(define-key global-map (kbd "M-?") 'help-for-help)        ; ヘルプ
(define-key global-map (kbd "C-z") 'undo)                 ; undo
(define-key global-map (kbd "C-x /") 'undo)               ; undo
(define-key global-map (kbd "C-c i") 'indent-region)      ; インデント
;(define-key global-map (kbd "C-c C-i") 'hippie-expand)   ; 補完
(define-key global-map (kbd "C-c ;") 'comment-dwim)       ; コメントアウト
(define-key global-map (kbd "C-c :") 'uncomment-region)   ; コメント解除
;(define-key global-map (kbd "C-o") 'toggle-input-method) ; 日本語入力切替
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-q") 'suspend-emacs) ; suspend

;; Stop Auto Backup
(setq make-backup-files nil)
(setq auto-save-default nil)

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
       :foreground "#800"
       :height 0.9)

;; 行番号フォーマット
(setq linum-format "%4d| ")


;; 括弧の範囲内を強調表示
;(show-paren-mode t)
;(setq show-paren-delay 0)
;(setq show-paren-style 'expression)

;; 括弧の範囲色
;(set-face-background 'show-paren-match-face "#111")

;; 対応する括弧を光らせる
(show-paren-mode 1)

;(set-cursor-color "orange")
;(setq blink-cursor-interval 0.2)
;(setq blink-cursor-delay 1.0)
;(blink-cursor-mode 1)

;; 警告音を停止
(setq ring-bell-function 'ignore)

;; 補完で大文字小文字無視
(setq read-file-name-completion-ignore-case t)

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables '(tab-width 4))

;; デフォルトの透明度を設定する
;(add-to-list 'default-frame-alist '(alpha . 80))

;; カレントウィンドウの透明度を変更する
;(set-frame-parameter nil 'alpha 80)

;; バッファ自動再読み込み
(global-auto-revert-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; el-get
;;  https://github.com/dimitri/el-get
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (goto-char (point-max))
     (eval-print-last-sexp))))

;; レシピ置き場
(add-to-list 'el-get-recipe-path
             (concat (file-name-directory load-file-name) "/el-get/recipes"))

(el-get 'sync)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; anything
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get 'sync '(anything))

;; anythingの設定
(require 'anything-startup)
(global-set-key (kbd "C-x b") 'anything-for-files)
(global-set-key (kbd "M-y") 'anything-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'anything-find-files)
(global-set-key (kbd "C-x M-x") 'anything-M-x)

(setq recentf-max-menu-items 10)        ;; 表示するファイルの数
(setq recentf-max-saved-items 30)       ;; 保存するファイルの数
(setq kill-ring-max 100)                ;; kill-ring で保存される最大値

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;;  http://cx4a.org/software/auto-complete/manual.ja.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get 'sync '(auto-complete))
(add-hook 'auto-complete-mode-hook
          (lambda ()
            ;(define-key ac-completing-map (kbd "C-n") 'ac-next)
            ;(define-key ac-completing-map (kbd "C-p") 'ac-previous)
            (define-key ac-menu-map (kbd "C-n") 'ac-next)
            (define-key ac-menu-map (kbd "C-p") 'ac-previous)
            (define-key ac-mode-map (kbd "M-/") 'auto-complete)))

;; auto-complete config
(require 'auto-complete-config)
;(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict")
;(setq ac-auto-start nil)
(ac-set-trigger-key "TAB")
; (global-set-key "\M-/" 'ac-start)
(global-auto-complete-mode t)
(setq ac-use-menu-map t)

