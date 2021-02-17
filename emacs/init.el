(require 'package)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;;
;; theme
;;
(load-theme 'material t)

;;
;; set autosave and backup directory
;;
(defconst emacs-tmp-dir (format "%s%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;
;; custome variable path
;;
(setq custom-file "~/.empacs.d/custom-variables.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;
;; use use-package
;;
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package diminish :ensure t)
(use-package bind-key :ensure t)

;;
;; auto package update
;;
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe)
  )

;;
;; basic setup
;;

(menu-bar-mode -1)
(show-paren-mode t) ; 显示对应括号
(electric-pair-mode t) ;自动补全括号

(setq electric-pair-pairs '(
			    (?\' . ?\')
			    ))

(setq-default indent-tabs-mode nil)
(winner-mode t)

;;
;; hideshow
;;
(add-hook 'prog-mode-hook #'hs-minor-mode)


;;
;; ivy mode
;;

(use-package ivy
  :ensure t
  :diminish (ivy-mode . "")
  :config
  (ivy-mode 1)
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 10)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "%d/%d")
  (setq ivy-re-builders-alist
        `((t . ivy--regex-ignore-order)))
  )

;;
;; tree
;;
(use-package neotree
  :ensure t)
(neotree-toggle)
(global-set-key [f8] 'neotree-toggle)
(use-package all-the-icons)



;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;      setup coding system and window property
;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(prefer-coding-system 'utf-8)
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-format "%H:%M:%S")
(ac-config-default)
(global-font-lock-mode 1)
(setq ac-auto-show-menu 0.8)
(setq inhibit-startup-screen t) ;; 关闭欢迎页

(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-x p") 'prev-window)

(defun next-window ()
  (interactive)
  (other-window 1))
(global-set-key (kbd "C-x n") 'next-window)


;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;;      coding font for english and chinese
;; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
(set-face-attribute 'default nil
                    :family "Source Code Pro for Powerline"
                    :height 140
                    :weight 'medium
                    :width 'medium)
(if (display-graphic-p)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset (font-spec :family "Microsoft Yahei"
                                           :size 14)))
  )



;;  tide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)
