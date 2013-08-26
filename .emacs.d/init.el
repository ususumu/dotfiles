(setq inhibit-startup-screen t)
(global-linum-mode t)
(setq defult-tab-width 4)
(defun add-to-load-path (&rest paths)
  (let (path))
    (dolist (path paths paths)
      (let ((default-directory
(expand-file-name (concat user-emacs-directory path))))
(add-to-list 'load-path default-directory)
(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
(normal-top-level-add-subdirs-to-load-path)))))
(add-to-load-path "elisp" "conf" "public_repos")
(require 'pymacs)
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp") 
;;;;;;;;;;;Proxy設定;;;;;;;;;;;;;;;;;;;;;
(setq url-proxy-services '(("http" . "proxy.gateway-net.fuji-ric.co.jp:10080")
			   ("https" . "proxy.gateway-net.fuji-ric.co.jp:10080")))
;;関数定義
;;o埋め連番生成
(defun makePadNum(x)
  (substring
   (concat
    (make-string x ?0) (replace-regexp-in-string "Line " "" (what-line) ) ) (* -1 x)))
;;;;;;;;;;;括弧を強調表示;;;;;;;;;;;;;;;;
(setq show-paren-delay 0);表示までの秒数
(show-paren-mode t)
;;parenのスタイル; expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;;フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;;;;;;;;;;;表示カスタマイズ;;;;;;;;;;;;;
(set-face-foreground 'minibuffer-prompt "cyan1")
(if (boundp 'window-system)
    (setq default-frame-alist
          (append (list
                   '(top . 40) ; ウィンドウの表示位置（Y座標）
                   '(left . 40) ; ウィンドウの表示位置（X座標）
                   '(width . 140) ; ウィンドウの幅（文字数）
                   '(height . 45) ; ウィンドウの高さ（文字数）
                   )
                  default-frame-alist)))
(setq initial-frame-alist default-frame-alist )
;;;;;;;;;;*scratch*バッファ設定;;;;;;;;;
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))

(defun my-buffer-name-list ()
  (mapcar (function buffer-name) (buffer-list)))

(add-hook 'kill-buffer-query-functions
    ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (function (lambda ()
                      (if (string= "*scratch*" (buffer-name))
                          (progn (my-make-scratch 0) nil)
                        t))))

(add-hook 'after-save-hook
;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
          (function (lambda ()
                      (unless (member "*scratch*" (my-buffer-name-list))
                        (my-make-scratch 1)))))
;; scratchバッファの初期値をNullに設定
(setq initial-scratch-message "")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tsdh-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(cua-mode t)
(setq cua-enable-cua-keys nil) ; cuaモードkeyバインドを無効化
(put 'upcase-region 'disabled nil)

;;行折り返しなし
(set-default 'truncate-lines t)
;;#C-hをバックスペースに
(global-set-key "\C-h" 'backward-delete-char-untabify)
;;#goto-line
(global-set-key "\M-g" 'goto-line)
;;#diredでフォルダを開く時, 新しいバッファを作成しない
;; バッファを作成したい時にはoやC-u ^を利用する
(defvar my-dired-before-buffer nil)
(defadvice dired-advertised-find-file
(before kill-dired-buffer activate)
(setq my-dired-before-buffer (current-buffer)))
(defadvice dired-advertised-find-file
(after kill-dired-buffer-after activate)
(if (eq major-mode 'dired-mode)
(kill-buffer my-dired-before-buffer)))
(defadvice dired-up-directory
(before kill-up-dired-buffer activate)
(setq my-dired-before-buffer (current-buffer)))
(defadvice dired-up-directory
(after kill-up-dired-buffer-after activate)
(if (eq major-mode 'dired-mode)
(kill-buffer my-dired-before-buffer)))
;;Auto-install追加
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)
;;locale
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)
(setq system-time-locale "C")
(setq default-file-name-coding-system 'shift_jis)
;;Helm設定
(setq ido-virtual-buffers '())
(setq recent-list '())
(require 'helm-config)
(require 'helm-mode)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x h") 'helm-mini)

;;Default Directory
(setq default-directory "C:\\temp" )
;; ruby-mode
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist  (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
  
;; ruby-mode indent
(setq ruby-deep-indent-paren-style nil)
;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
;; ミニバッファに表示し, かつ, オーバレイする.
(setq ruby-block-highlight-toggle t)
;; Foreign-regexp
(require 'foreign-regexp)
(custom-set-variables
 '(foreign-regexp/regexp-type 'perl)    ; perl や javascript も指定可能
 '(reb-re-syntax 'foreign-regexp))
