(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq custom-file "~/.emacs.d/custom.el")

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(package-install 'gnu-elpa-keyring-update)

(eval-when-compile
  (require 'use-package))


;; UI configs

(ido-mode 1)
(ido-everywhere 1)

(global-set-key
     "\M-x"
     (lambda ()
       (interactive)
       (call-interactively
        (intern
         (ido-completing-read
          "M-x "
          (all-completions "" obarray 'commandp))))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;get rid of clutter
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;remove bells
(setq ring-bell-function 'ignore)


;; make fringe smaller
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

(ido-mode 1)
(ido-everywhere 1)

(use-package buffer-move
  :ensure t)

;; IDO for M-x
(global-set-key
     "\M-x"
     (lambda ()
       (interactive)
       (call-interactively
        (intern
         (ido-completing-read
          "M-x "
          (all-completions "" obarray 'commandp))))))

(setq create-lockfiles nil)

(global-set-key (kbd "C-å") 'enlarge-window)
(global-set-key (kbd "C-ä") 'shrink-window)

(global-set-key (kbd "C-.") 'enlarge-window-horizontally)
(global-set-key (kbd "C-,") 'shrink-window-horizontally)

;; Revert buffer easily
(global-set-key (kbd "C-c r") 'revert-buffer)

; Open buffer menu in the active window
(global-set-key (kbd "C-x C-b") 'buffer-menu)

;; Text size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; duplicates line C-c d
(global-set-key (kbd "C-c d") 'duplicate-line)

;; Enable switching between windows with s-<arrow-keys>
(windmove-default-keybindings)

;; Savehist mode
(savehist-mode 1)

;; reload config
(defun reload ()
  "Reloads the emacs conf file(s)"
  (interactive)
  (load-file (expand-file-name user-init-file)))

;; Make windmove work in Org mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

;;; Packages

(use-package darkroom
  :ensure t)
(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t))

(use-package wcheck-mode
  :ensure t
  :hook (org-mode . wcheck-mode)
  :init
  (defvar my-finnish-syntax-table
    (copy-syntax-table text-mode-syntax-table))

  (modify-syntax-entry ?- "w" my-finnish-syntax-table)
  (setq wcheck-language-data
	'(("Finnish"
	    (program . "/usr/bin/enchant")
	    (args "-l" "-d" "fi")
	    (syntax . my-finnish-syntax-table)
	    (action-program . "/usr/bin/enchant")
	    (action-args "-a" "-d" "fi")
	    (action-parser . wcheck-parser-ispell-suggestions))))
  (wcheck-change-language "Finnish" t)
  (add-hook 'text-mode-hook #'wcheck-mode)
  (add-hook 'org-mode-hook #'wcheck-mode))


(use-package smart-mode-line-atom-one-dark-theme
  :ensure t
  :init (sml/setup))

(use-package org-sidebar
  :ensure org
  :config
  :hook (org-mode . org-sidebar-tree))
(use-package helm-org
  :ensure t)

(use-package visual-fill-column
  :ensure t
  :config
  (set-default 'visual-fill-column-width 100)
  (set-default 'fill-column 80)
  (setq split-window-preferred-function 'visual-fill-column-split-window-sensibly)
  (global-visual-fill-column-mode))

(use-package magit
  :ensure t)

(use-package ag
  :ensure t)

(use-package undo-tree
  :config (global-undo-tree-mode)
  :ensure t)

(desktop-save-mode 1)

(defun suppress-headings (data backend channel)
 (when (eq backend 'latex)
  (let* ((parent (get-text-property (- (string-match "$" data) 2) :parent data))
     (headline (and parent (cadr parent)))
         (tags (and headline (plist-get headline :tags))))
    (replace-regexp-in-string "\\`.*$" "" data))))


(defun scale-titles ()
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.25))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.25))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
   ))

(use-package org
  :ensure t
  :mode ("\\.org\\'" . org-mode)
  :init
  (add-hook 'org-mode-hook (lambda () (scale-titles)))
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
  (setq org-export-preserve-breaks t)
  (setq org-export-with-tasks '("REV1" "VALMIS"))
  (setq org-todo-keywords
	'((sequence "TYHJÄ" "LUONNOS" "|" "REV1" "VALMIS")))
  (add-to-list 'org-export-filter-headline-functions 'suppress-headings)
  (require 'visual-fill-column) (add-hook 'visual-line-mode-hook 'visual-fill-column-mode) (add-hook 'org-mode-hook 'turn-on-visual-line-mode)
  (add-to-list 'org-latex-classes
             '("ethz"
               "\\documentclass[a4paper,oneside,12pt]{memoir}
\\usepackage[utf8]{inputenc}
\\usepackage[T1]{fontenc}
\\usepackage{fixltx2e}
\\usepackage{graphicx}
\\usepackage{longtable}
\\usepackage{float}
\\usepackage{wrapfig}
\\usepackage{rotating}
\\usepackage[normalem]{ulem}
\\usepackage{amsmath}
\\usepackage{textcomp}
\\usepackage{marvosym}
\\usepackage{wasysym}
\\usepackage{amssymb}
\\usepackage{hyperref}
\\usepackage{mathpazo}
\\usepackage{color}
\\usepackage{enumerate}
\\OnehalfSpacing
\\setlrmarginsandblock{2cm}{2cm}{*}
\\setulmarginsandblock{2cm}{2cm}{*}
\\checkandfixthelayout
\\let\\oldnwl\\\\\
\\renewcommand{\\\\}{\\oldnwl \\indent}
\\definecolor{bg}{rgb}{0.95,0.95,0.95}
\\tolerance=1000
      [NO-DEFAULT-PACKAGES]
      [PACKAGES]
      [EXTRA]
\\linespread{1.5}
\\hypersetup{pdfborder=0 0 0}"
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(use-package org-bullets
  :ensure t
  :commands (org-bullets-mode)
  :init
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  

(use-package buffer-move
  :ensure t)



;; Source: https://github.com/purcell/emacs.d/blob/master/lisp/init-sessions.el
; save a bunch of variables to the desktop file
;; for lists specify the len of the maximal saved data also
(setq desktop-globals-to-save
      (append '((comint-input-ring . 50)
                (compile-history . 30)
                desktop-missing-file-warning
                (dired-regexp-history . 20)
                (extended-command-history . 30)
                (face-name-history . 20)
                (file-name-history . 100)
                (grep-find-history . 30)
                (grep-history . 30)
                (ido-buffer-history . 100)
                (ido-last-directory-list . 100)
                (ido-work-directory-list . 100)
                (ido-work-file-list . 100)
                (magit-read-rev-history . 50)
                (minibuffer-history . 50)
                (org-clock-history . 50)
                (org-refile-history . 50)
                (org-tags-history . 50)
                (query-replace-history . 60)
                (read-expression-history . 60)
                (regexp-history . 60)
                (regexp-search-ring . 20)
                register-alist
                (search-ring . 20)
                (shell-command-history . 50)
                tags-file-name
                tags-table-list)))


(let ((bookmarkplus-dir "~/.emacs.d/custom/bookmark-plus/")
              (emacswiki-base "https://www.emacswiki.org/emacs/download/")
              (bookmark-files '("bookmark+.el" "bookmark+-mac.el" "bookmark+-bmu.el" "bookmark+-key.el" "bookmark+-lit.el" "bookmark+-1.el")))
          (require 'url)
          (add-to-list 'load-path bookmarkplus-dir)
          (make-directory bookmarkplus-dir t)
          (mapcar (lambda (arg)
                    (let ((local-file (concat bookmarkplus-dir arg)))
                      (unless (file-exists-p local-file)
                        (url-copy-file (concat emacswiki-base arg) local-file t))))
                    bookmark-files)
          (byte-recompile-directory bookmarkplus-dir 0)
          (require 'bookmark+))

(defun save-desktop-save-buffers-kill-emacs ()
  "Save buffers and current desktop every time when quitting emacs."
  (interactive)
  (desktop-save-in-desktop-dir)
  (save-buffers-kill-emacs))

(global-set-key (kbd "C-x C-c") 'save-desktop-save-buffers-kill-emacs)

(setq-default line-spacing 2)


(set-face-attribute 'default nil
                    :family "Monaco"
                    :height 120
                    :weight 'normal
                    :width 'normal)

(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(savehist-mode 1)
(provide 'init)

;;; init.el ends here


