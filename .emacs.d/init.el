(global-linum-mode t)
;;(setq-default-tab-width 4)
(defun add-to-load-path (&rest paths)
  (let (path))
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path)))))
(add-to-load-path "elisp" "conf" "public_repos")
(setq show-paren-delay 0);表示までの秒数
(show-paren-mode t)
;;parenのスタイル; expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;;フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")