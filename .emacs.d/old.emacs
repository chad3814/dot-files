;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))



;;;;; Below is copied from my old .emacs
;;  Start the emacsclient server
;(gnuserv-start)

;;  Configuration for default mode (text-mode)
;;  This will automatically put you in text mode when using emacs
;(setq-default default-major-mode 'text-mode)
;; (setq-default text-mode-hook 'turn-on-auto-fill)
;; (add-hook 'text-mode-hook 'refill-mode)
;(setq fill-column 70)
;; (text-mode)
;; Elisp is cool now, so...

; This will shut off the *~ files (reduces the emacs-droppings that
; clutter your directory)
;(setq make-backup-files nil)
; give the control-x control-f command.  the control-x f command resets
; the fill column.  to keep me from making this mistake, the next
; keybinding unsets the command.

(global-unset-key "\C-xf")

(setq load-path (append (list "/home/chad/.elisp" "/usr/share/emacs/site-lisp")
			load-path))
(require 'p4)
(require 'ediff)
(require 'linum)
;(require 'color-theme)
(require 'php-mode)

;;;; rebinding of control-x control-b: for `buffer-menu'

; the following rebinds control-x control-b to the buffer-menu command
; rather than the list-buffers command.  the buffer-menu command not
; only lists the buffers, but selects the *buffer list* for editing.

(global-set-key "\C-x\C-b" 'buffer-menu)

;;;; personal keybindings.  most of these use the c-c map, which is
;;;; available only to the user of emacs, not to the programmer of any
;;;; package.
;;;; ----------------------------------------------------------------

;(global-set-key "\M-s"     'isearch-backward)
;(global-set-key "\C-ci"   'config-buffer-in)
;(global-set-key "\C-co"   'config-buffer-out)

;(global-set-key "\C-cm"   'recompile)
;(global-set-key "\C-c\C-m" 'recompile-and-iconify)

(global-set-key "\C-cl"   'goto-line)
;(global-set-key "\C-cw"   'what-line)

;(global-set-key "\C-ca"   'add-change-log-entry)
;(global-set-key "\C-cd"   'insert-date-at-point)
;(global-set-key "\C-c\C-w" 'count-words-buffer)	;my word counter...
;(global-set-key "\C-c\C-l" 'count-lines-buffer) ;my line counter...
;(global-set-key "\C-m"    'newline-and-indent)
(global-set-key "\er"     'replace-string)
;(global-set-key "\es"     'save-buffer)
(global-set-key "\eq"     'quoted-insert)
(global-set-key "\C-cL"   'linum-mode)
;(menu-bar-mode '0)

(defun check-php-file-name ()
  "Checks the `buffer-file-name' to see if it resides in 'src.php/v4' and is either index.inc or template.tmpl"
  (if (and
       (stringp buffer-file-name)
       (or
	(setq fpos (string-match "/index\.inc$" buffer-file-name))
	(setq fpos (string-match "/index\.php$" buffer-file-name))
	(setq fpos (string-match "/template\.tmpl$" buffer-file-name)))
       (or
	(string-match "/src.php/v4/modules/" buffer-file-name)
	(string-match "/src.php/v4/pages/" buffer-file-name))
       )
      (if (string= ".tmpl" (substring buffer-file-name -5))
	  (rename-buffer (concat (substring buffer-file-name (match-end 0) fpos) ".tmpl"))
	(rename-buffer (concat (substring buffer-file-name (match-end 0) fpos) (substring buffer-file-name -4))))))

(add-hook 'php-mode-hook 'check-php-file-name)
(add-hook 'html-mode-hook 'check-php-file-name)
(setq auto-mode-alist (cons '("\\.tmpl$" . html-mode) auto-mode-alist))

;(put 'eval-expression 'disabled nil)

;(defun recompile-and-iconify ()
;  "Recompiles and iconifies the frame."
;  (interactive)
;  (recompile)
;  (suspend-emacs-or-iconify-frame))

;(defun count-words-buffer ()
;  "Count the number of words in the current buffer;
;print a message in the minibuffer with the result."
;  (interactive)
;  (save-excursion
;    (let ((count 0))
;      (goto-char (point-min))
;      (while (< (point) (point-max))
;	(forward-word 1)
;	(setq count (1+ count)))
;      (message "buffer contains %d words." count))))

;(defun count-lines-buffer ()
;  "Count the number of lines in the current buffer;
;print a message in the minibuffer with the result."
;  (interactive)
;  (save-excursion
;    (let ((count 0))
;      (goto-char (point-min))
;      (while (< (point) (point-max))
;	(next-line 1)
;	(setq count (1+ count)))
;      (message "buffer contains %d lines." count))))

;; autoloads for my own modes...
;;
;(autoload 'calc-mode "calc" "Calculator Mode." t)
				     ; calculator mode...$HOME/.elisp/calc.elc
;(autoload 'refill-mode "refill" "Refill Minor Mode." t)
				     ; refill minor mode... .elisp/refill.elc
;(autoload 'quip-mode "quip" "Quip Mode." t)
				     ; quip mode... $HOME/.elisp/quip.elc
;;;;;;;;;;;;;;;; mode setups ;;;;;;;;;;;;;;;;

(defconst xfire-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((defun-open '())
                                   (defun-close before after)
                                   (class-open before after)
                                   (class-close before after)
                                   (substatement-open '())
                                   (extern-lang-open before after)
                                   (extern-lang-close before after)))
    (c-hanging-colons-alist     . ((case-label after)   ; case X:
                                   (label after)        ; dong:
                                   (access-label after) ; private: (C++)
                                   (member-init-intro before)))
    (c-cleanup-list             . (defun-close-semi     ; };
                                   empty-defun-braces))
    (c-basic-offset             . 4)
    (c-echo-syntactic-information-p . t)
    (c-offsets-alist            . ((statement-block-intro . +)
                                   (knr-argdecl-intro . +)
                                   (substatement-open . 0)
                                   (label . 0)
                                   (inline-open . 0)
                                   (case-label . *)
                                   (statement-cont . +))))
  "The Xfire C Programming Style")

(defun xfire-c-mode-hook ()
  "Set the Xfire C programming style"
  ;; add and set style
  (c-add-style "xfire" xfire-c-style t)
  ;;don't use spaces instead of tabs
  (setq indent-tabs-mode t)
  ;; keep working files when I check in RCS/CVS files
  (setq vc-keep-workfiles t)
  ;; auto-indent
  (c-toggle-auto-hungry-state 1)
  ;; set the tab size to 4, 8 is too big
  (setq tab-width 4)
  ;; auto-indent to the proper position on a return
  ;(local-set-key "\C-m" 'newline-and-indent)
  ;; line numbers
  (line-number-mode t))

(defun xfire-perl-mode-hook ()
  "Set the Xfire Perl programming style"
  ;; always re-indent a line when one hits tab
  (setq cperl-tab-always-indent t)
  ;; indent commands
  (setq cperl-indent-left-aligned-comments t)
  ;; indent level
  (setq cperl-indent-level 4)
  ;; don't indent {}'s
  (setq cperl-continued-statement-offset 4)
  (setq cperl-brace-offset -4)
  (setq cperl-label-offset -4)
  ;; auto-indent to the proper position on a return
  (setq cperl-electric-linefeed t)
  ;; put new-lines around braces automatically
  (setq cperl-auto-newline t)
  (setq cperl-auto-newline-after-colon t)
  (setq cperl-extra-newline-before-brace t)
  (setq cperl-extra-newline-before-brace-multiline t)
  (setq cperl-electric-parens t)
  ;; line numbers
  (line-number-mode t))

(add-hook 'c-mode-hook 'xfire-c-mode-hook)
(add-hook 'c++-mode-hook 'xfire-c-mode-hook)
(add-hook 'objc-mode-hook 'xfire-c-mode-hook)
(add-hook 'java-mode-hook 'xfire-c-mode-hook)
(add-hook 'javascript-mode-hook 'xfire-c-mode-hook)
(add-hook 'php-mode-hook 'xfire-c-mode-hook)
(add-hook 'cperl-mode-hook 'xfire-perl-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-auto-fontify nil)
 '(gnuserv-frame t)
 '(query-user-mail-address nil))
;(require 'pcl-cvs)
;(set-face-background 'default "#000060")
;(set-face-foreground 'default "#FFFF00")
(line-number-mode t)

;(add-to-list 'load-path "~jmacnish/lisp/tramp/lisp/")
;(require 'tramp)
;(setq tramp-default-method "scp")
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(custom-comment-tag ((((class color) (background light)) (:foreground "yellow"))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face))))
 '(font-lock-comment-face ((((class color) (min-colors 8) (background light)) (:foreground "green"))))
 '(font-lock-string-face ((((class color) (min-colors 8)) (:foreground "white" :weight bold))))
 '(link ((((class color) (background light)) (:foreground "white" :underline t))))
 '(minibuffer-prompt ((t (:foreground "Red" :weight bold))))
 '(p4-depot-branch-op-face ((t (:foreground "Dark Grey"))) t)
 '(p4-depot-unmapped-face ((t (:foreground "white"))) t)
 '(p4-diff-change-face ((t (:foreground "green"))) t)
 '(p4-diff-file-face ((t (:foreground "gold"))) t)
 '(p4-diff-head-face ((t (:foreground "GoldenRod"))) t)
 '(p4-diff-ins-face ((t (:foreground "light sea green"))) t)
 '(speedbar-directory-face ((((class color) (background light)) (:foreground "yellow"))))
 '(tool-bar ((default (:foreground "grey" :box (:line-width 1 :style released-button))) (nil nil)))
 '(vhdl-speedbar-architecture-face ((((class color) (background light)) (:foreground "yellow"))))
 '(vhdl-speedbar-architecture-selected-face ((((class color) (background light)) (:foreground "yellow" :underline t)))))
