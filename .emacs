;; Start-up  => start emacs as a server (unless already running)
(load "server")
(unless (server-running-p) (server-start))

;; Packages
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;; Themes
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
(load-theme 'solarized-dark)

;; Hack to reload theme
(defun thj-reload-solarized (frame)
  (select-frame frame)
  (load-theme 'solarized-dark))
(defun thj-reload-solarized-on-delete (&optional frame)
    (load-theme 'solarized-dark))
(add-hook 'delete-frame-functions 'thj-reload-solarized-on-delete)
(add-hook 'server-done-hook 'thj-reload-solarized-on-delete)
(add-hook 'after-make-frame-functions 'thj-reload-solarized)

;; Fonts
(set-default-font "Source Code Pro")
(if window-system (set-face-attribute 'default nil :font "Source Code Pro" :height 120))

;; Custom faces
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-errline ((t (:inherit error :background " #073642" :foreground "red")))))



;; Custom Variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(blink-cursor-mode nil)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(uniquify-separator "\" in \""))

;; Integrate clipboard with emacs 
(xclip-mode 1)

;; Save all backup file in this directory.
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; Ido Mode
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1) 

;; Convert TABS to space
(set-default 'indent-tabs-mode nil)

;; ========== Haskell Mode ==========

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-font-lock)

(setq haskell-stylish-on-save t)

(eval-after-load "haskell-mode"
  '(progn
     (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
     (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)))

(eval-after-load "haskell-mode"
    '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

(eval-after-load "haskell-cabal"
    '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))

;; ========== GHC-MOD Mode ==========
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

;; specifying ghc options
;(setq ghc-ghc-options '("-idir1" "-idir2"))

;; specifying hlint options
(setq ghc-hlint-options '("--colour --ignore=Use camelCase"))


;; Haskell Align
(add-hook 'align-load-hook (lambda ()
 (add-to-list 'align-rules-list
              '(haskell-types
                (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
                (modes quote (haskell-mode literate-haskell-mode))))
 (add-to-list 'align-rules-list 
              '(haskell-assignment
                (regexp . "\\(\\s-+\\)=\\s-+")
                (modes quote (haskell-mode literate-haskell-mode))))
 (add-to-list 'align-rules-list
              '(haskell-arrows
                (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
                (modes quote (haskell-mode literate-haskell-mode))))
 (add-to-list 'align-rules-list
              '(haskell-left-arrows
                (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
                (modes quote (haskell-mode literate-haskell-mode))))))
(global-set-key "\M-]" 'align)

;; Comments
(defun comment-dwim-line ()
      (interactive)
      (let ((start (line-beginning-position))
            (end (line-end-position)))
        (when (region-active-p)
          (setq start (save-excursion
                        (goto-char (region-beginning))
                        (beginning-of-line)
                        (point))
                end (save-excursion
                      (goto-char (region-end))
                      (end-of-line)
                      (point))))
        (comment-or-uncomment-region start end)))

(global-set-key "\M-;" 'comment-dwim-line)

;; Cua mode - Rectangle and C-c,C-v copy keys
(cua-mode t)

;; Don't tabify after rectangle commands
(setq cua-auto-tabify-rectangles nil)

;; No region when it is not highlighted
(transient-mark-mode 1)

;; Standard Windows behaviour
(setq cua-keep-region-after-copy t)
