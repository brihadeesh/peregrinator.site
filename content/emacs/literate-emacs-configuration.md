+++
title = "Literate Emacs Configuration"
author = ["peregrinator"]
publishDate = 2021-12-04T00:00:00+05:30
lastmod = 2023-03-04T21:24:15+05:30
url = "/emacs/literate_emacs_configuration.html"
draft = false
autonumbering = true
+++

This is a copy of my literate configuration for Emacs and if you're
viewing this anywhere else, don't! Because you can find a readable
version on my [website](https://peregrinator.srht.site/emacs/literate-emacs-configuration.html). You can also find a source-based version with
the rest of my `~/.emacs.d` on my [sourcehut](https:git.sr.ht/~peregrinator/.emacs.d).


## <span class="section-num">1</span> Other init files {#other-init-files}

These are in my `~/.emacs.d` and help load this main configuration.


### <span class="section-num">1.1</span> Early init {#early-init}

This creates a file, [ `early-init.el` ](~/.emacs.d/early-init.el), in `~/.emacs.d`. This was stolen
from Protesilaos some time back. It still needs work - it's not
tangled (by default) yet.

```emacs-lisp

    ;;; early-init.el --- Early Init File -*- lexical-binding: t -*-

;; Copyright (c) 2021-2022 pereginator

;; Author: peregrinator <brihadeesh@protonmail.com>
;; URL: https://git.sr.ht/~peregrinator/dotfiles Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.  This file is distributed in
;; the hope that it will be useful, but WITHOUT ANY WARRANTY; without
;; even the implied warranty of MERCHANTABILITY or FITNESS FOR A
;; PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.  You should have received a copy of the GNU General Public
;; License along with this file.  If not, see
;; <http://www.gnu.org/licenses/>.

    ;;; Commentary:

;; Prior to Emacs 27, the `init.el' was supposed to handle the
;; initialisation of the package manager, by means of calling
;; `package-initialize'.  Starting with Emacs 27, the default
;; behaviour is to start the package manager before loading the init
;; file.

    ;;; Code:

;; Don't initialise installed packages cause package.el sucks balls
(setq package-enable-at-startup nil)

;; Do not resize the frame at this early stage.  (setq
frame-inhibit-implied-resize t)

;; Disable GUI elements ; Disable menu-bar, tool-bar, and scroll-bar.
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1)) (if (fboundp
;;'tool-bar-mode) (tool-bar-mode -1)) (if (fboundp 'scroll-bar-mode)
;;(scroll-bar-mode -1)) (setq inhibit-splash-screen t) (setq
;;use-dialog-box nil) ; only for mouse events (setq use-file-dialog
;;nil)

(setq inhibit-startup-screen t) (setq inhibit-startup-buffer-menu t)

;; for when I upgrade to emacs28 with native compilation (setq
native-comp-async-report-warnings-errors nil)

    ;;; early-init.el ends here
```


### <span class="section-num">1.2</span> init.el {#init-dot-el}

I've changed things up a little - this now includes the package
management code and the code for `org` installation.

```emacs-lisp

;;; init.el --- Initialization. -*- lexical-binding: t; -*-

;; Copyright (C) 2022 peregrinator
;; This file is NOT part of GNU Emacs.
;; This file is free software.

;; Author: peregrinator <brihadeesh@protonmail.com>
;; URL: https://git.sr.ht/~peregrinator/.emacs.d
;; Package-Requires: ((emacs "28.1"))

;;; Commentary:
;; This file provides the initialization configuration.

;;; Code:

;; Make emacs startup faster
(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(defun startup/revert-file-name-handler-alist ()
  "Revert file name handler alist."
  (setq file-name-handler-alist startup/file-name-handler-alist))
(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)

;; For performance
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq process-adaptive-read-buffering nil)

;; Load newer .elc or .el
(setq load-prefer-newer t)

```


#### <span class="section-num">1.2.1</span> Package management {#package-management}

Update: <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-11-21 Mon&gt;</span></span>
I've moved all of this and some other stuff (garbage collection etc)
to the `init.el`. See the initial org-mode installation section below
for more.


##### <span class="section-num">1.2.1.1</span> Setup `straight.el` {#setup-straight-dot-el}

I'll be using `use-package` to organise and configure individual
packages into neater code blocks although the download will be handled
by `straight.el`. I've included the org-installation here since there's somehow always
an issue with version mismatch.

```emacs-lisp

;;; Configure `straight.el'
;; fetch developmental version of `straight.el'
(setq straight-repository-branch "develop"

      ;; redirect all package repos and builddirs elsewhere
      straight-base-dir "~/.cache/")


;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" "~/.cache"))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Configure straight.el (contd.)
;; make all use-package instances use straight.el
(setq straight-use-package-by-default t

      ;; clone depth (probably to save space)
      straight-vc-git-default-clone-depth 1

      ;; Define when to check for package modifications,
      ;; for improved straight.el startup time.
      straight-check-for-modifications nil

      ;; use elpa
      straight-recipes-gnu-elpa-use-mirror t

      straight-host-usernames
      '((github . "brihadeesh")
        (gitlab . "peregrinator")))

```


##### <span class="section-num">1.2.1.2</span> Install and configure `use-package` {#install-and-configure-use-package}

`use-package` is installed and managed by `straight.el` and in turn
packages used in this config are managed/organized by
`use-package`. There's something to do with integration with `use-package`
on the [straight.el readme](https://github.com/raxod502/straight.el/blob/develop/README.md#integration-with-use-package)

```emacs-lisp

;; Install use-package with straight.el
(straight-use-package 'use-package)

```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">1.2.1.3</span> Use-package v2 related changes {#use-package-v2-related-changes}

Need to figure this out - I think maybe `use-package` might not be updated

```emacs-lisp

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">1.2.1.4</span> Minimal `package.el` setup only to browse packages {#minimal-package-dot-el-setup-only-to-browse-packages}

Running `package-list-packages` includes them only for browsing

```emacs-lisp

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

```


#### <span class="section-num">1.2.2</span> Initial Org-mode installation {#initial-org-mode-installation}

I use the latest version of Org, pulled from the `gnu-elpa` repositories
and have to install it early on so `straight.el` / `use-package` don't
give me trouble with version conflicts because it loads the built in
(older) version first.

```emacs-lisp

;; install org & org-contrib
(straight-use-package 'org)
;; (require 'org)
(straight-use-package 'org-contrib)


;; Load configuration.org
(when (file-readable-p
       (concat user-emacs-directory "configuration.org"))
  (org-babel-load-file
   (concat user-emacs-directory "configuration.org")))

```


#### <span class="section-num">1.2.3</span> End {#end}

```emacs-lisp

;;; init.el ends here

```


## <span class="section-num">2</span> Header {#header}

Just the usual header for elisp files that Emacs keeps complaining
about.

```emacs-lisp
    ;;; configuration.el --- Initialisation. -*- lexical-binding: t; -*-

;; Copyright (C) 2022 peregrinator

;; Author: peregrinator <brihadeesh@protonmail.com>
;; URL: https://git.sr.ht/~peregrinator/.emacs.d
;; Package-Requires: ((emacs "28.1"))

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.  This file is distributed in
;; the hope that it will be useful, but WITHOUT ANY WARRANTY; without
;; even the implied warranty of MERCHANTABILITY or FITNESS FOR A
;; PARTICULAR PURPOSE.  See the GNU General Public License for more
;; details.  You should have received a copy of the GNU General Public
;; License along with this file.  If not, see
;; <http://www.gnu.org/licenses/>.


    ;;; Commentary:
;; This file provides the initialization configuration tangled this
;; file.


    ;;; Code:
```


## <span class="section-num">3</span> Prerequisites {#prerequisites}


### <span class="section-num">3.1</span> Reload Emacs configuration {#reload-emacs-configuration}

I'm not sure I understand how this works entirely but [joseph8th's repo](https://github.com/joseph8th/literatemacs#tangle-and-reload)
suggests using `M-: (load-file user-init-file) RET` or evaluating that
same function interactively. I've modified the sanemacs reload config
function below hoping that it works but in that doesn't happen, this
first code block can be evaluated using `C-c C-c`:

<a id="code-snippet--reload-emacs"></a>
```emacs-lisp
(defun reload-config ()
  (interactive)
  (load-file user-init-file))
```


### <span class="section-num">3.2</span> Ensure UTF-8 {#ensure-utf-8}

```emacs-lisp
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
```


### <span class="section-num">3.3</span> Whoami {#whoami}

```emacs-lisp
(setq user-full-name "peregrinator"
      user-mail-address "brihadeesh@protonmail.com")
```


## <span class="section-num">4</span> Writing {#writing}


### <span class="section-num">4.1</span> Org-mode {#org-mode}

-   [X] Get the damn thing first
-   [ ] Organise the thing - needs splitting into multiple code blocks.

Moved the installation to `init.el` along with the `straight.el` bootstrap
to avoid conflicts with the bundled version of the package. I think
this can go back to being a regular `use-package` function but I'm
desperately avoiding having to debug init any further.

```emacs-lisp

(require 'org)
(setq initial-major-mode 'org-mode
      org-display-inline-images t
      org-redisplay-inline-images t
      org-image-actual-width nil
      org-startup-with-inline-images "inlineimages"
      org-catch-invisible-edits 'smart

      ;; sub-headings inherit properties set at parent level
      ;; headings
      org-use-property-inheritance t

      ;; org-ellipsis " ▾"
      ;; hide markers for bold, italic, etc and trailing stars
      org-hide-emphasis-markers t

      ;; fontify code in code blocks
      org-src-fontify-natively t
      org-fontify-quote-and-verse-blocks t
      ;; org-src-tab-acts-natively t

     ;; org-edit-src-content-indentation 2
     org-hide-block-startup nil
     org-src-preserve-indentation nil
     org-edit-src-content-indentation 0

     ;; allow for increased space between org
     ;; org-cycle-separator-lines -1

     ;; hard indentation
     ;; org-adapt-indentation t

     ;; increase indentation by using odd header levels only
     ;; org-odd-levels-only t

     ;; org-startup-folded 'content
     org-capture-bookmark nil
     org-hide-leading-stars t

     ;; org-modern
     org-tags-column -80
     org-ellipsis " ▾"
     org-special-ctrl-a/e t
     ;; org-insert-heading-respect-content t

     ;; display numbers instead of bullets for headings
     ;; org-num-mode t

     ;; faster (single-key) navigation in org-mode
     ;; type `?' for help
     ;; org-use-speed-commands t
     )

    ;;(setq org-modules
    ;;  '(org-crypt
    ;;      org-habit
    ;;      org-bookmark
    ;;      org-eshell
    ;;      org-irc))

    (setq org-refile-targets '((nil :maxlevel . 5)
                               (org-agenda-files :maxlevel . 5)))

    (setq org-outline-path-complete-in-steps nil)
    (setq org-refile-use-outline-path t)

    ;; get something like this for regular emacs bindings
    ;;(evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
    ;;(evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
    ;;(evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
    ;;(evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup)

    ;; Replace list hyphen with dot
    ;; (font-lock-add-keywords 'org-mode
    ;;                         '(("^ *\\([-]\\) "
    ;;                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

```


#### <span class="section-num">4.1.1</span> Fixed pitch for everything code {#fixed-pitch-for-everything-code}

```emacs-lisp

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

```


#### <span class="section-num">4.1.2</span> Quick source block templates {#quick-source-block-templates}

These can be run by typing an angle bracket with the shortcut and
hitting `<TAB>`.

```emacs-lisp

;; block templates
;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("li" . "src lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("r" . "src R"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("lua" . "src lua"))
(add-to-list 'org-structure-template-alist '("yml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))
(add-to-list 'org-structure-template-alist '("aw" . "src awk"))

```

This creates a unique problem wherein the auto-pairing functionality
(`electric-pair-mode`) creates matching right angle bracket at the end
of the block, messing with Org syntax. This doesn't work as intended
and needs some debugging.

```emacs-lisp

;; disable electric pairing for angle bracket

(add-hook 'org-mode-hook (lambda ()
           (setq-local electric-pair-inhibit-predicate
                   `(lambda (c)
                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c)))))))

```


#### <span class="org-todo todo TODO">TODO</span> <span class="section-num">4.1.3</span> Babel {#babel}

This might require `org-contrib`.

```emacs-lisp

(org-babel-do-load-languages
         'org-babel-load-languages
         '((emacs-lisp . t)
           (R . t)
           (lisp . t)
           (shell . t)
           (org .t)
           (awk . t)))

```


#### <span class="section-num">4.1.4</span> New folding backend {#new-folding-backend}

This came with the Org 9.6 release on <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-11-29 Tue&gt; </span></span> and I got the
tea from the Org [changes](https://orgmode.org/Changes.html) post. This is optimised for files that are
large, and usually more than a few MB in size. I know this file is
only a few kilobytes but I kinda feel it lagging once in a
while. Probably some unrelated issue.

```emacs-lisp

(setq org-fold-core-style 'overlays)

```


#### <span class="org-todo todo TODO">TODO</span> <span class="section-num">4.1.5</span> Sources for agenda tasks {#sources-for-agenda-tasks}

Generates an agenda from wildcarded org files from the specified
directory

```emacs-lisp

;; (setq org-agenda-files
;;       (file-expand-wildcards "~/org/*.org"))

```


#### <span class="section-num">4.1.6</span> Tags and todo-keywords config {#tags-and-todo-keywords-config}

Todo-keywords are things like `TODO` and `DONE` and so on. Tags are for
classifying stuff by the general theme of what's being talked about.


##### <span class="section-num">4.1.6.1</span> todo-keywords {#todo-keywords}

```emacs-lisp
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)" "DISABLED(f!)")))
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">4.1.6.2</span> tags {#tags}

```emacs-lisp
(setq org-tag-alist '((("misc" . ?m)
                      ("emacs" . ?e)
                      ("dotfiles" . ?d)
                      ("work" . ?w)
                      ("chore" . ?c)
                      ("blog" . ?b)
                      )))
```


#### <span class="section-num">4.1.7</span> Org-capture {#org-capture}

Global keybinding for org-capture

```emacs-lisp

(global-set-key (kbd "C-c c") #'org-capture)

```

This will need to be looked at carefully. Roughly, I need to work out
if I'm going to be using `org-agenda` and if so, how will I be using
it. Adding tasks can be made much easier with this. I can also use
this for entering entries into `org-journal`, making it a whole deal
easier. Perhaps to start off, [the org-mode tutorial](https://orgmode.org/worg/org-tutorials/index.html) might be a good
place to start. I've also got a simple enough config from a reddit
post in my [unused local elisp libs](person_el/sample-org-setup.el) too.


#### <span class="section-num">4.1.8</span> Display features {#display-features}

In the spirit of reclaiming some semblance of organisation in this
file, I've tried to group settings by the what aspect they
change. Hopefully this continues and the rest of the Org mode
configuration can be split up.


##### <span class="section-num">4.1.8.1</span> Autoindent/autofill turned on automatically {#autoindent-autofill-turned-on-automatically}

```emacs-lisp

(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-startup-indented t)

;; organise paragraphs automatically
(add-hook 'org-mode-hook 'turn-on-auto-fill)

```


##### <span class="section-num">4.1.8.2</span> Minad's modern UI for org-mode {#minad-s-modern-ui-for-org-mode}

Was maintaining a [fork](https://github.com/brihadeesh/org-modern) but I guess it's too much work - should
considering getting back at it sometime. I was having issues with `TODO`
keywords and tags/categories being rendered absurdly small but
apparently setting `org-modern-label-border` to nil should make them
full sized (see [this issue](https://github.com/minad/org-modern/issues/91)). I really must consider using a
variable-pitch font for rich text and headers while restricting
fixed-pitch fonts to header arguments, source blocks and explicitly
code segments in text.

```emacs-lisp

(use-package org-modern
  ;; currently outdated/unmaintained fork
  ;; :straight (:host github :repo "brihadeesh/org-modern")

  :config
  ;; Add frame borders and window dividers
  (modify-all-frames-parameters
   '((right-divider-width . 10)
     (internal-border-width . 5)))
  (dolist (face '(window-divider
                  window-divider-first-pixel
                  window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
  (set-face-background 'fringe (face-attribute 'default :background))

  ;; `org-modern' specific config
  (setq org-modern-star ["◉ " "○ " "● " "○ " "● " "○ " "● "]
        org-modern-label-border nil)

  ;; enable the global mode
  (global-org-modern-mode t))

```


##### <span class="section-num">4.1.8.3</span> Display emphasis markers on hover {#display-emphasis-markers-on-hover}

This package makes it much easier to edit Org documents when
org-hide-emphasis-markers is turned on. It temporarily shows the
emphasis markers around certain markup elements when you place your
cursor inside of them. No more fumbling around with = and \*
characters!

```emacs-lisp
(use-package org-appear
  :hook (org-mode . org-appear-mode))
```


##### <span class="section-num">4.1.8.4</span> Better commenting in org-mode code-blocks {#better-commenting-in-org-mode-code-blocks}

Got this from a [Stack Exchange answer](https://emacs.stackexchange.com/a/19741/23936) to work around messed up
commenting using the default `C-x C-;` command. The older/default
command messes up lines, undos, and sometimes comment syntax as well.

```emacs-lisp

;; allow comment region in the code edit buffer (according to language)
(defun my-org-comment-dwim (&optional arg)
  (interactive "P")
  (or (org-babel-do-key-sequence-in-edit-buffer (kbd "M-;"))
      (comment-dwim arg)))

;; make `C-c C-v C-x M-;' more convenient
(define-key org-mode-map
  (kbd "M-;") 'my-org-comment-dwim)

```


##### <span class="section-num">4.1.8.5</span> TOC for org-mode files {#toc-for-org-mode-files}

```emacs-lisp
(use-package toc-org
    :after org
    :hook (org-mode . toc-org-enable))
```

Alternatively

```emacs-lisp
(use-package org-make-toc
  :hook (org-mode . org-make-toc-mode))
```


##### <span class="section-num">4.1.8.6</span> Convert all org-keywords/block identifiers to lowercase {#convert-all-org-keywords-block-identifiers-to-lowercase}

It's always nice to see random people online that are crazy like you
and are nice enough to write elisp code for the shit you need. Stolen
from [Kaushal Modi](https://scripter.co/org-keywords-lower-case/)

```emacs-lisp
(defun peremacs/lower-case-org-keywords ()
  "Lower case Org keywords and block identifiers.

Example: \"#+TITLE\" -> \"#+title\"
         \"#+BEGIN_EXAMPLE\" -> \"#+begin_example\"

Inspiration:
https://code.orgmode.org/bzg/org-mode/commit/13424336a6f30c50952d291e7a82906c1210daf0."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((case-fold-search nil)
          (count 0))
      ;; Match examples: "#+foo bar", "#+foo:", "=#+foo=", "~#+foo~",
      ;;                 "‘#+foo’", "“#+foo”", ",#+foo bar",
      ;;                 "#+FOO_bar<eol>", "#+FOO<eol>".
      (while (re-search-forward "\\(?1:#\\+[A-Z_]+\\(?:_[[:alpha:]]+\\)*\\)\\(?:[ :=~’”]\\|$\\)" nil :noerror)
        (setq count (1+ count))
        (replace-match (downcase (match-string-no-properties 1)) :fixedcase nil nil 1))
      (message "Lower-cased %d matches" count))))
```


### <span class="section-num">4.2</span> AUCTex for LaTex editing + completion {#auctex-for-latex-editing-plus-completion}

```emacs-lisp
;; FIXME:
;; (use-package auctex
;;   :init
;;   (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil))

(use-package auctex
  :demand t
  :no-require t
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :config
  (defun latex-help-get-cmd-alist ()    ;corrected version:
    "Scoop up the commands in the index of the latex info manual.
       The values are saved in `latex-help-cmd-alist' for speed."
    ;; mm, does it contain any cached entries
    (if (not (assoc "\\begin" latex-help-cmd-alist))
        (save-window-excursion
          (setq latex-help-cmd-alist nil)
          (Info-goto-node (concat latex-help-file "Command Index"))
          (goto-char (point-max))
          (while (re-search-backward "^\\* \\(.+\\): *\\(.+\\)\\." nil t)
            (let ((key (buffer-substring (match-beginning 1) (match-end 1)))
                  (value (buffer-substring (match-beginning 2)
                                           (match-end 2))))
              (add-to-list 'latex-help-cmd-alist (cons key value))))))
    latex-help-cmd-alist)

  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

;; (use-package company-auctex)
```


### <span class="section-num">4.3</span> Spellcheck {#spellcheck}


#### <span class="section-num">4.3.1</span> Hunspell {#hunspell}

Finally figured this out from a [reddit post from 2019](https://redd.it/ahysvb).

```emacs-lisp
;; flyspell + aspell??
(setq ispell-dictionary "en_GB")
(setq ispell-program-name "hunspell")
;; below two lines reset the the hunspell to it STOPS querying locale!
;; (setq ispell-local-dictionary "en_GB") ; "en_GB" is key to lookup in `ispell-local-dictionary-alist`

;; tell ispell that apostrophes are part of words
;; and select Bristish dictionary
;; (setq ispell-local-dictionary-alist
;;             (quote ("UK_English" "[[:alpha:]]" "[^[:alpha:]]" "['’]" t ("-d" "en_GB") nil utf-8)))

;; hook for text mode
(add-hook 'text-mode-hook 'flyspell-mode)
;; hook to check spelling for comments in code
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
```


#### <span class="section-num">4.3.2</span> Aspell based spellchecking {#aspell-based-spellchecking}

... because Void linux keeps complaining about not being able to find
a British English dictionary

```emacs-lisp
(setq ispell-program-name "aspell")
;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_GB"))

;; hook for text mode
(add-hook 'text-mode-hook 'flyspell-mode)
;; hook to check spelling for comments in code
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
```


#### <span class="section-num">4.3.3</span> flyspell-correct provides a more refines UI for spelling checking {#flyspell-correct-provides-a-more-refines-ui-for-spelling-checking}

This shows a popup like for completions when it finds a misspelled
word which makes it somewhat more accessible when writing, rather than
having to look down at the message area.

```emacs-lisp
(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-popup
  :after flyspell-correct)
```


### <span class="section-num">4.4</span> Something like scrivener from Mac {#something-like-scrivener-from-mac}

...cause I'm gonna become a novelist and/or write large books in the
near future

```emacs-lisp
(use-package binder)
;; (use-package binder-tutorial)
```


### <span class="section-num">4.5</span> Blogging {#blogging}

I've defined some stuff necessary to make editing a Hugo website
easier.


#### <span class="section-num">4.5.1</span> `ox-hugo` since the go-org keep wrecking up links {#ox-hugo-since-the-go-org-keep-wrecking-up-links}

My personal [static site](https://brihadeesh.github.io) was/is written with this. I might have to add
additional setup to add some of this functionality for project pages
but then I hope to eventually move everything to sourcehut or atleast
using it to host a website on my own domain.

This source block continues into the next section.

```emacs-lisp
(use-package ox-hugo
  :after ox)
```

Additional setup for streamlining writing posts on the static site:


##### <span class="section-num">4.5.1.1</span> Blogging flow {#blogging-flow}

Based on the capture templates [documentation](https://ox-hugo.scripter.co/doc/org-capture-setup/).

This function is called on invoking the org-capture (see next
section). This particular function adds a date below the header marked
`CLOSED` which on export to markdown is converted to a regular `date`
field by ox-hugo and is included in the single page view/posts list on
the final export. It also changes the `TODO` tag to `DONE`. I'm still
trying to figure out bundles so this might change soon.

Since the provided template runs independent of my git repo for the
website, I'll have to figure out the `file` variable and how to point it
to the `/content-org/blog/posts.org` file in the repo. From the original
ox-hugo docs code, this is the first template provided, (from under
the entry variable in the source block below):

> It is assumed that below file is present in `org-directory` and that
> it has a "Blog Ideas" heading. It can even be a symlink pointing to
> the actual location of all-posts.org!

So I'll change the `target` to point to my file in the repo directly
until I can assign specific (programmatic ?) definitions for the repo
in this configuration somewhere.

```emacs-lisp

(with-eval-after-load 'org-capture
  (defun org-hugo-new-post-capture ()
    "Returns `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
    (let* (;; http://www.holgerschurig.de/en/emacs-blog-from-org-to-hugo/
           (date (format-time-string (org-time-stamp-format :long :inactive) (org-current-time)))
           (title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title))
           (section (plist-get org-capture-plist :section))
           (lastmod (plist-get org-capture-alist :lastmod)))
      (mapconcat #'identity
                 `(
                   ,(concat "* DRAFT " title)
                   ":PROPERTIES:"
                   ,(concat "" section)
                   ,(concat ":EXPORT_FILE_NAME: " fname)
                   ,(concat ":EXPORT_HUGO_AUTO_SET_LASTMOD: " lastmod)
                   ;; Enter current date and time
                   ,(concat ":EXPORT_DATE: " date)
                   ":END:"
                   ;; Place the cursor here finally
                   "%?\n")
                 "\n")))

  (setq org-capture-templates
        ;;`org-capture' binding + h
        '(("h"
           "Hugo blog post"
           entry
           (file+olp "~/my_gits/brihadeesh.github.io/content-org/blog/posts.org" "Posts")
           (function org-hugo-new-post-capture)
           :section ":EXPORT_HUGO_SECTION: blog"
           :lastmod "t")

          ;; `org-capture' binding + m
          ("m"
           "Hugo miscellaneous blog post"
           entry
           (file+olp "~/my_gits/brihadeesh.github.io/content-org/blog/posts.org" "Miscellaneous")
           (function org-hugo-new-post-capture)
           :section ":EXPORT_HUGO_SECTION: misc"
           :lastmod "f"))))

```


## <span class="section-num">5</span> Work {#work}


### <span class="section-num">5.1</span> Emacs Speaks Statistics for **R** and python(?) {#emacs-speaks-statistics-for-r-and-python}

Figure out babel/org-tangle or whatever because Emacs sucks for
RMarkdown and org-mode is generally better (see next bit for RMarkdown)

```emacs-lisp
(use-package ess)
;; :ensure t
(require `ess-r-mode)
```


#### <span class="org-todo todo TODO">TODO</span> <span class="section-num">5.1.1</span> Polymodes for R {#polymodes-for-r}

This helps integrate ESS into markdown so editing RMarkdown files is
easy. As an added benefit syntax for regular markdown files is
supported. I won't have to install `polymode` itself explicitly since
it's a dependency for the `poly-R` modes and will be pulled
automatically. I do vaguely remember some issues this caused, will
have to

```emacs-lisp
(use-package poly-R
  :config
  (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

  :hook
  (poly-markdown-mode . flyspell-mode)
  (poly-markdown-mode . visual-line-mode)
  (poly-markdown-mode . auto-fill-mode))
```


#### <span class="org-todo todo TODO">TODO</span> <span class="section-num">5.1.2</span> defining org-skeleton for org-babel + R {#defining-org-skeleton-for-org-babel-plus-r}

Got this from [worg documentation](https://orgmode.org/worg/org-contrib/babel/how-to-use-Org-Babel-for-R.html) but I vaguely remember reading about
more options for individual source blocks so will have to change /
append accordingly. This defines a skeleton or a format for an org
file header that's specific to writing and running R code. It's bound
to a keybind so it can be accessed easily on opening a fresh org-babel
document.

The other resource was: [R source blocks in Org Mode](https://orgmode.org/worg/org-contrib/babel/languages/ob-doc-R.html)

More info from the page:

1.  The `#+INFOJS_OPT` option will generate a HTML document that is
    foldable and follows the style of GNU/INFO document.
2.  The `:session *R*` option makes sure all the R code is run in the same
    session so objects generated in one code block can be accessed from
    other code blocks.
3.  the `:cache yes` option is used to avoid re-evaluating unchanged code
    blocks. This can save significant time when you revise a document
    with a lot of R code frequently.
4.  The `:results output graphics :exports both` option will put both the
    R code and its text and graphics output in the generated document.
5.  The `:tangle yes` option allows the document to be "tangled" to
    generate pure code file. The short-cut key for tangling is `C-c C-v
       t`, which generates a .R file with all the R code extracted.
6.  Note the `–—` string will generate a horizontal line in HTML file.
7.  Finally, a hotkey `C-S-f4` (while pressing Ctrl and Shift keys, press
    F4 key) is assigned to invoke this skeleton quickly.

<!--listend-->

```emacs-lisp

(define-skeleton org-skeleton
  "Header info for a emacs-org file."
  "Title: "
  "#+TITLE:" str " \n"
  "#+AUTHOR: Brihaadeesh S \n"
  "#+email: brihadeesh.santharam@gmail.com\n"
  "#+INFOJS_OPT: \n"
  "#+BABEL: :session *R* :cache yes :results output graphics :exports both :tangle yes \n"
  "-----"
 )

(global-set-key [C-S-f4] 'org-skeleton)

```


### <span class="section-num">5.2</span> org-present for presentations {#org-present-for-presentations}

See [dawiwil's section on this](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org#presentations) from his literate init for more about
this.


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">5.3</span> Citar for reference management? {#citar-for-reference-management}

[Citar](https://github.com/bdarcus/citar)

If I ever get down to writing papers, of course, I'd write them in
`org-mode` or LaTeX so this should be useful considering `Mendeley
desktop` is bloat and I haven't a clue if FreeBSD even has
`Zotero`. This has additional setup stuff to do with Embark and the
rest of that family. This particular config only works with
`org-mode`. Needs a shit ton of work to properly setup.

Also perhaps check out [org-ref](https://github.com/jkitchin/org-ref) - it _seems a lot
simpler_. [Introduction to org-ref](https://www.youtube.com/watch?v=2t925KRBbFc) - a video ontroduction

```emacs-lisp
;;(use-package citar
  ;;:no-require
  ;;:custom
  ;;(org-cite-global-bibliography '("~/bib/references.bib"))
  ;;(org-cite-insert-processor 'citar)
  ;;(org-cite-follow-processor 'citar)
  ;;(org-cite-activate-processor 'citar)
  ;; optional: org-cite-insert is also bound to C-c C-x C-@
  ;;:bind
  ;;(:map org-mode-map :package org ("C-c b" . #'org-cite-insert)))
```


## <span class="section-num">6</span> Project management and navigation - projectile {#project-management-and-navigation-projectile}

```emacs-lisp
;; project management
(use-package projectile
  ;; :ensure t
  :demand t
  :init (setq projectile-completion-system 'default)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  ;; :diminish projectile-mode
  :config
  (setq projectile-project-search-path '("~/my_gits/" "~/journal/"))
  (projectile-mode +1))



;; (use-package ibuffer-projectile
;;   :after ibuffer
;;   :preface
;;   (defun my/ibuffer-projectile ()
;;     (ibuffer-projectile-set-filter-groups)
;;     (unless (eq ibuffer-sorting-mode 'alphabetic)
;;       (ibuffer-do-sort-by-alphabetic)))
;;   :hook (ibuffer . my/ibuffer-projectile))
```


## <span class="section-num">7</span> Denote for note-taking {#denote-for-note-taking}

I hope this is considerably simpler than org-roam and easier to
setup. I don't particularly like the way org-roam is unnecessarily
cluttered and excruciatingly tedious to even get started with.


### <span class="section-num">7.1</span> Basic setup {#basic-setup}

```emacs-lisp
(use-package denote
    :straight (:source gnu-elpa-mirror)

  :config
  ;; Remember to check the doc strings of those variables.
  (setq denote-directory (expand-file-name "~/documents/denotes/")

        ;; keywords
        denote-known-keywords '("emacs" "r-stats" "work" "thoughts" "politics" "blog-ideas")

        ;; check
        denote-infer-keywords t

        ;; check
        denote-sort-keywords t

        ;; Org is the default, set others here
        denote-file-type nil

        ;; entry prompt asks for title and keywords
        denote-prompts '(title keywords)

        ;; Pick dates, where relevant, with Org's advanced interface:
        denote-date-prompt-use-org-read-date t

        ;; We allow multi-word keywords by default.  The author's
        ;; personal preference is for single-word keywords for a more
        ;; rigid workflow.
        denote-allow-multi-word-keywords t

        ;; read doc string
        denote-date-format nil

        ;; By default, we fontify backlinks in their bespoke buffer.
        denote-link-fontify-backlinks t)

        ;; Also see `denote-link-backlinks-display-buffer-action'
        ;; which is a bit advanced.

  ;; If you use Markdown or plain text files (Org renders links as buttons
  ;; right away)
  (add-hook 'find-file-hook #'denote-link-buttonize-buffer)

  ;; We use different ways to specify a path for demo purposes.
  (setq denote-dired-directories
        (list denote-directory
              (thread-last denote-directory (expand-file-name "attachments"))
              (expand-file-name "~/documents/denotes/books")))

  ;; Generic (great if you rename files Denote-style in lots of places):
  ;; (add-hook 'dired-mode-hook #'denote-dired-mode)
  ;;
  ;; OR if only want it in `denote-dired-directories':
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">7.2</span> Denote templates {#denote-templates}

This should replace capture templates because the interactive `denote`
call seems a lot more flexible and versatile. Still WIP

```emacs-lisp

(setq denote-templates
      `((note . "* Some heading\n\n* Another heading")
        (memo . ,(concat "* Some heading"
                         "\n\n"
                         "* Another heading"
                         "\n\n"))
        (journal-entry . "* Date\n\n** Time")))


```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">7.3</span> "convenience commands" for journal entries {#convenience-commands-for-journal-entries}

```emacs-lisp

;; (defun peremacs/denote-journal-entry ()
;;   "Create journal entry and prompt for a subdirectory.

;; This is equivalent to calling `denote' when `denote-prompts' is
;; set to '(template subdirectory title keywords)."
;;   (declare (interactive-only t))
;;   (interactive)
;;   (let ((denote-prompts '(subdirectory keywords)))
;;     (denote-)
;;     (call-interactively #'denote)))


(defun peremacs/denote-journal-entry ()
"Create an entry tagged 'journal' with the date as its title."
(interactive)
(denote
 ;; format title like Tuesday 14 June 2022
 (format-time-string "%A %e %B %Y")
 ;; add 'journal' keywords; multiple is a list of strings: '("one" "two")
 '("journal")
 ;; prompt for subdirectory (?)
 (denote--subdirectory-prompt)))

```

Stolen from somewhere

```emacs-lisp

(defun journal-day-exists-p ( target )
  "check if journal for a day already exists"
  (file-expand-wildcards (concat "~/journal/entries/" target "*.org")))

(defun find-previous-journal ()
  "Find most recent journal"
  (let* ((today (format-time-string "%Y%m%d"))
         (all_journals (sort (directory-files "~/journal/entries" nil "^[0-9].*.*org$") #'string>)))
    (dolist (journal all_journals)
      (when (string< (substring journal 0 8) today)
        (return journal)))))

(defun my-denote-journal-today ()
  "Create an entry tagged 'journal' with the date as its title."
  (interactive)
  (let* ((today (format-time-string "%Y%m%d"))
         (filename (car (journal-day-exists-p today)))
         (prev (find-previous-journal)))
    (if filename
        (find-file filename)
      (progn
        (denote
         (format-time-string "%a %d %m %Y (%H:%M)")   ; format like Tuesday 14 Jun 2022
         nil
         "~/journal/entries")
        (insert "* THOUGHTS\n\n* IDEAS\n\n* CODE\n\n* TASKS\n\n")
        (save-buffer)))))

(defun my-denote-journal-date()
  (declare (interactive-only t))
  (interactive)
  (let* ((date (org-read-date nil t))
         (filename (car (journal-day-exists-p (format-time-string "%Y%m%d" date)))))
    (if filename
        (find-file filename)
      (progn
        (denote
         (format-time-string "%a %d %m %Y" date)   ; format like Tuesday 14 June 2022
         nil
         "~/journal/entries")))))

```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">7.4</span> Keybindings {#keybindings}

Denote DOES NOT define any key bindings. It requires arguments
acceptable to the `bind-keys` macro. I'm not entirely sure some of these
are necessary since I'm using a capture template.

```emacs-lisp
;; :bind
;; (("C-c n n" . denote)
;;  ("C-c n N" . denote-type)
;;  ("C-c n d" , denote-date)
;;  ("C-c n s" . denote-subdirectory)
;;  ("C-c n t" . denote-template)
;;  ;; renames don't work with `dired-mode', hence placed here
;;  ("C-c n r" . denote-rename-file)
;;  ("C-c n R" . denote-rename-file-using-front-matter)

;;  ;; org-mode specifics (group with `global-mode-map' for multiple formats
;;  ;; or add for each `markdown'/`text'/`org' if using single format)
;;  :map org-mode-map
;;  ("C-c n i" . denote-link) ; "insert" mnemonic
;;  ("C-c n I" . denote-link-add-links)
;;  ("C-c n b" . denote-link-backlinks)
;;  ("C-c n f f" . denote-link-find-file)
;;  ("C-c n f b" . denote-link-find-backlink)

;;  ;; specific to dired
;;  :map dired-mode-map
;;  ("C-c C-d C-i" . denote-link-dired-marked-notes)
;;  ("C-c C-d C-r" . denote-dired-rename-marked-files)
;;  ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter)
;;  ;; Also check the commands `denote-link-after-creating',
;;  ;; `denote-link-or-create'.  You may want to bind them to keys as well.
;; )

)
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">7.5</span> `org-journal` for journaling requirements {#org-journal-for-journaling-requirements}

This needs better setting up and integration with either `Orgzly` or
`GitJournal` for android. iOS seems to have better apps though. Or
just make this workable with the termux version of Emacs.

```emacs-lisp
(use-package org-journal
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")

  :bind
  ;; (("C-c t" . journal-file-today)
  ;;  ("C-c y" . journal-file-yesterday))

  :config
  ;; Journal directory and files
  (setq org-journal-dir "~/journal/entries/"
        org-journal-file-format "%Y/%m/%Y%m%d.org"
        org-journal-file-type 'daily
        org-journal-find-file 'find-file)

  ;; Journal file content
  (setq org-journal-date-format "%e %b %Y (%A)"
        org-journal-time-format "(%R)"
        org-journal-file-header "#+title: Daily Journal\n#+startup: showeverything")
  )
```


## <span class="section-num">8</span> Version control {#version-control}


### <span class="section-num">8.1</span> Git with Magit and gists with `gist.el` {#git-with-magit-and-gists-with-gist-dot-el}

<a id="code-snippet--magit-config"></a>
```emacs-lisp
(use-package magit
  :bind ("C-x g"    . magit-status))
```

`gist.el` to manage github gists from here

<a id="code-snippet--gists-config"></a>
```emacs-lisp
(use-package gist)
```


### <span class="section-num">8.2</span> Undo tree {#undo-tree}

Helps revert to older versions of files in case I fuck up something
somewhere. Hmm. I doubt I ever use it so disabling it now.

```emacs-lisp
(use-package undo-tree
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))
        undo-tree-auto-save-history nil)
  (global-undo-tree-mode)
  :diminish undo-tree-mode)
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">8.3</span> SSH for personal packages and magit {#ssh-for-personal-packages-and-magit}

This needs a ton of work

```emacs-lisp
(use-package keychain-environment
    :config
    (keychain-refresh-environment))

;; ;; import ssh deets from profile
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-copy-env "SSH_AGENT_PID")
;;   (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))
```


## <span class="section-num">9</span> Minibuffer completion {#minibuffer-completion}


### <span class="section-num">9.1</span> Access a list of recently edited files {#access-a-list-of-recently-edited-files}

Helps jump back into whatever I was doing before closing Emacs. Or my
laptop more like it.

```emacs-lisp
(use-package recentf
  :init
  (setq recentf-max-menu-items 25
        recentf-auto-cleanup 'never
        recentf-keep '(file-remote-p file-readable-p))
  (recentf-mode 1))
```


### <span class="section-num">9.2</span> Vertico for completions UI {#vertico-for-completions-ui}

```emacs-lisp
;; Enable vertico
(use-package vertico
  ;; pulls extensions as well?
  ;; :straight (:host github :repo "minad/vertico")

  :init
  (vertico-mode)

  :config
  (setq
   ;; Grow and shrink the Vertico minibuffer
   vertico-resize t

   ;; No prefix with number of entries
   vertico-count-format nil)

  (advice-add #'tmm-add-prompt :after #'minibuffer-hide-completions)
```

(Continuing from previous block)

Completion-at-point and completion-in-region with Vertico. Use
\`consult-completion-in-region' if Vertico is enabled. Otherwise use
the default \`completion--in-region' function. Disabled because I use
corfu for `completion-at-point`.

```emacs-lisp
;; (setq completion-in-region-function
;;           (lambda (&rest args)
;;             (apply (if vertico-mode
;;                        #'consult-completion-in-region
;;                      #'completion--in-region)
;;                    args)))
```

Prefix the current candidate (See [relevant section on the wiki](https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow))

```emacs-lisp
(defun minibuffer-format-candidate (orig cand prefix suffix index _start)
    (let ((prefix (if (= vertico--index index)
                      "  "
                    "   ")))
      (funcall orig cand prefix suffix index _start)))

  (advice-add #'vertico--format-candidate
             :around #'minibuffer-format-candidate)
```

Completions for `M-:` as well; closes the use-package function started
at Vertico header.

```emacs-lisp
(defun minibuffer-vertico-setup ()

  (setq truncate-lines t)
  (setq completion-in-region-function
        (if vertico-mode
            #'consult-completion-in-region
          #'completion--in-region)))

(add-hook 'vertico-mode-hook #'minibuffer-vertico-setup)
(add-hook 'minibuffer-setup-hook #'minibuffer-vertico-setup)
)
```


#### <span class="org-todo todo TODO">TODO</span> <span class="section-num">9.2.1</span> Vertico extensions {#vertico-extensions}

Again stolen from Karthik Chikmaglur and needs heavy work, hence not enabled

<a id="code-snippet--vertico-multiform"></a>
```emacs-lisp
(use-package vertico-multiform
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  :commands vertico-multiform-mode
  :after vertico-flat
  :bind (:map vertico-map
              ("M-q" . vertico-multiform-grid)
              ("C-l" . vertico-multiform-unobtrusive)
              ("C-M-l" . embark-export))
  :init (vertico-multiform-mode 1)
  :config
  (setq vertico-multiform-categories
         '((file my/vertico-grid-mode reverse)
           (project-file my/vertico-grid-mode reverse)
           (imenu buffer)
           (consult-location buffer)
           (consult-grep buffer)
           (notmuch-result reverse)
           (minor-mode reverse)
           (reftex-label reverse)
           (bib-reference reverse)
           (xref-location reverse)
           (t unobtrusive)))
   (setq vertico-multiform-commands
         '((load-theme my/vertico-grid-mode reverse)
           (my/toggle-theme my/vertico-grid-mode reverse)
           (consult-dir-maybe reverse)
           (consult-dir reverse)
           (consult-history reverse)
           (consult-completion-in-region reverse)
           (completion-at-point reverse)
           (org-roam-node-find reverse)
           (embark-completing-read-prompter reverse)
           (embark-act-with-completing-read reverse)
           (embark-prefix-help-command reverse)
           (tmm-menubar reverse)))

   (defun vertico-multiform-unobtrusive ()
     "Toggle the quiet display."
     (interactive)
     (vertico-multiform--display-toggle 'vertico-unobtrusive-mode)
     (if vertico-unobtrusive-mode
         (vertico-multiform--temporary-mode 'vertico-reverse-mode -1)
       (vertico-multiform--temporary-mode 'vertico-reverse-mode 1))))
```

<a id="code-snippet--vertico-unobtrusive"></a>
```emacs-lisp
(use-package vertico-unobtrusive
  :load-path "~/.local/share/git/vertico/extensions/"
  :after vertico-flat)
```

\#+name vertico-grid

```emacs-lisp
(use-package vertico-grid
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  :after vertico
  ;; :bind (:map vertico-map ("M-q" . vertico-grid-mode))
  :config
  (defvar my/vertico-count-orig vertico-count)
  (define-minor-mode my/vertico-grid-mode
    "Vertico-grid display with modified row count."
    :global t :group 'vertico
    (cond
     (my/vertico-grid-mode
      (setq my/vertico-count-orig vertico-count)
      (setq vertico-count 4)
      (vertico-grid-mode 1))
     (t (vertico-grid-mode 0)
        (setq vertico-count my/vertico-count-orig))))
  (setq vertico-grid-separator "    ")
  (setq vertico-grid-lookahead 50))
```

<a id="code-snippet--vertico-quick"></a>
```emacs-lisp
(use-package vertico-quick
      :load-path "~/.emacs.d/lisp/vertico-extensions/"
      :after vertico
      :bind (:map vertico-map
             ("M-i" . vertico-quick-insert)
             ("C-'" . vertico-quick-exit)
             ("C-o" . vertico-quick-embark))
      :config
      (defun vertico-quick-embark (&optional arg)
        "Embark on candidate using quick keys."
        (interactive)
        (when (vertico-quick-jump)
          (embark-act arg))))
```

<a id="code-snippet--vertico-directory"></a>
```emacs-lisp
(use-package vertico-directory
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  :hook (rfn-eshadow-update-overlay vertico-directory-tidy)
  :after vertico
  :bind (:map vertico-map
         ("DEL"   . vertico-directory-delete-char)
         ("M-DEL" . vertico-directory-delete-word)
         ("C-w"   . vertico-directory-delete-word)
         ("RET"   . vertico-directory-enter)))
```

<a id="code-snippet--vertico-repeat"></a>
```emacs-lisp
(use-package vertico-repeat
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  :after vertico
  :bind (("C-x ." . vertico-repeat)))
```

<a id="code-snippet--vertico-reverse"></a>
```emacs-lisp
(use-package vertico-reverse
  ;; :disabled
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  :after vertico)
```

<a id="code-snippet--vertico-repeat"></a>
```emacs-lisp
(use-package vertico-flat
  :load-path "~/.emacs.d/lisp/vertico-extensions/"
  ;; :bind (:map vertico-map
  ;;             ("M-q" . vertico-flat-mode))
  :after vertico)
```

<a id="code-snippet--vertico-buffer"></a>
```emacs-lisp
(use-package vertico-buffer
      :load-path "~/.emacs.d/lisp/vertico-extensions/"
      :after vertico
      ;; :hook (vertico-buffer-mode . vertico-buffer-setup)
      :config
      (setq vertico-buffer-display-action 'display-buffer-reuse-window))
```


### <span class="section-num">9.3</span> Orderless completion {#orderless-completion}

Search for commands, buffers, etc with vertico without having to match
the order of words in the command. Adding spaces between keywords can
match commands with those words anywhere in them. This config was
bootlegged from [minad's config at the consult wiki](https://github.com/minad/consult/wiki#minads-orderless-configuration).

```emacs-lisp
(use-package orderless
  :config
(defvar +orderless-dispatch-alist
  '((?% . char-fold-to-regexp)
    (?! . orderless-without-literal)
    (?`. orderless-initialism)
    (?= . orderless-literal)
    (?~ . orderless-flex)))

;; Recognizes the following patterns:
;; * ~flex flex~
;; * =literal literal=
;; * %char-fold char-fold%
;; * `initialism initialism`
;; * !without-literal without-literal!
;; * .ext (file extension)
;; * regexp$ (regexp matching at end)
(defun +orderless-dispatch (pattern index _total)
  (cond
   ;; Ensure that $ works with Consult commands, which add disambiguation suffixes
   ((string-suffix-p "$" pattern)
    `(orderless-regexp . ,(concat (substring pattern 0 -1) "[\x100000-\x10FFFD]*$")))
   ;; File extensions
   ((and
     ;; Completing filename or eshell
     (or minibuffer-completing-file-name
         (derived-mode-p 'eshell-mode))
     ;; File extension
     (string-match-p "\\`\\.." pattern))
    `(orderless-regexp . ,(concat "\\." (substring pattern 1) "[\x100000-\x10FFFD]*$")))
   ;; Ignore single !
   ((string= "!" pattern) `(orderless-literal . ""))
   ;; Prefix and suffix
   ((if-let (x (assq (aref pattern 0) +orderless-dispatch-alist))
        (cons (cdr x) (substring pattern 1))
      (when-let (x (assq (aref pattern (1- (length pattern))) +orderless-dispatch-alist))
        (cons (cdr x) (substring pattern 0 -1)))))))

;; Define orderless style with initialism by default
(orderless-define-completion-style +orderless-with-initialism
  (orderless-matching-styles '(orderless-initialism orderless-literal orderless-regexp)))

;; You may want to combine the `orderless` style with `substring` and/or `basic`.
;; There are many details to consider, but the following configurations all work well.
;; Personally I (@minad) use option 3 currently. Also note that you may want to configure
;; special styles for special completion categories, e.g., partial-completion for files.
;;
;; 1. (setq completion-styles '(orderless))
;; This configuration results in a very coherent completion experience,
;; since orderless is used always and exclusively. But it may not work
;; in all scenarios. Prefix expansion with TAB is not possible.
;;
;; 2. (setq completion-styles '(substring orderless))
;; By trying substring before orderless, TAB expansion is possible.
;; The downside is that you can observe the switch from substring to orderless
;; during completion, less coherent.
;;
;; 3. (setq completion-styles '(orderless basic))
;; Certain dynamic completion tables (completion-table-dynamic)
;; do not work properly with orderless. One can add basic as a fallback.
;; Basic will only be used when orderless fails, which happens only for
;; these special tables.
;;
;; 4. (setq completion-styles '(substring orderless basic))
;; Combine substring, orderless and basic.
;;
(setq completion-styles '(orderless)
      completion-category-defaults nil
      ;;; Enable partial-completion for files.
      ;;; Either give orderless precedence or partial-completion.
      ;;; Note that completion-category-overrides is not really an override,
      ;;; but rather prepended to the default completion-styles.
      ;; completion-category-overrides '((file (styles orderless partial-completion))) ;; orderless is tried first
      completion-category-overrides '((file (styles partial-completion)) ;; partial-completion is tried first
                                      ;; enable initialism by default for symbols
                                      (command (styles +orderless-with-initialism))
                                      (variable (styles +orderless-with-initialism))
                                      (symbol (styles +orderless-with-initialism)))
      orderless-component-separator #'orderless-escapable-split-on-space ;; allow escaping space with backslash!
      orderless-style-dispatchers '(+orderless-dispatch)))
```


### <span class="section-num">9.4</span> Persistent command history {#persistent-command-history}

Persist history over Emacs restarts. Vertico sorts by history position.

```emacs-lisp
(use-package savehist
    :init
    (savehist-mode))
```


### <span class="section-num">9.5</span> A few more useful configurations {#a-few-more-useful-configurations}

```emacs-lisp
;; (use-package emacs
  ;; :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t)
  ;; )
```


### <span class="section-num">9.6</span> Richer annotations in minubuffer {#richer-annotations-in-minubuffer}

```emacs-lisp
(use-package marginalia
  :after vertico

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode)

  ;; When using Selectrum, ensure that Selectrum is refreshed when cycling annotations.
  ;; (advice-add #'marginalia-cycle :after
  ;;             (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit 'keep-selected))))

  ;; Prefer richer, more heavy, annotations over the lighter default variant.
  ;; E.g. M-x will show the documentation string additional to the keybinding.
  ;; By default only the keybinding is shown as annotation.
  ;; Note that there is the command `marginalia-cycle' to
  ;; switch between the annotators.
  ;; (setq marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  )
```


### <span class="section-num">9.7</span> Consult adds more minibuffer functionality {#consult-adds-more-minibuffer-functionality}

```emacs-lisp
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind
  (("C-x B" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-project-imenu)
   ;; searching for files
   ("M-s f" . consult-find)
   ("M-s F" . consult-git-grep)
   ("M-s g" . consult-grep)
   ("M-s r" . consult-ripgrep)
   ("C-c f r" . consult-recent-file)
   ("C-x C-" . consult-recent-file)
   ;; Isearch integration
   ("C-s" . consult-isearch-history)
   ("C-c L" . consult-outline)
   ("C-c h l" . consult-org-heading)
   ;; yank from kill-ring
   ("M-y" . consult-yank-pop)
   )

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI. You may want to also
  ;; enable `consult-preview-at-point-mode` in Embark Collect buffers.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :config
  ;; Configure the narrowing key.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Configure a function which returns the project
  ;; root directory - projectile.el (projectile-project-root)
  (autoload 'projectile-project-root "projectile")
  (setq consult-project-root-function #'projectile-project-root)

  ;; use consult with perspective.el
  (consult-customize consult--source-buffer :hidden t :default nil)

  (defvar consult--source-perspective
    (list :name     "Perspective"
          :narrow   ?s
          :category 'buffer
          :state    #'consult--buffer-state
          :default  t
          :items    #'persp-get-buffer-names))

  (push consult--source-perspective consult-buffer-sources)
  )

;; Optionally add the `consult-flycheck' command.
(use-package consult-flycheck
  :bind (:map flycheck-command-map
              ("!" . consult-flycheck)))
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">9.8</span> Consult interface for denote {#consult-interface-for-denote}

I haven't really figured out how to programmatically add additional
functionality/features for consult, nor have I figured out denote.  I
got this from one random [blog post](https://whhone.com/posts/denote-with-subdirectories/) about denote while looking for how
people use denote to work with sub-directories. I've just grabbed the
files from their [package](https://codeberg.org/whhone/consult-denote/) for now but I might need to extend this if I
end up switching to using denote for journaling.

```emacs-lisp

(use-package consult-denote
   :straight (consult-denote :type git :host codeberg :repo "whhone/consult-denote"))

```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">9.9</span> Embark - actions; reorganise {#embark-actions-reorganise}

This I've not used yet but makes a lot of stuff easier like
searchingfor the `definition` or the `help/info` page a highlighted
word from within the buffer or the minibuffer or even the minibuffer
completion list.

**Group with the rest of the packages from this family?**

```emacs-lisp
(use-package embark
  :bind
  (("C-S-a" . embark-act)       ;; pick some comfortable binding
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
```


## <span class="section-num">10</span> Corfu for completion in buffer {#corfu-for-completion-in-buffer}

This might need some more work - integration with [minad's `cape`](https://github.com/minad/cape) for
various kinds of completions although he alleges this works well with
base Emacs.

<a id="code-snippet--corfu-competions"></a>
```emacs-lisp

(use-package corfu
  :bind
  (:map corfu-map
         ;; ??? :states 'insert
         ("TAB" . corfu-next)
         ([tab] . corfu-next)
         ("S-TAB" . corfu-previous)
         ([backtab] . corfu-previous)
         ("<escape>" . corfu-quit)
         ("<return>" . corfu-insert)
         ("M-d" . corfu-show-documentation)
         ("M-l" . 'corfu-show-location)
         ("SPC" . corfu-insert-separator))

  :custom
  ;; Only use `corfu' when calling `completion-at-point' or
  ;; (corfu-auto t)

  ;; `indent-for-tab-command'
  ;; (corfu-auto-prefix 3)
  ;; (corfu-auto-delay 0.2)

  ;; size
  (corfu-min-width 80)

  ;; Always have the same width
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle t)

  ;; Show documentation in echo area?
  (corfu-echo-documentation t)

  ;; Preselect first candidate?
  (corfu-preselect-first nil)

  ;; Preview current candidate?
  (corfu-preview-current 'insert)

  ;; quit if no match
  (corfu-quit-no-match t)

  :init
  (global-corfu-mode))

```


### <span class="section-num">10.1</span> CAPE - extensions for corfu {#cape-extensions-for-corfu}

Corfu needs `cape` to provide completion backends because it's extremely
stripped down. Will have to check what other backends I'll need to
enable.

```emacs-lisp
(use-package cape
    :config
    (setq cape-dabbrev-min-length 2)

    :init
    ;; Add `completion-at-point-functions', used by `completion-at-point'.

    (dolist (backend '( cape-file cape-dabbrev cape-keyword cape-abbrev
                        cape-ispell cape-dict cape-symbol cape-line ))
                     (add-to-list 'completion-at-point-functions backend)))

(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-keyword)
(add-to-list 'completion-at-point-functions #'cape-ispell)
(add-to-list 'completion-at-point-functions #'cape-dict)
(add-to-list 'completion-at-point-functions #'cape-symbol)
```


## <span class="section-num">11</span> Look {#look}


### <span class="section-num">11.1</span> Font configuration {#font-configuration}


#### <span class="section-num">11.1.1</span> Setting a font {#setting-a-font}

```emacs-lisp

;; first set default
(set-face-attribute 'default nil :family "Hack" :height 70)

;; then set variable-pitch fonts
(set-face-attribute 'variable-pitch nil :family "Iosevka Aile" :height 1.1)

;; finally set fixed-pitch
(set-face-attribute 'fixed-pitch nil :family "Hack" :height 1.0)

```


#### <span class="section-num">11.1.2</span> Line spacing {#line-spacing}

Usually 0, less if possible but Emacs doesn't allow for that.

```emacs-lisp
;; Line spacing, can be 0 for code and 1 or 2 for text
(setq-default line-spacing 0.1)
```


### <span class="section-num">11.2</span> Editor theme {#editor-theme}

Update: <span class="timestamp-wrapper"><span class="timestamp">&lt;2022-11-21 Mon&gt; </span></span> Moved this up so it doesn't throw the cryptic
error with Modus themes: `Debugger entered--Lisp error: (wrong-number-of-arguments (1
. 2) 8)` This is based on [Adam Spiers's comment](https://gitlab.com/protesilaos/modus-themes/-/issues/306#note_1147003189) - the theme should be
loaded before `custom.el` is pulled in to avoid issues with version
mismatch like the shit with the `org` package.


#### <span class="section-num">11.2.1</span> ef-themes {#ef-themes}

```emacs-lisp

(use-package ef-themes
  :config
  ;; If you like two specific themes and want to switch between them, you
  ;; can specify them in `ef-themes-to-toggle' and then invoke the command
  ;; `ef-themes-toggle'.  All the themes are included in the variable
  ;; `ef-themes-collection'.
  (setq ef-themes-to-toggle '(ef-night ef-duo-dark ef-winter))

  (setq ef-themes-headings ; read the manual's entry or the doc string
        '((0 . (variable-pitch light 1.2))
          (1 . (variable-pitch light 1.1))
          (2 . (variable-pitch regular))
          (3 . (variable-pitch regular))
          (4 . (variable-pitch regular))
          (5 . (variable-pitch)) ; absence of weight means `bold'
          (6 . (variable-pitch))
          (7 . (variable-pitch))
          (t . (variable-pitch))))

  ;; They are nil by default...
  (setq ef-themes-mixed-fonts t
        ef-themes-variable-pitch-ui t)

  ;; Read the doc string or manual for this one.  The symbols can be
  ;; combined in any order.
  (setq ef-themes-region '(intense no-extend neutral))

  ;; Disable all other themes to avoid awkward blending:
  (mapc #'disable-theme custom-enabled-themes)

  ;; Load the theme of choice:
  ;; (load-theme 'ef-summer :no-confirm)

  ;; OR use this to load the theme which also calls `ef-themes-post-load-hook':
  ;; (ef-themes-select 'ef-winter)

  ;; The themes we provide are recorded in the `ef-themes-dark-themes',
  ;; `ef-themes-light-themes'.

  ;; We also provide these commands, but do not assign them to any key:
  ;;
  ;; - `ef-themes-toggle'
  ;; - `ef-themes-select'
  ;; - `ef-themes-load-random'
  ;; - `ef-themes-preview-colors'
  ;; - `ef-themes-preview-colors-current'
  )

```


#### <span class="section-num">11.2.2</span> Modus from Protesilaos! {#modus-from-protesilaos}

This might need additional setting since modus themes are now included
within Emacs

```emacs-lisp
(use-package modus-themes
  :straight (:source gnu-elpa-mirror)

  :init
  (setq modus-themes-mixed-fonts t
        modus-themes-bold-constructs t
        modus-themes-italic-constructs t
        modus-themes-region '(no-extend)
        modus-themes-mode-line '(accented)
        modus-themes-prompts '(backgound bold intense)
        ;; modus-themes-hl-line 'accented
        modus-themes-intense-markup t
        modus-themes-region '(no-extend bg-only)
        modus-themes-subtle-line-numbers t
        modus-themes-fringes '(subtle)
        modus-themes-language-checkers '(straight-underline faint)
        modus-themes-org-blocks '(gray-background)

        modus-themes-completions
        '((matches . (bold background intense))
          (selection . (bold background intense))
          (popup . (accented))))

  (defun peremacs/call-modus-operandi ()
    (interactive)
    ;; heading backgrounds work better here
    (disable-theme 'modus-vivendi)
    (setq modus-themes-headings
          '((1 . (overline background variable-pitch bold 1.1))
            (2 . (overline background variable-pitch bold))
            (3 . (overline background variable-pitch semibold))
            (4 . (overline background variable-pitch semibold))
            (t . (overline variable-pitch semibold))))
    (modus-themes-load-operandi))

  (defun peremacs/call-modus-vivendi ()
    (interactive)
    (disable-theme 'modus-operandi)
    (setq modus-themes-headings
          '((1 . (overline monochrome variable-pitch bold 1.1))
            (2 . (overline monochrome variable-pitch bold))
            (3 . (overline monochrome variable-pitch semibold))
            (4 . (overline monochrome variable-pitch semibold))
            (t . (overline variable-pitch semibold))))
    (modus-themes-load-vivendi))


  ;; set semibold as the bold face
  ;; (for those fonts that provide this face)
  ;; (set-face-attribute 'bold nil :weight 'semibold)


  ;; :config
  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)

  ;; Load the theme of your choice:
  ;; (peremacs/call-modus-operandi)
  (peremacs/call-modus-vivendi)
)

```


#### <span class="section-num">11.2.3</span> Commentary {#commentary}

An elegant theme highlighting comments only

```emacs-lisp

(use-package commentary-theme
  ;;:config
  ;;(load-theme 'commentary t)
  )

```


#### <span class="section-num">11.2.4</span> My themes {#my-themes}

Neither of these work using `straight.el` or `use-package`, together
or separately (afaik). If these work, I could maybe add some more of
my own.

Forked from the [colorless-themes macro](https://github.com/lthms/colorless-themes). This includes my version of
the macro, original themes from Thomas Letan, and some additional
themes of my own that use this macro.

```emacs-lisp

(use-package colourless-themes
    :straight (:host gitlab :repo "peregrinator/colourless-themes-el")
    ;;:config
    ;;(load-theme 'beelzebub t)
    )

```


#### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5</span> unused {#unused}


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.1</span> Wilmersdorf {#wilmersdorf}

I saw this on [doom-themes](https://github.com/hlissner/emacs-doom-themes) but I don't want to pull all of those just
for this, so installing from it's [GitHub](https://github.com/ianyepan/wilmersdorf-emacs-theme) using `straight.el`. But it
fails to load with `use-package` so I'm going to have to do it manually.

```emacs-lisp
(use-package wilmersdorf
  :straight (:host github :repo "ianyepan/wilmersdorf-emacs-theme")

  ;; :config
  ;; (load-theme 'wilmersdorf t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.2</span> Tao {#tao}

Monochrome theme with minimal bold highlights and boxes?

```emacs-lisp
(use-package tao-theme
  :config
  ;; load theme
  (load-theme 'tao-yang t)
  ;; (load-theme 'tao-yin t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.3</span> Expresso {#expresso}

```emacs-lisp
(use-package espresso-theme
    :straight (:host github :repo "dgutov/espresso-theme")
    ;;:config
    (load-theme 'espresso t)
    )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.4</span> Github dark {#github-dark}

```emacs-lisp
(use-package github-dark-vscode-theme
  :config
  (load-theme 'github-dark-vscode t)

  ;; fixed upstream
  ;; unrelated but the cursor colour really needs improvement
  ;; (set-cursor-color "#ffffff")
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.5</span> Github modern (light) {#github-modern--light}

```emacs-lisp
(use-package github-modern-theme
  :config
  (load-theme 'github-modern t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.6</span> Vale {#vale}

```emacs-lisp
(use-package vale
  :straight (:type git :repo "https://codeberg.org/ext0l/vale.el")
  :config
  ;; (load-theme 'vale t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.7</span> Parchment {#parchment}

Based on the screenshot of Haskell code on the [Pragmata Pro website](https://fsd.it/shop/fonts/pragmatapro/#tab-fb289adf-7c14-8).

```emacs-lisp
(use-package Parchment-theme
  :straight (:host github :repo "brihadeesh/emacs-parchment-theme")
  :config
  ;; (load-theme 'Parchment t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.8</span> Almost mono {#almost-mono}

```emacs-lisp
(use-package almost-mono-themes
  :config
  ;; (load-theme 'almost-mono-black t)
  ;; (load-theme 'almost-mono-gray t)
  ;; (load-theme 'almost-mono-cream t)
  ;; (load-theme 'almost-mono-white t)
  )
```


##### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">11.2.5.9</span> Stimmung themes for nearly monochrome appearance {#stimmung-themes-for-nearly-monochrome-appearance}

```emacs-lisp
(use-package stimmung-themes
  ;; :straight (stimmung-themes :host github :repo "motform/stimmung-themes") ; if you are a straight shooter
  :config
  ;; (stimmung-themes-load-dark)
  )
```


### <span class="section-num">11.3</span> Highlighted line-mode {#highlighted-line-mode}

<a id="code-snippet--cursorline"></a>
```emacs-lisp
;; cursorline
(global-hl-line-mode 1)
```


### <span class="section-num">11.4</span> Solid window dividers {#solid-window-dividers}

```emacs-lisp
;; (setq window-divider-default-right-width 1)
;; (setq window-divider-default-bottom-width 1)
;; (setq window-divider-default-places 'all)
;; (window-divider-mode)
(setq window-divider-default-right-width 1)
(setq window-divider-default-bottom-width 1)
(setq window-divider-default-places 'right-only)
(add-hook 'after-init-hook #'window-divider-mode)
```


### <span class="section-num">11.5</span> Something about underlines {#something-about-underlines}

Underline line at descent position, not baseline position

```emacs-lisp
(setq x-underline-at-descent-line t)
```


### <span class="section-num">11.6</span> Cursor configuration {#cursor-configuration}

```emacs-lisp
(set-default 'cursor-type  '(bar . 2))
(blink-cursor-mode 1)
```


### <span class="section-num">11.7</span> Line-number format {#line-number-format}

```emacs-lisp
(setq linum-format "%4d ")
```


### <span class="section-num">11.8</span> Visual not audible bell {#visual-not-audible-bell}

Flashes modeline for warnings from [purcell](https://github.com/purcell/mode-line-bell)

```emacs-lisp
;; No sound
(setq ring-bell-function 'ignore)

(use-package mode-line-bell
  :config
  (mode-line-bell-mode))
```


### <span class="section-num">11.9</span> No Tooltips {#no-tooltips}

```emacs-lisp
(tooltip-mode 0)
```


### <span class="section-num">11.10</span> Minibuffer appearance? {#minibuffer-appearance}

As per [Hamilton9508's comment](https://www.reddit.com/r/emacs/comments/rxa29k/is_it_possible_to_have_a_window_which_is_just_the/hrhvrqw/) he makes a single minibuffer-only frame
across the bottom of the Emacs window and so the rest of the frames
have only a single buffer (i.e. the buffer being edited/used) and no
minubuffer of it's own. Not sure if this will work for me but I'll
perhaps give it a shot.

```emacs-lisp
(setq minibuffer-frame-alist '(
            (name . "minibuf")
            (menu-bar-lines . 0)
            (vertical-scroll-bars . nil)
            (auto-raise . t)
            (sticky . t)
            (left . 0)
            (top . -1)
            (height . 1)
            (internal-border-width . 0)
            (minibuffer . only)))
```


### <span class="section-num">11.11</span> Minimalist and ordered mode-line {#minimalist-and-ordered-mode-line}

People seem to use packages for this. I've considered using the
[doom-modeline](https://github.com/seagle0128/doom-modeline) but it seems to be pretty heavy in terms of dependencies
and I'd like a mode-line with a much more fundamental interface
although it's still a good contender considering it's very simple to
configure. I'm also considering [simple-mode-line](https://github.com/gexplorer/simple-modeline).


#### <span class="section-num">11.11.1</span> Mood-line because I'm fucking tired {#mood-line-because-i-m-fucking-tired}

```emacs-lisp
(use-package mood-line
  :config
  (mood-line-mode)
  )
```


### <span class="section-num">11.12</span> Pulse to locate cursor with Protesilaos's pulsar {#pulse-to-locate-cursor-with-protesilaos-s-pulsar}

```emacs-lisp

(use-package pulsar
  :straight (:host gitlab :repo "protesilaos/pulsar")

  :custom
  (pulsar-pulse-functions ; Read the doc string for why not `setq'
   '(recenter-top-bottom
     move-to-window-line-top-bottom
     reposition-window
     ;; bookmark-jump
     ;; other-window
     ;; delete-window
     ;; delete-other-windows
     forward-page
     backward-page
     scroll-up-command
     scroll-down-command
     ;; windmove-right
     ;; windmove-left
     ;; windmove-up
     ;; windmove-down
     ;; windmove-swap-states-right
     ;; windmove-swap-states-left
     ;; windmove-swap-states-up
     ;; windmove-swap-states-down
     ;; tab-new
     ;; tab-close
     ;; tab-next
     org-next-visible-heading
     org-previous-visible-heading
     org-forward-heading-same-level
     org-backward-heading-same-level
     outline-backward-same-level
     outline-forward-same-level
     outline-next-visible-heading
     outline-previous-visible-heading
     outline-up-heading))

  :config
  (setq pulsar-pulse-on-window-change t
        pulsar-pulse t
        pulsar-delay 0.055
        pulsar-iterations 10
        pulsar-face 'pulsar-cyan)

  (pulsar-global-mode 1)

  :bind
  (("C-c l" . pulsar-pulse-line)
   ("C-c h l" . pulsar-highlight-line))

  :hook
  (consult-after-jump . pulsar-recenter-top)
  (consult-after-jump . pulsar-reveal-entry))

```


### <span class="section-num">11.13</span> Display complex key-binding suggestions {#display-complex-key-binding-suggestions}

```emacs-lisp
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))
```


### <span class="section-num">11.14</span> Diminish for a cleaner modeline {#diminish-for-a-cleaner-modeline}

`org-indent-mode` doesn't get disabled by the default method.

```emacs-lisp
  (use-package diminish
    :diminish auto-fill-function
    :diminish flyspell-mode
    :diminish visual-line-mode
  )

(defun peremacs/diminish-org-indent ()
    (interactive)
    (diminish 'org-indent-mode ""))
(add-hook 'org-indent-mode-hook 'peremacs/diminish-org-indent)

```


### <span class="section-num">11.15</span> Pixel scroll precision mode (Emacs 29+) {#pixel-scroll-precision-mode--emacs-29-plus}

```emacs-lisp
(pixel-scroll-precision-mode +1)
```


### <span class="section-num">11.16</span> Make "Emacs" the **window title** {#make-emacs-the-window-title}

<a id="code-snippet--set-window-title"></a>
```emacs-lisp
(setq-default frame-title-format '("Emacs"))
```


### <span class="section-num">11.17</span> Make **scratch** buffer and **minibuffer** blank {#make-scratch-buffer-and-minibuffer-blank}

<a id="code-snippet--blank-startup"></a>
```emacs-lisp
(setq initial-scratch-message "")
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
```


### <span class="section-num">11.18</span> Show keystrokes {#show-keystrokes}

Stolen from [Karthik Chikmaglur's emacs.d](https://github.com/karthink/emacs.d); shows what is typed immediately.

```emacs-lisp
(setq echo-keystrokes 0.01)
```


## <span class="section-num">12</span> Window Management {#window-management}


### <span class="section-num">12.1</span> EXWM {#exwm}

This ofc **doesn't work** on wayland and `pgtk` emacs but am I willing
to learn C++ and emacs-lisp well enough to contribute to porting this
to wayland/wlroots or something?

```emacs-lisp
(use-package exwm
  ;; :ensure t

  :diminish

  :custom
  (exwm-workspace-number 4)

  ;; (defun exwm-start-process (command)
  ;;   "Start a process via a shell COMMAND."
  ;;   (interactive (list (read-shell-command "$ ")))
  ;;   (start-process-shell-command command nil command))

  ;; ((kbd "<s-return>") #'exwm-start-process)

  ;; (exwm-input-set-key (kbd "<s-return>") #'exwm-start-process)

  :config
  ;; This now has to be toggled separately in the `~/.xinitrc'
  ;; see https://www.reddit.com/r/emacs/comments/mjx2qd/conditional_loading_for_exwm_with_usepackage/gte7puu/
  (require 'exwm-config)
  ;; (exwm-config-default)

  ;; Effective use of EXWM requires the ability to return from char-mode to line-mode.
  ;; This will be performed with s-r.
  (exwm-input-set-key (kbd "s-r") #'exwm-reset)

  ;; Hide all windows except the current one.
  (exwm-input-set-key (kbd "s-o") #'delete-other-windows)

  ;; Close the current window and kill its buffer.
  (exwm-input-set-key (kbd "C-s-x") #'kill-buffer-and-window)

  ;; Close the current window without killing its buffer.
  (exwm-input-set-key (kbd "s-x") #'delete-window)

  ;; Open an Eshell buffer in the current buffer’s location.
  (exwm-input-set-key (kbd "C-z") #'eshell-find-eshell-here)

  ;;  Move point to the windows immediately around the current window.
  (exwm-input-set-key (kbd "s-h") #'windmove-left)
  (exwm-input-set-key (kbd "s-j") #'windmove-down)
  (exwm-input-set-key (kbd "s-k") #'windmove-up)
  (exwm-input-set-key (kbd "s-l") #'windmove-right)
  (exwm-input-set-key (kbd "s-w") #'exwm-workspace-switch))
```


### <span class="section-num">12.2</span> Workspaces with perspective-el {#workspaces-with-perspective-el}

Independent workspaces for different projects like profiles on RStudio
but perhaps a lot more dynamic. This might need more work hence adding
[a link to the project page](https://github.com/nex3/perspective-el) here.

```emacs-lisp
(use-package perspective
  :demand t

  :init
  ;; apparently it's essential to define a prefix on Emacs=28
  (setq persp-mode-prefix-key (kbd "C-x x"))

  :bind
  ;; these work with selectrum/vertico i.e. `completing-read'
  ;; type completion systems that are appararently closer to
  ;; base Emacs functioning.
  (("C-x b" . persp-switch-to-buffer*)
   ;;("C-x k" . persp-kill-buffer*)
  )

  :config
  ;; Running `persp-mode' multiple times resets the perspective list...
(unless (equal (default-value 'persp-mode) t)
  (persp-mode 1)))
```


#### <span class="section-num">12.2.1</span> persp-projectile for proper workspace window management {#persp-projectile-for-proper-workspace-window-management}

```emacs-lisp
(use-package persp-projectile
  :bind
  ("C-x x s". persp-projectile-switch-project))
```


### <span class="section-num">12.3</span> Undo disrupted window/frame arrangement after using some shit {#undo-disrupted-window-frame-arrangement-after-using-some-shit}

Stolen from [Karthik Chikmaglur's emacs.d](https://github.com/karthink/emacs.d)

```emacs-lisp
(use-package winner
  :disabled
  :commands winner-undo
  :bind (("C-x C-/" . winner-undo)
         ("s-/" . winner-undo)
         ("s-S-/" . winner-redo))
  :config
  (winner-mode +1))
```


### <span class="section-num">12.4</span> Ace-window helps with navigation between multiple windows {#ace-window-helps-with-navigation-between-multiple-windows}

Simpler navigation between open Emacs windows

```emacs-lisp
(use-package ace-window

  :init
  (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l ?o))

  :bind (("C-x o" . ace-window)
         ("M-o" . other-window)
         ("M-o" . ace-window))

  :diminish ace-window-mode)
```


##### <span class="org-todo todo TODO">TODO</span> <span class="section-num">12.4.0.1</span> Other actions that `ace-window` handles: {#other-actions-that-ace-window-handles}

```emacs-lisp
(defvar aw-dispatch-alist
'((?x aw-delete-window "Delete Window")
      (?m aw-swap-window "Swap Windows")
      (?M aw-move-window "Move Window")
      (?c aw-copy-window "Copy Window")
      (?j aw-switch-buffer-in-window "Select Buffer")
      (?n aw-flip-window)
      (?u aw-switch-buffer-other-window "Switch Buffer Other Window")
      (?c aw-split-window-fair "Split Fair Window")
      (?v aw-split-window-vert "Split Vert Window")
      (?b aw-split-window-horz "Split Horz Window")
      (?o delete-other-windows "Delete Other Windows")
      (?? aw-show-dispatch-help))
"List of actions for `aw-dispatch-default'.")
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">12.5</span> Sane native window management {#sane-native-window-management}

Focuses new windows when created.

```emacs-lisp
;; Window management
;; focus new windows once created
(use-package window
  :straight (:type 'built-in)
  :bind (("C-x 3" . hsplit-last-buffer)
         ("C-x 2" . vsplit-last-buffer))
  :preface
  (defun hsplit-last-buffer ()
    "Gives the focus to the last created horizontal window."
    (interactive)
    (split-window-horizontally)
    (other-window 1))

  (defun vsplit-last-buffer ()
    "Gives the focus to the last created vertical window."
    (interactive)
    (split-window-vertically)
    (other-window 1)))
```


### <span class="section-num">12.6</span> Better popups with popper {#better-popups-with-popper}

```emacs-lisp
(use-package popper
    :bind (("C-`"   . popper-toggle-latest)
           ("M-`"   . popper-cycle)
           ("C-M-`" . popper-toggle-type))

    :init
    ;; assign windows to popper (to appear as popups)
    (setq popper-reference-buffers
          '("\\*Messages\\*"
            "Output\\*$"
            "\\*Backtrace\\*"
            "\\*Warnings\\*"
            "^Calc:"
            "^\\*ielm\\*"
            ;; terminals as popups
            "^\\*eshell.*\\*$" eshell-mode
            "^\\*shell.*\\*$" shell-mode
            "^\\*term.*\\*$" term-mode
            "^\\*vterm.*\\*$" vterm-mode
            help-mode
            compilation-mode
            ;; magit stuff
            "^magit:*" magit-mode
            "^\\*Ilist\\*$"
            ;; R console that comes with ESS
            "^\\*iESS" iESS-mode
            "^\\*R\\*"
            ;; R-help windows
            "^\\*help\\[R\\]([a-z]*)\\*"
            ))

    ;;grouping popups by projectile groups
    (setq popper-group-function #'popper-group-by-projectile)

    ;; popper UI configguration
    (setq popper-modeline nil)

    (popper-mode +1)
    ;; echo area hints?
    (popper-echo-mode +1)
    )
```


## <span class="section-num">13</span> Garbage {#garbage}


#### <span class="section-num">13.0.1</span> from customize API {#from-customize-api}

This keeps the init.el cleaner and without junk from `customize.el`
API allows for an option to gitignore your `custom.el` cause it's
junk.

<a id="code-snippet--customize-disable"></a>
```emacs-lisp

  ;; Offload the custom-set-variables to a separate file
  ;; (setq custom-file "~/.emacs.d/custom.el")
  (setq custom-file (concat user-emacs-directory "/custom.el"))
  (unless (file-exists-p custom-file)
    (write-region "" nil custom-file))

;; Load custom file. Don't hide errors. Hide success message
;; OR DON'T EVEN BOTHER WITH IT
;; (load custom-file nil t)

```


#### <span class="section-num">13.0.2</span> from backups and autosaves(?) {#from-backups-and-autosaves}

<a id="code-snippet--organise-junk"></a>
```emacs-lisp
;;; Put Emacs auto-save and backup files to one folder
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))

(setq
 backup-by-copying t                                        ; Avoid symlinks
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 auto-save-list-file-prefix emacs-tmp-dir
 auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
 backup-directory-alist `((".*" . ,emacs-tmp-dir)))

;;; Lockfiles unfortunately cause more pain than benefit
(setq create-lockfiles nil)
```


## <span class="section-num">14</span> Defaults {#defaults}

Primarily bootlegged from [Sanemacs](https://sanemacs.com) and changed when appropriate (and
when I thought I understood what I was doing)


### <span class="section-num">14.1</span> Disable native popups(?) and bell {#disable-native-popups-----and-bell}

```emacs-lisp
;; not sure what this is about
;; (setq-default indent-tabs-mode nil)
;; disable popups?
;; (setq pop-up-windows nil)
;; Disable bell sound
(setq ring-bell-function 'ignore)
```


### <span class="section-num">14.2</span> Only **y or n prompts** for speed {#only-y-or-n-prompts-for-speed}

Apparently there is a `short-answers` variable

```emacs-lisp
;; (fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 use-short-answers t

 ;; Ok to visit non existent files (no confirmation reqd)
 confirm-nonexistent-file-or-buffer nil)
```


### <span class="section-num">14.3</span> Merge Emacs and system clipboards {#merge-emacs-and-system-clipboards}

```emacs-lisp
;; Merge system's and Emacs' clipboard
(setq-default select-enable-clipboard t)
```


### <span class="section-num">14.4</span> Overwrite selected text {#overwrite-selected-text}

<a id="code-snippet--overwrite-active-region"></a>
```emacs-lisp
(delete-selection-mode 1)
```


### <span class="section-num">14.5</span> Join line to following line {#join-line-to-following-line}

Plagiarised from [pragmatic emacs](https://pragmaticemacs.com/emacs/join-line-to-following-line/). For the reverse, emacs has a
slightly obscurely named command `delete-indentation` which is bound
to `M-^` which can be rather useful. From the help for the function
(which you can always look up using `C-h k M-^` or `C-h f
delete-indentation`)

<a id="code-snippet--concatenate-following-line"></a>
```emacs-lisp
;; join line to next line
(global-set-key (kbd "C-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))
```


### <span class="section-num">14.6</span> Simpler kill buffer behaviour {#simpler-kill-buffer-behaviour}

<a id="code-snippet--buffer-killer"></a>
```emacs-lisp
(defun peremacs/kill-this-buffer ()
  (interactive) (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'peremacs/kill-this-buffer)
```


### <span class="section-num">14.7</span> Kill without accessing clipboard - reassess if this is really necessary {#kill-without-accessing-clipboard-reassess-if-this-is-really-necessary}

```emacs-lisp
(defun peremacs/backward-kill-word ()
  (interactive "*")
  (push-mark)
  (backward-word)
  (delete-region (point) (mark)))

(global-set-key (kbd "M-DEL") 'peremacs/backward-kill-word)
(global-set-key (kbd "C-DEL") 'peremacs/backward-kill-word)
```


### <span class="section-num">14.8</span> Return to last position in buffer {#return-to-last-position-in-buffer}

Opens files at last position used. Something about this on [Emacs Wiki](https://www.emacswiki.org/emacs/SavePlace)

<a id="code-snippet--save-place"></a>
```emacs-lisp
(save-place-mode 1)
```


### <span class="section-num">14.9</span> Prompt before closing Emacs {#prompt-before-closing-emacs}

```emacs-lisp
;; Confirm when killing Emacs
(setq confirm-kill-emacs (lambda (prompt)
                           (y-or-n-p-with-timeout prompt 2 nil)))
```


### <span class="section-num">14.10</span> Prevent angle braces from throwing errors {#prevent-angle-braces-from-throwing-errors}

```emacs-lisp
(modify-syntax-entry ?< ".")
(modify-syntax-entry ?> ".")
```


### <span class="org-todo done DISABLED">DISABLED</span> <span class="section-num">14.11</span> Don't follow symlinks {#don-t-follow-symlinks}

```emacs-lisp
;; don't follow symlinks? hopefully this solves the
;; `symbols function definition is void: org-file-name-concat' error
(setq vc-follow-symlinks nil)
```


## <span class="section-num">15</span> Code utilities {#code-utilities}


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">15.1</span> Templates and snippets with minad's tempel {#templates-and-snippets-with-minad-s-tempel}

Seems a lot simpler than yasnippet but will have to work on templates.

```emacs-lisp
(use-package tempel
  ;; Require trigger prefix before template name when completing.
  ;; :custom
  ;; (tempel-trigger-prefix "<")

  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
         ("M-*" . tempel-insert))
```

Configuration: I'm setting the `tempel-path` because it defaults to
`~/.config/emacs/templates` which I don't use. But I think I'll
eventually switch to something like that.

```emacs-lisp
  :init
(setq tempel-path "~/.emacs.d/templates")
```

Setup completion at point

```emacs-lisp
(defun tempel-setup-capf ()
  ;; Add the Tempel Capf to `completion-at-point-functions'.
  ;; `tempel-expand' only triggers on exact matches. Alternatively use
  ;; `tempel-complete' if you want to see all matches, but then you
  ;; should also configure `tempel-trigger-prefix', such that Tempel
  ;; does not trigger too often when you don't expect it. NOTE: We add
  ;; `tempel-expand' *before* the main programming mode Capf, such
  ;; that it will be tried first.
  (setq-local completion-at-point-functions
              (cons #'tempel-expand
                    completion-at-point-functions)))
```

Hooks

```emacs-lisp
:hook
(prog-mode . tempel-setup-capf)
(text-mode . tempel-setup-capf)

    ;; Optionally make the Tempel templates available to Abbrev,
    ;; either locally or globally. `expand-abbrev' is bound to C-x '.
    ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
    ;; (global-tempel-abbrev-mode)
    )
```


### <span class="section-num">15.2</span> Snippets {#snippets}

```emacs-lisp
(use-package yasnippet
  :disabled
  :config
  (yas-global-mode 1)
  :diminish yas-minor-mode)
```


### <span class="section-num">15.3</span> Syntax checking with Flycheck {#syntax-checking-with-flycheck}

```emacs-lisp
(use-package flycheck
  :defer t
  :hook
  (prog-mode . flycheck-mode)
  (org-mode . flycheck-mode)
  (sh-mode . flycheck-mode)
  :diminish flycheck-mode
  )
```


### <span class="section-num">15.4</span> Bash - use tabs instead of spaces {#bash-use-tabs-instead-of-spaces}

Maybe this needs to be universal but this is especially annoying when
I edit void-packages 'template's which specifically need tabs in the
custom functions below.

```emacs-lisp
(add-hook 'sh-mode-hook
    (lambda ()
        (setq-default indent-tabs-mode t)
        (setq-default tab-width 8)
    (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
```


### <span class="section-num">15.5</span> Auto-paired parens {#auto-paired-parens}

```emacs-lisp
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)
```


### <span class="section-num">15.6</span> Show matching parens {#show-matching-parens}

```emacs-lisp
(show-paren-mode 1)
;; Worst possible setting with this theme - it sucks balls
;; (setq show-paren-style 'expression)
```


### <span class="section-num">15.7</span> CUA mode {#cua-mode}

```emacs-lisp
(setq cua-enable-cua-keys nil)
;; for rectangles, CUA is nice
(cua-mode t)
```


### <span class="section-num">15.8</span> Aggressive **indentation** coz OCD {#aggressive-indentation-coz-ocd}

...and I hate doing it manually and Emacs usually refuses to do it by
itself

```emacs-lisp
(use-package aggressive-indent
  :config (global-aggressive-indent-mode 1)
  :diminish aggressive-indent-mode)
```


### <span class="section-num">15.9</span> Bug-hunter {#bug-hunter}

...except those that you can eat

```emacs-lisp
(use-package bug-hunter)
```


### <span class="section-num">15.10</span> cl-libify {#cl-libify}

Convert all (deperecated) `cl` symbols to `cl-lib`

```emacs-lisp
(use-package cl-libify
  :disabled)
```


### <span class="section-num">15.11</span> Iedit {#iedit}

A more intuitive way to alter all the occurrences of a word/keyword at once

```emacs-lisp
(use-package iedit)
```


### <span class="section-num">15.12</span> Show line numbers in programming modes {#show-line-numbers-in-programming-modes}

<a id="code-snippet--linum-for-progmode"></a>
```emacs-lisp
(add-hook 'prog-mode-hook
                (if (and (fboundp 'display-line-numbers-mode) (display-graphic-p))
                    #'display-line-numbers-mode
                  #'linum-mode))
```


### <span class="section-num">15.13</span> Files from script directories default to shell-mode {#files-from-script-directories-default-to-shell-mode}

Scope for adding more such shit?

```emacs-lisp
(add-to-list 'auto-mode-alist '("/bin/" . sh-mode))
(add-to-list 'auto-mode-alist '("/srcpkgs/[[:ascii:]]+/template" . sh-mode))
```


### <span class="section-num">15.14</span> Editing root files &amp; privelege escalation for TRAMP if I ever use it {#editing-root-files-and-privelege-escalation-for-tramp-if-i-ever-use-it}

```emacs-lisp
(use-package su
  ;; :config
  ;; (su-mode +1)
  )
```


### <span class="section-num">15.15</span> Whitespace mopup {#whitespace-mopup}

<a id="code-snippet--del-whitespace"></a>
```emacs-lisp
(add-hook 'before-save-hook
          'delete-trailing-whitespace) ;; Delete trailing whitespace on save
```


### <span class="section-num">15.16</span> Multiple cursors {#multiple-cursors}

This is like `C-v`, a visual mode in vim/neovim. I stole this from
[pragmatic emacs](https://pragmaticemacs.com/emacs/multiple-cursors/).

<a id="code-snippet--multiple-cursors"></a>
```emacs-lisp
(global-set-key (kbd "C-c m c") 'peremacs/edit-lines)
```


### <span class="section-num">15.17</span> Delete blank lines and whitespace interactively {#delete-blank-lines-and-whitespace-interactively}

Plagiarised from [pragmatic emacs](https://pragmaticemacs.com/emacs/delete-blank-lines-and-shrink-whitespace/)

<a id="code-snippet--shrink-whitespace"></a>
```emacs-lisp
(global-set-key (kbd "M-SPC") 'shrink-whitespace)
```


### <span class="section-num">15.18</span> Autoupdate buffer if files has changed on disk {#autoupdate-buffer-if-files-has-changed-on-disk}

<a id="code-snippet--reload-buffer-on-modification"></a>
```emacs-lisp
(global-auto-revert-mode t)
```


## <span class="section-num">16</span> Languages {#languages}


### <span class="section-num">16.1</span> Vimscript for editing neovim init {#vimscript-for-editing-neovim-init}

...cause neovim sucks and I don't like leaving Emacs in the ideal
case. I might end up replacing this with a **lua config**

```emacs-lisp
;; vimrc syntax
(use-package vimrc-mode)
;; :ensure t
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))
```


### <span class="section-num">16.2</span> Lua mode? {#lua-mode}

I intend to learn and use lua for my neovim config.

```emacs-lisp
(use-package lua-mode)
```


### <span class="section-num">16.3</span> C and C++ ??? {#c-and-c-plus-plus}

Like really?

```emacs-lisp
;; (use-package cc-mode)
```


### <span class="section-num">16.4</span> El Doc for help in echo area {#el-doc-for-help-in-echo-area}

```emacs-lisp
(use-package eldoc
  :straight (:type built-in)

  :hook
  ((emacs-lisp-mode-hook . eldoc-mode)
   (lisp-interaction-mode-hook . eldoc-mode)
   (ielm-mode-hook . eldoc-mode)
   (org-mode . eldoc-mode)))
```


### <span class="section-num">16.5</span> Zig mode {#zig-mode}

```emacs-lisp
(use-package zig-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode)))
```


### <span class="section-num">16.6</span> Yaml {#yaml}

```emacs-lisp

(use-package yaml-mode
  :config
  ;;autoloads
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

  ;; indent and new-line on return; the mode enforces spaces instead
  ;; of tabs
  (add-hook 'yaml-mode-hook
        (lambda ()
          (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

```


## <span class="section-num">17</span> Terminal {#terminal}

Vterm ftw

```emacs-lisp
(use-package vterm
  ;; :ensure t
  :load-path "/usr/lib/libvterm.so.0.0.3"

  :init
  ;;  (setq vterm-term-environment-variable "eterm-256color")
  (setq vterm-disable-bold-font t)
  (setq vterm-kill-buffer-on-exit t)
  (setq vterm-module-cmake-args "-DUSE_SYSTEM_LIBVTERM=no")
  (setq vterm-always-compile-module t)
  (setq vterm-copy-exclude-prompt t))
```

Make vterm behave like a guake terminal and open below the main
window. This can be toggled and opens only one instance per window
(afaik). Considering using [this feature](https://github.com/jixiuf/vterm-toggle#vterm-toggle-use-dedicated-buffer) to not provide a dedicated
buffer to vterm so it sticks to the window it was launched with.

```emacs-lisp
(use-package vterm-toggle

  :bind
  (("C-M-'" . vterm-toggle-cd))

  :config

  ;; reset window layout after kill
  (setq vterm-toggle-reset-window-configration-after-exit t)

  ;; toggle behaviour - like a toggle keep it running
  (setq vterm-toggle-hide-method nil)

```

Show vterm in a window at the bottom

```emacs-lisp
(setq vterm-toggle-fullscreen-p nil)
(add-to-list 'display-buffer-alist
         '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
            (display-buffer-reuse-window display-buffer-at-bottom)
            ;;(display-buffer-reuse-window display-buffer-in-direction)
            ;;display-buffer-in-direction/direction/dedicated is added in emacs27
            ;;(direction . bottom)
            ;;(dedicated . t) ;dedicated is supported in emacs27
            (reusable-frames . visible)
            (window-height . 0.3)))
```

Make counsel use the correct function to yank in vterm buffers.

```emacs-lisp
(defun vterm-counsel-yank-pop-action (orig-fun &rest args)
  (if (equal major-mode 'vterm-mode)
      (let ((inhibit-read-only t)
            (yank-undo-function (lambda (_start _end) (vterm-undo))))
        (cl-letf (((symbol-function 'insert-for-yank)
               (lambda (str) (vterm-send-string str t))))
            (apply orig-fun args)))
    (apply orig-fun args)))

(advice-add 'counsel-yank-pop-action :around #'vterm-counsel-yank-pop-action))
```


## <span class="section-num">18</span> Multimedia {#multimedia}


### <span class="section-num">18.1</span> EMMS for music {#emms-for-music}

```emacs-lisp
(use-package emms
  :commands emms
  :config
  (require 'emms-setup)
  (emms-standard)
  (emms-default-players)
  (emms-mode-line-disable)
  (setq emms-source-file-default-directory "~/Music/")
  ;;(dw/leader-key-def
    ;;"am"  '(:ignore t :which-key "media")
    ;;"amp" '(emms-pause :which-key "play / pause")
    ;;"amf" '(emms-play-file :which-key "play file"))
  )
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">18.2</span> View ePubs and PDFs in Emacs {#view-epubs-and-pdfs-in-emacs}

```emacs-lisp
(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :config (nov-text-width 75))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config (pdf-tools-install :no-query))

;; TODO this needs fixing idk why even
;; (use-package pdf-view
;;   :ensure nil
;;   :after pdf-tools
;;   :bind (:map pdf-view-mode-map
;;               ("C-s" . isearch-forward)
;;               ("d" . pdf-annot-delete)
;;               ("h" . pdf-annot-add-highlight-markup-annotation)
;;               ("t" . pdf-annot-add-text-annotation))
;;   :custom
;;   (pdf-view-display-size 'fit-page)
;;   (pdf-view-resize-factor 1.1)
;;   (pdf-view-use-unicode-ligther nil))
```


## <span class="section-num">19</span> Web {#web}

Got most of these from [daviwil](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org)'s literate configuration


### <span class="section-num">19.1</span> Gemini {#gemini}

```emacs-lisp
(use-package elpher)
```


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">19.2</span> mail with mu4e {#mail-with-mu4e}

see [daviwil's mail.org](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Mail.org) and the configuration in his [literate config](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org#mail).


### <span class="org-todo todo TODO">TODO</span> <span class="section-num">19.3</span> Browser {#browser}


### <span class="section-num">19.4</span> Elfeed for RSS {#elfeed-for-rss}

```emacs-lisp
(use-package elfeed
  :commands elfeed
  :config
  (setq elfeed-feeds
        '("https://drewdevault.com/blog/index.xml"
          "https://sourcehut.org/blog/index.xml"
          "https://ambikamath.com/feed/"
          "https://emersion.fr/blog/atom.xml")))
```


## <span class="section-num">20</span> Footer {#footer}

```emacs-lisp
;;; configuration.el ends here
```
