+++
title = "Literate Emacs Configuration"
author = ["Brihadeesh S (They/Them)"]
lastmod = 2022-11-20T23:21:41+05:30
categories = ["emacs", "config"]
url = "/emacs/emacs-literate-config"
draft = false
+++

<div class="ox-hugo-toc toc">

<div class="heading">Table of Contents</div>

- [<span class="org-todo todo TODO">TODO</span> Early init](#early-init)
- [Prerequisites](#prerequisites)
    - [Reload Emacs configuration](#reload-emacs-configuration)
    - [<span class="org-todo todo TODO">TODO</span> Use-package v2 related changes](#use-package-v2-related-changes)
    - [Convert all org-keywords/block identifiers to lowercase](#convert-all-org-keywords-block-identifiers-to-lowercase)
- [Ensure UTF-8](#ensure-utf-8)
- [Whoami](#whoami)
- [Performance enhancements](#performance-enhancements)
- [No more garbage](#no-more-garbage)
    - [from customize API](#from-customize-api)
    - [from backups and autosaves(?)](#from-backups-and-autosaves)
- [Package management](#package-management)
    - [Setup `straight.el`](#setup-straight-dot-el)
    - [Install and configure `use-package`](#install-and-configure-use-package)
        - [Prevent older org-mode versions from being loaded](#prevent-older-org-mode-versions-from-being-loaded)
    - [Minimal `package.el` setup only to browse packages](#minimal-package-dot-el-setup-only-to-browse-packages)
    - [Diminish for a cleaner modeline](#diminish-for-a-cleaner-modeline)
- [Sane Defaults](#sane-defaults)
    - [Make **scratch** buffer and **minibuffer** blank](#make-scratch-buffer-and-minibuffer-blank)
    - [Make "Emacs" the **window title**](#make-emacs-the-window-title)
    - [Org-mode as the _initial major mode_](#org-mode-as-the-initial-major-mode)
    - [<span class="org-todo todo TODO">TODO</span> Disable native popups(?) and bell](#disable-native-popups-----and-bell)
    - [Only **y or n prompts** for speed](#only-y-or-n-prompts-for-speed)
    - [Merge Emacs and system clipboards](#merge-emacs-and-system-clipboards)
    - [Overwrite selected text](#overwrite-selected-text)
    - [Join line to following line](#join-line-to-following-line)
    - [Delete blank lines and whitespace interactively](#delete-blank-lines-and-whitespace-interactively)
    - [Multiple cursors](#multiple-cursors)
    - [Autoupdate buffer if files has changed on disk](#autoupdate-buffer-if-files-has-changed-on-disk)
    - [Whitespace mopup](#whitespace-mopup)
    - [Simpler kill buffer behaviour](#simpler-kill-buffer-behaviour)
    - [<span class="org-todo todo TODO">TODO</span> Kill without accessing clipboard - reassess if this is really necessary](#kill-without-accessing-clipboard-reassess-if-this-is-really-necessary)
    - [Return to last position in buffer](#return-to-last-position-in-buffer)
    - [<span class="org-todo todo TODO">TODO</span> Assorted keybindings - is this really necessary](#assorted-keybindings-is-this-really-necessary)
    - [Pixel scroll precision mode (Emacs 29+)](#pixel-scroll-precision-mode--emacs-29-plus)
    - [Prompt before closing Emacs](#prompt-before-closing-emacs)
    - [Show keystrokes](#show-keystrokes)
- [<span class="org-todo todo TODO">TODO</span> SSH for personal packages and magit](#ssh-for-personal-packages-and-magit)
- [Terminals with emacs-libvterm](#terminals-with-emacs-libvterm)
    - [<span class="org-todo done IGNORE">IGNORE</span> Eshell configuration](#eshell-configuration)
- [Code utilities](#code-utilities)
    - [<span class="org-todo todo TODO">TODO</span> Templates and snippets with minad's tempel](#templates-and-snippets-with-minad-s-tempel)
    - [Snippets](#snippets)
    - [<span class="org-todo todo TODO">TODO</span> Syntax checking with Flycheck](#syntax-checking-with-flycheck)
    - [Bash - use tabs instead of spaces](#bash-use-tabs-instead-of-spaces)
    - [Autopaired parens](#autopaired-parens)
    - [Don't add C-x,C-c,C-v; dont ask why though](#don-t-add-c-x-c-c-c-v-dont-ask-why-though)
    - [Aggressive **indentation** coz OCD](#aggressive-indentation-coz-ocd)
    - [I hate arthropods](#i-hate-arthropods)
    - [cl-libify](#cl-libify)
    - [Iedit](#iedit)
    - [Show line numbers in programming modes](#show-line-numbers-in-programming-modes)
    - [Open shell files from script directories in `sh-mode`](#open-shell-files-from-script-directories-in-sh-mode)
    - [Show matching parens](#show-matching-parens)
- [Languages I (allegedly) use](#languages-i--allegedly--use)
    - [Vimscript for editing neovim init](#vimscript-for-editing-neovim-init)
    - [Lua mode?](#lua-mode)
    - [Emacs Speaks Statistics for **R** and python(?)](#emacs-speaks-statistics-for-r-and-python)
    - [Polymode for RMarkdown syntax](#polymode-for-rmarkdown-syntax)
    - [C and C++ ???](#c-and-c-plus-plus)
    - [AUCTex for LaTex editing + completion](#auctex-for-latex-editing-plus-completion)
    - [Spellcheck](#spellcheck)
        - [Trying something else...](#trying-something-else-dot-dot-dot)
    - [Something like scrivener from Mac](#something-like-scrivener-from-mac)
    - [Brainfuck?](#brainfuck)
    - [El Doc for help in echo area](#el-doc-for-help-in-echo-area)
    - [Zig mode](#zig-mode)
- [Git with Magit and gists with `gist.el`](#git-with-magit-and-gists-with-gist-dot-el)
- [View ePubs and PDFs in Emacs](#view-epubs-and-pdfs-in-emacs)
- [Ledger for finance](#ledger-for-finance)
    - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Prettier journaling for expenses](#prettier-journaling-for-expenses)
- [<span class="org-todo done IGNORE">IGNORE</span> Company for completions](#company-for-completions)
- [<span class="org-todo todo TODO">TODO</span> Corfu for completion-at-point (non-minibuffer kind)](#corfu-for-completion-at-point--non-minibuffer-kind)
    - [CAPE - extensions for corfu](#cape-extensions-for-corfu)
- [Undo tree](#undo-tree)
- [Project management and navigation - projectile](#project-management-and-navigation-projectile)
- [<span class="org-todo done IGNORE">IGNORE</span> Consistent and simpler keybinding assignment](#consistent-and-simpler-keybinding-assignment)
- [ERC for IRC](#erc-for-irc)
- [Window Management](#window-management)
    - [EXWM](#exwm)
    - [<span class="org-todo todo TODO">TODO</span> Workspaces with perspective-el](#workspaces-with-perspective-el)
        - [persp-projectile for proper workspace window management](#persp-projectile-for-proper-workspace-window-management)
    - [Undo disrupted window/frame arrangement after using some shit](#undo-disrupted-window-frame-arrangement-after-using-some-shit)
    - [Ace-window helps with navigation between multiple windows](#ace-window-helps-with-navigation-between-multiple-windows)
    - [<span class="org-todo todo TODO">TODO</span> Sane native window management - needs work](#sane-native-window-management-needs-work)
    - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Better popups with popper](#better-popups-with-popper)
- [Display keybinds following various prefixes such as `C-h`](#display-keybinds-following-various-prefixes-such-as-c-h)
- [Editing root files &amp; privelege escalation for TRAMP if I ever use it](#editing-root-files-and-privelege-escalation-for-tramp-if-i-ever-use-it)
- [Minibuffer completions](#minibuffer-completions)
    - [<span class="org-todo todo TODO">TODO</span> Completion - is mct worth using?](#completion-is-mct-worth-using)
    - [<span class="org-todo done IGNORE">IGNORE</span> Prescient command history with `M-x`](#prescient-command-history-with-m-x)
    - [Access a list of recently edited files](#access-a-list-of-recently-edited-files)
    - [<span class="org-todo done IGNORE">IGNORE</span> Selectrum for completions UI](#selectrum-for-completions-ui)
    - [Vertico for completions UI](#vertico-for-completions-ui)
        - [<span class="org-todo todo TODO">TODO</span> Vertico extensions](#vertico-extensions)
    - [Orderless completion](#orderless-completion)
    - [Persistent command history](#persistent-command-history)
    - [A few more useful configurations](#a-few-more-useful-configurations)
    - [Richer annotations in minubuffer](#richer-annotations-in-minubuffer)
    - [Consult adds more minibuffer functionality](#consult-adds-more-minibuffer-functionality)
    - [<span class="org-todo todo TODO">TODO</span> Embark - actions; reorganise](#embark-actions-reorganise)
    - [<span class="org-todo todo TODO">TODO</span> Imenu-list?](#imenu-list)
- [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> org-mode setup](#org-mode-setup)
        - [Better commenting in org-mode code-blocks](#better-commenting-in-org-mode-code-blocks)
        - [<span class="org-todo done IGNORE">IGNORE</span> Better spacing between org-levels with org-padding](#better-spacing-between-org-levels-with-org-padding)
        - [Sources for agenda tasks](#sources-for-agenda-tasks)
        - [Display features](#display-features)
        - [Autoindent/autofill turned on automatically](#autoindent-autofill-turned-on-automatically)
        - [Tags and todo-keywords config](#tags-and-todo-keywords-config)
        - [<span class="org-todo todo TODO">TODO</span> Capture templates](#capture-templates)
        - [Bullets for non ordered list](#bullets-for-non-ordered-list)
        - [`Table of contents` for org-mode files](#table-of-contents-for-org-mode-files)
        - [<span class="org-todo done IGNORE">IGNORE</span> Rougier's svg-tag-mode](#rougier-s-svg-tag-mode)
        - [Hide all stars](#hide-all-stars)
        - [Minad's modern UI for org-mode (fork)](#minad-s-modern-ui-for-org-mode--fork)
        - [Org-superstar](#org-superstar)
        - [Display emphasis markers on hover](#display-emphasis-markers-on-hover)
    - [<span class="org-todo todo TODO">TODO</span> Org-Babel for literate programming](#org-babel-for-literate-programming)
    - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Denote for note-taking](#denote-for-note-taking)
    - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> org-roam](#org-roam)
    - [<span class="org-todo todo TODO">TODO</span> Journaling requirements](#journaling-requirements)
    - [<span class="org-todo todo TODO">TODO</span> Citar for reference management?](#citar-for-reference-management)
    - [org-present for presentations](#org-present-for-presentations)
- [Multimedia](#multimedia)
    - [EMMS for music](#emms-for-music)
    - [mpv for video](#mpv-for-video)
- [Web surfing and more](#web-surfing-and-more)
    - [Gemini](#gemini)
    - [<span class="org-todo todo TODO">TODO</span> mail with mu4e](#mail-with-mu4e)
    - [<span class="org-todo todo TODO">TODO</span> Browser](#browser)
    - [Elfeed for RSS](#elfeed-for-rss)
- [UI configuration](#ui-configuration)
    - [Highlighted line-mode](#highlighted-line-mode)
    - [Solid window dividers](#solid-window-dividers)
    - [Something about underlines](#something-about-underlines)
    - [<span class="org-todo done IGNORE">IGNORE</span> figure this out too - No ugly button for checkboxes](#figure-this-out-too-no-ugly-button-for-checkboxes)
    - [Cursor configuration](#cursor-configuration)
    - [Line-number format](#line-number-format)
    - [Visual not audible bell](#visual-not-audible-bell)
    - [No Tooltips](#no-tooltips)
    - [Minibuffer appearance?](#minibuffer-appearance)
    - [Fringe](#fringe)
    - [Minimalist and ordered mode-line](#minimalist-and-ordered-mode-line)
    - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Lambda modeline](#lambda-modeline)
        - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Mood-line because I'm fucking tired](#mood-line-because-i-m-fucking-tired)
    - [Font configuration](#font-configuration)
        - [Setting a font](#setting-a-font)
        - [Line spacing](#line-spacing)
    - [Editor theme](#editor-theme)
        - [<span class="org-todo done IGNORE">IGNORE</span> Initial config for moody I guess](#initial-config-for-moody-i-guess)
        - [Externally sourced](#externally-sourced)
        - [<span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> My themes (LOL)](#my-themes--lol)
        - [Pulse to locate cursor with Protesilaos's pulsar](#pulse-to-locate-cursor-with-protesilaos-s-pulsar)

</div>
<!--endtoc-->

This is a copy of my literate configuration for Emacs with text
rendered for viewing on browsers easily. You can also find a
source-based version with the rest of my `~/.emacs.d` on my [sourcehut](https:git.sr.ht/~peregrinator/.emacs.d).


## <span class="org-todo todo TODO">TODO</span> Early init {#early-init}

This creates a file, [ `early-init.el` ](~/.emacs.d/early-init.el), in `~/.emacs.d`. This was stolen
from Protesilaos some time back. It still needs work - it's not
tangled (by default) yet.

```emacs-lisp
;;; early-init.el --- Early Init File -*- lexical-binding: t -*-

;; Copyright (c) 2021-2022  peregrinator

;; Author: peregrinator <brihadeesh@protonmail.com>
;; URL: https://git.sr.ht/~peregrinator/dotfiles
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Prior to Emacs 27, the `init.el' was supposed to handle the
;; initialisation of the package manager, by means of calling
;; `package-initialize'.  Starting with Emacs 27, the default
;; behaviour is to start the package manager before loading the init
;; file.

;;; Code:

;; Don't initialise installed packages cause package.el sucks balls
(setq package-enable-at-startup nil)

;; Do not resize the frame at this early stage.
(setq frame-inhibit-implied-resize t)

;; Disable GUI elements
;;; Disable menu-bar, tool-bar, and scroll-bar.
(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
(setq inhibit-splash-screen t)
;; (setq use-dialog-box nil)                 ; only for mouse events
(setq use-file-dialog nil)

(setq inhibit-startup-screen t)
(setq inhibit-startup-buffer-menu t)

;; for when I upgrade to emacs28 with native compilation
(setq native-comp-async-report-warnings-errors nil)

;;; early-init.el ends here
```


## Prerequisites {#prerequisites}

Lexical binding is required for a lot of stuff here

```emacs-lisp
;; -*- lexical-binding: t -*-

;; don't follow symlinks? hopefully this solves the
;; `symbols function definition is void: org-file-name-concat' error
(setq vc-follow-symlinks nil)
```


### Reload Emacs configuration {#reload-emacs-configuration}

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


### <span class="org-todo todo TODO">TODO</span> Use-package v2 related changes {#use-package-v2-related-changes}

Need to figure this out - I think maybe `use-package` might not be updated

```emacs-lisp
(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
```


### Convert all org-keywords/block identifiers to lowercase {#convert-all-org-keywords-block-identifiers-to-lowercase}

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


## Ensure UTF-8 {#ensure-utf-8}

```emacs-lisp
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
```


## Whoami {#whoami}

Doh

```emacs-lisp
(setq user-full-name "peregrinator (They/Them)"
      user-mail-address "brihadeesh@protonmail.com")
```


## Performance enhancements {#performance-enhancements}

Maybe I'll understand what this is about one day

<a id="code-snippet--performance-enhancement"></a>
```emacs-lisp
;;; For performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(add-hook 'after-init-hook #'(lambda ()
			       ;; restore after startup
			       (setq gc-cons-threshold 100000000)))
```


## No more garbage {#no-more-garbage}


### from customize API {#from-customize-api}

This keeps the init.el cleaner and without junk from `customize.el`
API allows for an option to gitignore your `custom.el` cause it's
junk.

<a id="code-snippet--customize-disable"></a>
```emacs-lisp
;;; Offload the custom-set-variables to a separate file

    (setq custom-file "~/.emacs.d/custom.el")
    (unless (file-exists-p custom-file)
      (write-region "" nil custom-file))
    ;;; Load custom file. Don't hide errors. Hide success message
    (load custom-file nil t)
```


### from backups and autosaves(?) {#from-backups-and-autosaves}

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


## Package management {#package-management}


### Setup `straight.el` {#setup-straight-dot-el}

I'll be using `use-package` to organise and configure individual
packages into neater code blocks although the download will be handled
by `straight.el`

<a id="code-snippet--straight-setup"></a>
```emacs-lisp
;; make all use-package instances use straight.el
(setq straight-use-package-by-default t)

;; fetch developmental version of straight.el
(setq straight-repository-branch "develop")

;; redirect all package repos and builddirs elsewhere
(setq straight-base-dir "~/.cache/straight")
```

```emacs-lisp
;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" "~/.cache"))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
```


### Install and configure `use-package` {#install-and-configure-use-package}

`use-package` is installed and managed by `straight.el` and in turn
packages used in this config are managed/organized by
`use-package`. There's something to do with integration with `use-package`
on the [straight.el readme](https://github.com/raxod502/straight.el/blob/develop/README.md#integration-with-use-package)

<a id="code-snippet--use-use-package"></a>
```emacs-lisp
(straight-use-package 'use-package)
(setq straight-host-usernames
      '((github . "brihadeesh")
	(gitlab . "peregrinator")
	(bitbucket . "peregrinator")))
(setq straight-check-for-modifications nil)
```


#### Prevent older org-mode versions from being loaded {#prevent-older-org-mode-versions-from-being-loaded}

Check [this reddit post](https://www.reddit.com/r/emacs/comments/qcj33a/problem_and_workaround_with_orgmode_function/hhmmskg/) which I found thankfully.

```emacs-lisp
(straight-use-package 'org)
```


### Minimal `package.el` setup only to browse packages {#minimal-package-dot-el-setup-only-to-browse-packages}

Running `package-list-packages` includes them only for browsing

```emacs-lisp
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
```


### Diminish for a cleaner modeline {#diminish-for-a-cleaner-modeline}

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


## Sane Defaults {#sane-defaults}

Primarily bootlegged from [Sanemacs](https://sanemacs.com) and changed when appropriate (and
when I thought I understood what I was doing)


### Make **scratch** buffer and **minibuffer** blank {#make-scratch-buffer-and-minibuffer-blank}

<a id="code-snippet--blank-startup"></a>
```emacs-lisp
(setq initial-scratch-message "")
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
```


### Make "Emacs" the **window title** {#make-emacs-the-window-title}

<a id="code-snippet--set-window-title"></a>
```emacs-lisp
(setq-default frame-title-format '("Emacs"))
```


### Org-mode as the _initial major mode_ {#org-mode-as-the-initial-major-mode}

<a id="code-snippet--start-with-org"></a>
```emacs-lisp
(setq initial-major-mode 'org-mode)
```


### <span class="org-todo todo TODO">TODO</span> Disable native popups(?) and bell {#disable-native-popups-----and-bell}

```emacs-lisp
;; not sure what this is about
;; (setq-default indent-tabs-mode nil)
;; disable popups?
;; (setq pop-up-windows nil)
;; Disable bell sound
(setq ring-bell-function 'ignore)
```


### Only **y or n prompts** for speed {#only-y-or-n-prompts-for-speed}

Apparently there is a `short-answers` variable

```emacs-lisp
;; (fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 use-short-answers t

 ;; Ok to visit non existent files (no confirmation reqd)
 confirm-nonexistent-file-or-buffer nil)
```


### Merge Emacs and system clipboards {#merge-emacs-and-system-clipboards}

```emacs-lisp
;; Merge system's and Emacs' clipboard
(setq-default select-enable-clipboard t)
```


### Overwrite selected text {#overwrite-selected-text}

<a id="code-snippet--overwrite-active-region"></a>
```emacs-lisp
(delete-selection-mode 1)
```


### Join line to following line {#join-line-to-following-line}

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


### Delete blank lines and whitespace interactively {#delete-blank-lines-and-whitespace-interactively}

Plagiarised from [pragmatic emacs](https://pragmaticemacs.com/emacs/delete-blank-lines-and-shrink-whitespace/)

<a id="code-snippet--shrink-whitespace"></a>
```emacs-lisp
(global-set-key (kbd "M-SPC") 'shrink-whitespace)
```


### Multiple cursors {#multiple-cursors}

This is like `C-v`, a visual mode in vim/neovim. I stole this from
[pragmatic emacs](https://pragmaticemacs.com/emacs/multiple-cursors/).

<a id="code-snippet--multiple-cursors"></a>
```emacs-lisp
(global-set-key (kbd "C-c m c") 'peremacs/edit-lines)
```


### Autoupdate buffer if files has changed on disk {#autoupdate-buffer-if-files-has-changed-on-disk}

<a id="code-snippet--reload-buffer-on-modification"></a>
```emacs-lisp
(global-auto-revert-mode t)
```


### Whitespace mopup {#whitespace-mopup}

<a id="code-snippet--del-whitespace"></a>
```emacs-lisp
(add-hook 'before-save-hook
	  'delete-trailing-whitespace) ;; Delete trailing whitespace on save
```


### Simpler kill buffer behaviour {#simpler-kill-buffer-behaviour}

<a id="code-snippet--buffer-killer"></a>
```emacs-lisp
(defun peremacs/kill-this-buffer ()
  (interactive) (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'peremacs/kill-this-buffer)
```


### <span class="org-todo todo TODO">TODO</span> Kill without accessing clipboard - reassess if this is really necessary {#kill-without-accessing-clipboard-reassess-if-this-is-really-necessary}

```emacs-lisp
(defun peremacs/backward-kill-word ()
  (interactive "*")
  (push-mark)
  (backward-word)
  (delete-region (point) (mark)))

(global-set-key (kbd "M-DEL") 'peremacs/backward-kill-word)
(global-set-key (kbd "C-DEL") 'peremacs/backward-kill-word)
```


### Return to last position in buffer {#return-to-last-position-in-buffer}

Opens files at last position used. Something about this on [Emacs Wiki](https://www.emacswiki.org/emacs/SavePlace)

<a id="code-snippet--save-place"></a>
```emacs-lisp
(save-place-mode 1)
```


### <span class="org-todo todo TODO">TODO</span> Assorted keybindings - is this really necessary {#assorted-keybindings-is-this-really-necessary}

<a id="code-snippet--manual-indent"></a>
```emacs-lisp
(global-set-key (kbd "C->") 'indent-rigidly-right-to-tab-stop) ; Indent selection by one tab length
(global-set-key (kbd "C-<") 'indent-rigidly-left-to-tab-stop)  ; De-indent selection by one tab length
```


### Pixel scroll precision mode (Emacs 29+) {#pixel-scroll-precision-mode--emacs-29-plus}

```emacs-lisp
(pixel-scroll-precision-mode +1)
```


### Prompt before closing Emacs {#prompt-before-closing-emacs}

```emacs-lisp
;; Confirm when killing Emacs
(setq confirm-kill-emacs (lambda (prompt)
			   (y-or-n-p-with-timeout prompt 2 nil)))
```


### Show keystrokes {#show-keystrokes}

Stolen from [Karthik Chikmaglur's emacs.d](https://github.com/karthink/emacs.d); shows what is typed immediately.

```emacs-lisp
(setq echo-keystrokes 0.01)
```


## <span class="org-todo todo TODO">TODO</span> SSH for personal packages and magit {#ssh-for-personal-packages-and-magit}

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


## Terminals with emacs-libvterm {#terminals-with-emacs-libvterm}

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


### <span class="org-todo done IGNORE">IGNORE</span> Eshell configuration {#eshell-configuration}

Make eshell pop under the main window and not create a window of it's
own.

```emacs-lisp
(use-package eshell-toggle
  :after eshell
  :bind ("C-M-'" . eshell-toggle)
  :custom
  (eshell-toggle-size-fraction 3)
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil))
```


## Code utilities {#code-utilities}


### <span class="org-todo todo TODO">TODO</span> Templates and snippets with minad's tempel {#templates-and-snippets-with-minad-s-tempel}

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


### Snippets {#snippets}

```emacs-lisp
(use-package yasnippet
  :disabled
  :config
  (yas-global-mode 1)
  :diminish yas-minor-mode)
```


### <span class="org-todo todo TODO">TODO</span> Syntax checking with Flycheck {#syntax-checking-with-flycheck}

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


### Bash - use tabs instead of spaces {#bash-use-tabs-instead-of-spaces}

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


### Autopaired parens {#autopaired-parens}

```emacs-lisp
(electric-pair-mode 1)
```


### Don't add C-x,C-c,C-v; dont ask why though {#don-t-add-c-x-c-c-c-v-dont-ask-why-though}

```emacs-lisp
(setq cua-enable-cua-keys nil)
;; for rectangles, CUA is nice
(cua-mode t)
```


### Aggressive **indentation** coz OCD {#aggressive-indentation-coz-ocd}

...and I hate doing it manually and Emacs usually refuses to do it by
itself

```emacs-lisp
(use-package aggressive-indent
  :config (global-aggressive-indent-mode 1)
  :diminish aggressive-indent-mode)
```


### I hate arthropods {#i-hate-arthropods}

...except those that you can eat

```emacs-lisp
(use-package bug-hunter)
```


### cl-libify {#cl-libify}

Convert all (deperecated) `cl` symbols to `cl-lib`

```emacs-lisp
(use-package cl-libify
  :disabled)
```


### Iedit {#iedit}

A more intuitive way to alter all the occurrences of a word/keyword at once

```emacs-lisp
(use-package iedit)
```


### Show line numbers in programming modes {#show-line-numbers-in-programming-modes}

<a id="code-snippet--linum-for-progmode"></a>
```emacs-lisp
(add-hook 'prog-mode-hook
		(if (and (fboundp 'display-line-numbers-mode) (display-graphic-p))
		    #'display-line-numbers-mode
		  #'linum-mode))
```


### Open shell files from script directories in `sh-mode` {#open-shell-files-from-script-directories-in-sh-mode}

Scope for adding more such shit?

```emacs-lisp
(add-to-list 'auto-mode-alist '("/bin/" . sh-mode))
(add-to-list 'auto-mode-alist '("/srcpkgs/[[:ascii:]]+/template" . sh-mode))
```


### Show matching parens {#show-matching-parens}

```emacs-lisp
(show-paren-mode 1)
;; Worst possible setting with this theme - it sucks balls
;; (setq show-paren-style 'expression)
```


## Languages I (allegedly) use {#languages-i--allegedly--use}


### Vimscript for editing neovim init {#vimscript-for-editing-neovim-init}

...cause neovim sucks and I don't like leaving Emacs in the ideal
case. I might end up replacing this with a **lua config**

```emacs-lisp
;; vimrc syntax
(use-package vimrc-mode)
;; :ensure t
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))
```


### Lua mode? {#lua-mode}

I intend to learn and use lua for my neovim config.

```emacs-lisp
(use-package lua-mode)
```


### Emacs Speaks Statistics for **R** and python(?) {#emacs-speaks-statistics-for-r-and-python}

Figure out babel/org-tangle or whatever because Emacs sucks for
RMarkdown and org-mode is generally better (see next bit for RMarkdown)

```emacs-lisp
(use-package ess)
;; :ensure t
(require `ess-r-mode)
```


### Polymode for RMarkdown syntax {#polymode-for-rmarkdown-syntax}

```emacs-lisp
(use-package poly-R)
;; :ensure t
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-ess-help+R-mode))
```


### C and C++ ??? {#c-and-c-plus-plus}

Like really?

```emacs-lisp
;; (use-package cc-mode)
```


### AUCTex for LaTex editing + completion {#auctex-for-latex-editing-plus-completion}

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


### Spellcheck {#spellcheck}

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


#### Trying something else... {#trying-something-else-dot-dot-dot}

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


### Something like scrivener from Mac {#something-like-scrivener-from-mac}

...cause I'm gonna become a novelist and/or write large books in the
near future

```emacs-lisp
(use-package binder)
;; (use-package binder-tutorial)
```


### Brainfuck? {#brainfuck}

Esoteric language which makes absolutely no sense for me considering
ADHD and all.

```emacs-lisp
(use-package brainfuck-mode)
```


### El Doc for help in echo area {#el-doc-for-help-in-echo-area}

```emacs-lisp
(use-package eldoc
  :straight (:type built-in)

  :hook
  ((emacs-lisp-mode-hook . eldoc-mode)
   (lisp-interaction-mode-hook . eldoc-mode)
   (ielm-mode-hook . eldoc-mode)
   (org-mode . eldoc-mode)))
```


### Zig mode {#zig-mode}

```emacs-lisp
(use-package zig-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode)))
```


## Git with Magit and gists with `gist.el` {#git-with-magit-and-gists-with-gist-dot-el}

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


## View ePubs and PDFs in Emacs {#view-epubs-and-pdfs-in-emacs}

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


## Ledger for finance {#ledger-for-finance}

I'm not entirely sure I can start with this yet but I think I've gotta
start working on paying of whatever debt I've accumulated.

<a id="code-snippet--pers-ledger"></a>
```emacs-lisp
(use-package ledger-mode
  :mode "\\.lgr\\'"

  :bind (:map ledger-mode-map
	      ("TAB" . completion-at-point))

  :config
  (ledger-reports '(("bal" "%(binary) -f %(ledger-file) bal")
		    ;; ("bal this quarter" "%(binary) -f %(ledger-file) --period \"this quarter\" bal")
		    ;; ("bal last quarter" "%(binary) -f %(ledger-file) --period \"last quarter\" bal")
		    ;; ("reg" "%(binary) -f %(ledger-file) reg")
		    ;; ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
		    ("account" "%(binary) -f %(ledger-file) reg %(account)"))))
```


### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Prettier journaling for expenses {#prettier-journaling-for-expenses}

This is more like an `org-mode`-like journal for personal expenses. I've
stolen this configuration from the author under the [usage header](https://github.com/narendraj9/hledger-mode#usage) of
the readme. It will need a lot more work to understand and I'm really
doing here so I've disabled it for now.

```emacs-lisp
(use-package hledger-mode
  ;; :straight t

  :mode ("\\.journal\\'" "\\.hledger\\'")

  ;; :commands hledger-enable-reporting

  :preface
  (defun hledger/next-entry ()
    "Move to next entry and pulse."
    (interactive)
    (hledger-next-or-new-entry)
    (hledger-pulse-momentary-current-entry))

  (defface hledger-warning-face
    '((((background dark))
       :background "Red" :foreground "White")
      (((background light))
       :background "Red" :foreground "White")
      (t :inverse-video t))
    "Face for warning"
    :group 'hledger)

  (defun hledger/prev-entry ()
    "Move to last entry and pulse."
    (interactive)
    (hledger-backward-entry)
    (hledger-pulse-momentary-current-entry))

  :bind (("C-c j" . hledger-run-command)
	 :map hledger-mode-map
	 ("TAB" . completion-at-point)
	 ("C-c e" . hledger-jentry)
	 ("M-p" . hledger/prev-entry)
	 ("M-n" . hledger/next-entry))

  :init
  (setq hledger-jfile
	(expand-file-name "~/miscellany/personal/finance/accounting.journal")
	hledger-email-secrets-file (expand-file-name "secrets.el"
						     emacs-assets-directory))
  ;; Expanded account balances in the overall monthly report are
  ;; mostly noise for me and do not convey any meaningful information.
  (setq hledger-show-expanded-report nil)

  (when (boundp 'my-hledger-service-fetch-url)
    (setq hledger-service-fetch-url
	  my-hledger-service-fetch-url))

  :config
  (add-hook 'hledger-view-mode-hook #'hl-line-mode)
  (add-hook 'hledger-view-mode-hook #'center-text-for-reading)

  (add-hook 'hledger-view-mode-hook
	    (lambda ()
	      (run-with-timer 1
			      nil
			      (lambda ()
				(when (equal hledger-last-run-command
					     "balancesheet")
				  ;; highlight frequently changing accounts
				  (highlight-regexp "^.*\\(savings\\|cash\\).*$")
				  (highlight-regexp "^.*credit-card.*$"
						    'hledger-warning-face))))))

  (add-hook 'hledger-mode-hook
	    (lambda ()
	      (make-local-variable 'company-backends)
	      (add-to-list 'company-backends 'hledger-company))))

(use-package hledger-input
  :bind (("C-c e" . hledger-capture)
	 :map hledger-input-mode-map
	 ("C-c C-b" . popup-balance-at-point))

  :preface
  (defun popup-balance-at-point ()
    "Show balance for account at point in a popup."
    (interactive)
    (if-let ((account (thing-at-point 'hledger-account)))
	(message (hledger-shell-command-to-string (format " balance -N %s "
							  account)))
      (message "No account at point")))

  :config
  (setq hledger-input-buffer-height 20)
  (add-hook 'hledger-input-post-commit-hook #'hledger-show-new-balances)
  (add-hook 'hledger-input-mode-hook #'auto-fill-mode)
  (add-hook 'hledger-input-mode-hook
	    (lambda ()
	      (make-local-variable 'company-idle-delay)
	      (setq-local company-idle-delay 0.1)))
  )
```


## <span class="org-todo done IGNORE">IGNORE</span> Company for completions {#company-for-completions}

Transient: only until I can figure corfu out

```emacs-lisp
(use-package company
      ;; :ensure t
  ;; :bind
  ;;`company-mode-map
  ;; (("TAB" . company-select-next
  ;; ("M-n"     . company-select-next)
      ;;       ("M-p"     . company-select-previous)
  ;;  ))
  :config
  (setq company-idle-delay 0.0)
  :hook
  (after-init-hook . global-company-mode))
```


## <span class="org-todo todo TODO">TODO</span> Corfu for completion-at-point (non-minibuffer kind) {#corfu-for-completion-at-point--non-minibuffer-kind}

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
  (corfu-auto t)

  ;; `indent-for-tab-command'
  (corfu-auto-prefix 3)
  (corfu-auto-delay 0.2)

  ;; size
  (corfu-min-width 80)

  ;; Always have the same width
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle nil)

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

The following might need removal

```emacs-lisp
(use-package corfu
      :bind
      ;; Use TAB for cycling, default is `corfu-complete'.
      (:map corfu-map
	    ("TAB" . corfu-next)
	    ([tab] . corfu-next)
	    ("S-TAB" . corfu-previous)
	    ([backtab] . corfu-previous))

      :config
      ;; TAB-and-Go customizations
      ;; Enable cycling for `corfu-next/previous'
      (setq corfu-cycle t)
      ;; Disable candidate preselection
      (setq corfu-preselect-first nil)

      (corfu-global-mode +1))
```


### CAPE - extensions for corfu {#cape-extensions-for-corfu}

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


## Undo tree {#undo-tree}

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


## Project management and navigation - projectile {#project-management-and-navigation-projectile}

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


## <span class="org-todo done IGNORE">IGNORE</span> Consistent and simpler keybinding assignment {#consistent-and-simpler-keybinding-assignment}

Disabled because I use `use-package` for keybinds

```emacs-lisp
(use-package general
  :disabled
  :config
  (general-define-key
   "M-/" 'hippie-expand
   "M-z" 'zap-to-char))
```


## ERC for IRC {#erc-for-irc}

SystemCrafters recommends this so here I am using it. **Long source
block split into multiple ones**.

```emacs-lisp
(use-package erc

    :straight (:type built-in)

    :config
    (setq erc-server "irc.libera.chat"
	erc-nick "peregrinator"    ; Change this!
	erc-user-full-name "Brihadeesh S"  ; And this!
	erc-track-shorten-start 8
	erc-autojoin-channels-alist '(("irc.libera.chat" "#voidlinux" "#xbps" "#emacs" "#bash" "#sway" "#river" "#systemcrafters"))
	erc-kill-buffer-on-part t
	erc-auto-query 'bury
	erc-server-auto-reconnect t
	erc-server-reconnect-timeout 15)
```

Configuring SASL for automatic authentication

```emacs-lisp
;; continued from above
(add-to-list 'load-path "~/.emacs.d/lisp/erc-libera-sasl")

;; Require ERC-SASL package
(require 'erc-sasl)
(add-to-list 'erc-sasl-server-regexp-list "irc\\.freenode\\.net")

(defun erc-login ()
  "Perform user authentication at the IRC server. (PATCHED)"
  (erc-log (format "login: nick: %s, user: %s %s %s :%s"
		   (erc-current-nick)
		   (user-login-name)
		   (or erc-system-name (system-name))
		   erc-session-server
		   erc-session-user-full-name))
  (if erc-session-password
      (erc-server-send (format "PASS %s" erc-session-password))
    (message "Logging in without password"))
  (when (and (featurep 'erc-sasl) (erc-sasl-use-sasl-p))
    (erc-server-send "CAP REQ :sasl"))
  (erc-server-send (format "NICK %s" (erc-current-nick)))
  (erc-server-send
   (format "USER %s %s %s :%s"
	   ;; hacked - S.B.
	   (if erc-anonymous-login erc-email-userid (user-login-name))
	   "0" "*"
	   erc-session-user-full-name))
  (erc-update-mode-line))
```

Set prompt to channel name:

```emacs-lisp
(setq erc-prompt  (lambda () (concat (buffer-name) " > ")))
```

Highlight nicks

```emacs-lisp
(require 'erc-highlight-nicknames)
(add-to-list 'erc-modules 'highlight-nicknames)
```

Update ERC modules

```emacs-lisp
(erc-update-modules))
```


## Window Management {#window-management}


### EXWM {#exwm}

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


### <span class="org-todo todo TODO">TODO</span> Workspaces with perspective-el {#workspaces-with-perspective-el}

Independent workspaces for different projects like profiles on RStudio
but perhaps a lot more dynamic. This might need more work hence adding
[a link to the project page](https://github.com/nex3/perspective-el) here.

```emacs-lisp
(use-package perspective
  :demand t

  :init
  ;; apparently it's essential to define a prefix on Emacs>=28
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


#### persp-projectile for proper workspace window management {#persp-projectile-for-proper-workspace-window-management}

```emacs-lisp
(use-package persp-projectile
  :bind
  ("C-x x s". persp-projectile-switch-project))
```


### Undo disrupted window/frame arrangement after using some shit {#undo-disrupted-window-frame-arrangement-after-using-some-shit}

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


### Ace-window helps with navigation between multiple windows {#ace-window-helps-with-navigation-between-multiple-windows}

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

Other actions that `ace-window` handles:

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


### <span class="org-todo todo TODO">TODO</span> Sane native window management - needs work {#sane-native-window-management-needs-work}

Focuses new windows when created.

```emacs-lisp
;; Window management
;; focus new windows once created
;; (use-package window
;;   :straight (:type 'built-in)
;;   :bind (("C-x 3" . hsplit-last-buffer)
;;          ("C-x 2" . vsplit-last-buffer))
;;   :preface
;;   (defun hsplit-last-buffer ()
;;     "Gives the focus to the last created horizontal window."
;;     (interactive)
;;     (split-window-horizontally)
;;     (other-window 1))

;;   (defun vsplit-last-buffer ()
;;     "Gives the focus to the last created vertical window."
;;     (interactive)
;;     (split-window-vertically)
;;     (other-window 1)))
```


### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Better popups with popper {#better-popups-with-popper}

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
	    "^\\*Ilist\\*$"))

    ;;grouping popups by projectile groups
    (setq popper-group-function #'popper-group-by-projectile)

    ;; popper UI configguration
    (setq popper-modeline nil)

    (popper-mode +1)
    ;; echo area hints?
    (popper-echo-mode +1)
    )
```


## Display keybinds following various prefixes such as `C-h` {#display-keybinds-following-various-prefixes-such-as-c-h}

```emacs-lisp
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))
```


## Editing root files &amp; privelege escalation for TRAMP if I ever use it {#editing-root-files-and-privelege-escalation-for-tramp-if-i-ever-use-it}

```emacs-lisp
(use-package su
  ;; :config
  ;; (su-mode +1)
  )
```


## Minibuffer completions {#minibuffer-completions}


### <span class="org-todo todo TODO">TODO</span> Completion - is [mct](https://gitlab.com/protesilaos/mct) worth using? {#completion-is-mct-worth-using}


### <span class="org-todo done IGNORE">IGNORE</span> Prescient command history with `M-x` {#prescient-command-history-with-m-x}

```emacs-lisp
(use-package prescient
  :config
  (prescient-persist-mode 1))
;; (use-package selectrum-prescient)
```


### Access a list of recently edited files {#access-a-list-of-recently-edited-files}

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


### <span class="org-todo done IGNORE">IGNORE</span> Selectrum for completions UI {#selectrum-for-completions-ui}

If I rememeber right, this is closer to the default completion
behaviour in Emacs.

```emacs-lisp
(use-package selectrum
  :init
  (selectrum-mode +1)

  :config
  ;; to make sorting and filtering more intelligent
  (selectrum-prescient-mode +1)

  ;; to save your command history on disk, so the sorting gets more
  ;; intelligent over time
  (prescient-persist-mode +1))
```


### Vertico for completions UI {#vertico-for-completions-ui}

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


#### <span class="org-todo todo TODO">TODO</span> Vertico extensions {#vertico-extensions}

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


### Orderless completion {#orderless-completion}

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


### Persistent command history {#persistent-command-history}

Persist history over Emacs restarts. Vertico sorts by history position.

```emacs-lisp
(use-package savehist
    :init
    (savehist-mode))
```


### A few more useful configurations {#a-few-more-useful-configurations}

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


### Richer annotations in minubuffer {#richer-annotations-in-minubuffer}

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


### Consult adds more minibuffer functionality {#consult-adds-more-minibuffer-functionality}

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


### <span class="org-todo todo TODO">TODO</span> Embark - actions; reorganise {#embark-actions-reorganise}

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


### <span class="org-todo todo TODO">TODO</span> Imenu-list? {#imenu-list}

See [Nicolas Rougier's reddit post](https://www.reddit.com/r/emacs/comments/ujuokl/my_take_on_dotemacsorg/), primarily the screenshot which has
an outline for his literate Emacs configuration.

```emacs-lisp
(use-package imenu-list

  :config
  ;; self explanatory
  (setq imenu-list-focus-after-activation t
	imenu-list-auto-resize t
	imenu-list-position 'left)

  ;; further config stolen from https://github.com/rougier/dotemacs.org#sidebar
  (defun peremacs/org-tree-to-indirect-buffer ()
    "Create indirect buffer, narrow it to current subtree and unfold blocks"

    (org-tree-to-indirect-buffer)
    (org-show-block-all)
    (setq-local my/org-blocks-hidden nil))


  (defun peremacs/org-sidebar ()
    "Open an imenu list on the left that allow navigation."

    (interactive)
    (setq imenu-list-after-jump-hook #'my/org-tree-to-indirect-buffer
	  imenu-list-position 'left
	  imenu-list-size 36
	  imenu-list-focus-after-activation t)

    ;; this needs work -
    (let ((heading (substring-no-properties (or (org-get-heading t t t t) ""))))
      (when (buffer-base-buffer)
	(switch-to-buffer (buffer-base-buffer)))
      (imenu-list-minor-mode)
      (imenu-list-stop-timer)
      (hl-line-mode)
      (face-remap-add-relative 'hl-line :inherit 'org-level-1)

      (setq-local cursor-type nil)
      (when (> (length heading) 0)
	(goto-char (point-min))
	(search-forward heading)
	(imenu-list-display-dwim)))

  ;; :hook
  ;; (org-mode . peremacs/org-sidebar)

  :bind
  (("C-c w" . peremacs/org-sidebar))
  )
```


## <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> org-mode setup {#org-mode-setup}

-   [X] Get the damn thing first
-   [ ] Organise the thing - needs splitting into multiple code blocks.

<!--listend-->

```emacs-lisp
(use-package org

  :config
  (setq
   ;; org-ellipsis " ▾"
   ;; hide markers for bold, italic, etc and trailing stars
   org-hide-emphasis-markers t

   ;; fontify code in code blocks
   org-src-fontify-natively t
   org-fontify-quote-and-verse-blocks t
   org-src-tab-acts-natively t

   ;; org-edit-src-content-indentation 2
   org-hide-block-startup nil
   org-src-preserve-indentation nil

   ;; allow for increased space between org
   ;; org-cycle-separator-lines -1

   ;; increase indentation by using odd header levels only
   ;; org-odd-levels-only t

   ;; not sure
   org-adapt-indentation t

   ;; org-startup-folded 'content
   org-capture-bookmark nil
   org-hide-leading-stars t

   ;; display numbers instead of bullets for headings
   org-num-mode t

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

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (R . t)
     ;;(ledger . t)
     ))

  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

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


  ;; block templates
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("li" . "src lisp"))
  (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
  (add-to-list 'org-structure-template-alist '("rr" . "src R"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("lua" . "src lua"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))

  ;; disable electric pairing for angle bracket

  (add-hook 'org-mode-hook (lambda ()
	 (setq-local electric-pair-inhibit-predicate
		 `(lambda (c)
		(if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))))))

```


#### Better commenting in org-mode code-blocks {#better-commenting-in-org-mode-code-blocks}

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


#### <span class="org-todo done IGNORE">IGNORE</span> Better spacing between org-levels with org-padding {#better-spacing-between-org-levels-with-org-padding}

```emacs-lisp
(use-package org-padding

  :disabled

  :straight (:host github :repo "TonCherAmi/org-padding")

  :config

  (setq
   ;; padding on top and bottom of source blocks
   org-padding-block-begin-line-padding '(1.0 . nil)
   org-padding-block-end-line-padding '(nil . 1.0)

   ;; padding for org-headers
   org-padding-heading-padding-alist
	'((2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0) (2.0 . 2.0)))

  :hook (org-mode . org-padding-mode)
  )
```


#### Sources for agenda tasks {#sources-for-agenda-tasks}

Generates an agenda from wildcarded org files from the specified
directory

```emacs-lisp
;; (setq org-agenda-files
;;       (file-expand-wildcards "~/org/*.org"))
```


#### Display features {#display-features}


#### Autoindent/autofill turned on automatically {#autoindent-autofill-turned-on-automatically}

```emacs-lisp
(add-hook 'org-mode-hook 'org-indent-mode)
(setq org-startup-indented t)

;; organise paragraphs automatically
(add-hook 'org-mode-hook 'turn-on-auto-fill)
```


#### Tags and todo-keywords config {#tags-and-todo-keywords-config}

Todo-keywords are things like `TODO` and `DONE` and so on. Tags are for
classifying stuff by the general theme of what's being talked about.

<!--list-separator-->

-  todo-keywords

    ```emacs-lisp
    (setq org-todo-keywords
          '((sequence "TODO(t)" "IN-PROGRESS(i@/!)" "CHECK(c!)" "|" "DONE(d!)" "IGNORE(f!)")))
    ```

<!--list-separator-->

- <span class="org-todo todo TODO">TODO</span>  tags

    ```emacs-lisp
    (setq org-tag-alist '((("misc" . ?m)
    		      ("emacs" . ?e)
    		      ("dotfiles" . ?d)
    		      ("work" . ?w)
    		      ("chore" . ?c)
    		      ("blog" . ?b)
    		      )))
    ```


#### <span class="org-todo todo TODO">TODO</span> Capture templates {#capture-templates}

This will need to be looked at carefully. Roughly, I need to work out
if I'm going to be using `org-agenda` and if so, how will I be using
it. Adding tasks can be made much easier with this. I can also use
this for entering entries into `org-journal`, making it a whole deal
easier. Perhaps to start off, [the org-mode tutorial](https://orgmode.org/worg/org-tutorials/index.html) might be a good
place to start. I've also got a simple enough config from a reddit
post in my [unused local elisp libs](person_el/sample-org-setup.el) too.


#### Bullets for non ordered list {#bullets-for-non-ordered-list}

```emacs-lisp
(font-lock-add-keywords 'org-mode
			'(("^ +\\([-*]\\) "
			   (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))


  (use-package org-bullets
    :config (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

  ;; If like me, you’re tired of manually updating your tables of
  ;; contents, toc-org will maintain a table of contents at the first
  ;; heading that has a :TOC: tag.
```


#### `Table of contents` for org-mode files {#table-of-contents-for-org-mode-files}

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


#### <span class="org-todo done IGNORE">IGNORE</span> Rougier's svg-tag-mode {#rougier-s-svg-tag-mode}

...to replace janky font-related issues with org-modern

```emacs-lisp
  (use-package svg-tag-mode

    :config
    (defconst date-re "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}")
(defconst time-re "[0-9]\\{2\\}:[0-9]\\{2\\}")
(defconst day-re "[A-Za-z]\\{3\\}")
(defconst day-time-re (format "\\(%s\\)? ?\\(%s\\)?" day-re time-re))

(defun svg-progress-percent (value)
  (svg-image (svg-lib-concat
	      (svg-lib-progress-bar (/ (string-to-number value) 100.0)
				nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
	      (svg-lib-tag (concat value "%")
			   nil :stroke 0 :margin 0)) :ascent 'center))

(defun svg-progress-count (value)
  (let* ((seq (mapcar #'string-to-number (split-string value "/")))
	 (count (float (car seq)))
	 (total (float (cadr seq))))
  (svg-image (svg-lib-concat
	      (svg-lib-progress-bar (/ count total) nil
				    :margin 0 :stroke 2 :radius 3 :padding 2 :width 11)
	      (svg-lib-tag value nil
			   :stroke 0 :margin 0)) :ascent 'center)))

(setq svg-tag-tags
      `(
	;; Org tags
	(":\\([A-Za-z0-9]+\\)" . ((lambda (tag) (svg-tag-make tag))))
	(":\\([A-Za-z0-9]+[ \-]\\)" . ((lambda (tag) tag)))

	;; Task priority
	("\\[#[A-Z]\\]" . ( (lambda (tag)
			      (svg-tag-make tag :face 'org-priority
					    :beg 2 :end -1 :margin 0))))

	;; Progress
	("\\(\\[[0-9]\\{1,3\\}%\\]\\)" . ((lambda (tag)
					    (svg-progress-percent (substring tag 1 -2)))))
	("\\(\\[[0-9]+/[0-9]+\\]\\)" . ((lambda (tag)
					  (svg-progress-count (substring tag 1 -1)))))

	;; TODO / DONE
	("TODO" . ((lambda (tag) (svg-tag-make "TODO" :face 'org-todo :inverse t :margin 0))))
	("DONE" . ((lambda (tag) (svg-tag-make "DONE" :face 'org-done :margin 0))))


	;; Citation of the form [cite:@Knuth:1984]
	("\\(\\[cite:@[A-Za-z]+:\\)" . ((lambda (tag)
					  (svg-tag-make tag
							:inverse t
							:beg 7 :end -1
							:crop-right t))))
	("\\[cite:@[A-Za-z]+:\\([0-9]+\\]\\)" . ((lambda (tag)
						(svg-tag-make tag
							      :end -1
							      :crop-left t))))


	;; Active date (with or without day name, with or without time)
	(,(format "\\(<%s>\\)" date-re) .
	 ((lambda (tag)
	    (svg-tag-make tag :beg 1 :end -1 :margin 0))))
	(,(format "\\(<%s \\)%s>" date-re day-time-re) .
	 ((lambda (tag)
	    (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0))))
	(,(format "<%s \\(%s>\\)" date-re day-time-re) .
	 ((lambda (tag)
	    (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0))))

	;; Inactive date  (with or without day name, with or without time)
	 (,(format "\\(\\[%s\\]\\)" date-re) .
	  ((lambda (tag)
	     (svg-tag-make tag :beg 1 :end -1 :margin 0 :face 'org-date))))
	 (,(format "\\(\\[%s \\)%s\\]" date-re day-time-re) .
	  ((lambda (tag)
	     (svg-tag-make tag :beg 1 :inverse nil :crop-right t :margin 0 :face 'org-date))))
	 (,(format "\\[%s \\(%s\\]\\)" date-re day-time-re) .
	  ((lambda (tag)
	     (svg-tag-make tag :end -1 :inverse t :crop-left t :margin 0 :face 'org-date))))))

      (svg-tag-mode t)
  )
```


#### Hide all stars {#hide-all-stars}

Leading or otherwise; procured from [this answer on reddit](https://www.reddit.com/r/emacs/comments/9wukv8/hide_all_stars_in_org_mode/e9pkggv/).

```emacs-lisp
(use-package org
  :config
   (defun org-mode-hide-stars ()
     (font-lock-add-keywords
      nil
      '(("^\\*+ "
	 (0
	  (prog1 nil
	    (put-text-property (match-beginning 0) (match-end 0)
			       'face (list :foreground
					   (face-attribute 'default :background)))))))))

   :hook
   (org-mode-hook . org-mode-hide-stars)
   )
```


#### Minad's modern UI for org-mode (fork) {#minad-s-modern-ui-for-org-mode--fork}

```emacs-lisp
(use-package org-modern
  :straight (:host github :repo "brihadeesh/org-modern")

  :config
  ;; Add frame borders and window dividers
  ;; (modify-all-frames-parameters
  ;;  '((right-divider-width . 2)
  ;;    (internal-border-width . 2)))
  ;; (dolist (face '(window-divider-first-pixel
  ;;                 window-divider-last-pixel))
  ;;   (face-spec-reset-face face)
  ;;   (set-face-foreground face (face-attribute 'default :background)))
  ;; (set-face-background 'fringe (face-attribute 'default :background))

  ;; Org settings
  (setq org-hide-emphasis-markers t
	org-pretty-entities t
	org-auto-align-tags nil
	org-tags-column 0
	org-ellipsis " ▾"
	org-catch-invisible-edits 'show-and-error
	org-special-ctrl-a/e t
	org-insert-heading-respect-content t

	;; configuration
	;; org-modern-hide-stars t
	)

  ;; :hook
  ;; (org-mode . org-modern-mode)
  ;; there is now a global mode
  (global-org-modern-mode t)
  )
```


#### Org-superstar {#org-superstar}

```emacs-lisp
(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  ;;(org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))
  )
```


#### Display emphasis markers on hover {#display-emphasis-markers-on-hover}

This package makes it much easier to edit Org documents when
org-hide-emphasis-markers is turned on. It temporarily shows the
emphasis markers around certain markup elements when you place your
cursor inside of them. No more fumbling around with = and \*
characters!

```emacs-lisp
(use-package org-appear
  :hook (org-mode . org-appear-mode))
```


### <span class="org-todo todo TODO">TODO</span> Org-Babel for literate programming {#org-babel-for-literate-programming}

Org-mode needs org-babel, ob-tangle, live pdf/html preview within
Emacs, hooks to enable auto-fill, linum-mode (?)


### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Denote for note-taking {#denote-for-note-taking}

I hope this is considerably simpler than org-roam and easier to
setup. I don't particularly like the way org-roam is unnecessarily
cluttered and excruciatingly tedious to even get started with.

```emacs-lisp
(use-package denote
    :straight (:host github :repo "protesilaos/denote")

  :config
  ;; Remember to check the doc strings of those variables.
  (setq denote-directory (expand-file-name "~/documents/denotes/"))
  (setq denote-known-keywords '("emacs" "r-stats" "work" "philosophy" "politics" "economics"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-file-type nil) ; Org is the default, set others here
  (setq denote-prompts '(title keywords))


  ;; Pick dates, where relevant, with Org's advanced interface:
  (setq denote-date-prompt-use-org-read-date t)


  ;; Read this manual for how to specify `denote-templates'.  We do not
  ;; include an example here to avoid potential confusion.


  ;; We allow multi-word keywords by default.  The author's personal
  ;; preference is for single-word keywords for a more rigid workflow.
  (setq denote-allow-multi-word-keywords t)

  (setq denote-date-format nil) ; read doc string

  ;; By default, we fontify backlinks in their bespoke buffer.
  (setq denote-link-fontify-backlinks t)

  ;; Also see `denote-link-backlinks-display-buffer-action' which is a bit
  ;; advanced.

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

  ;; Here is a custom, user-level command from one of the examples we
  ;; showed in this manual.  We define it here and add it to a key binding
  ;; below.
  ;; (defun my-denote-journal ()
  ;;   "Create an entry tagged 'journal', while prompting for a title."
  ;;   (interactive)
  ;;   (denote
  ;;    (denote--title-prompt)
  ;;    '("journal")))

  ;; `org-capture' for denote
  (with-eval-after-load 'org-capture
    (setq denote-org-capture-specifiers "%l\n%i\n%?")
    (add-to-list 'org-capture-templates
		 '("n" "New note (with denote.el)" plain
		   (file denote-last-path)
		   #'denote-org-capture
		   :no-save t
		   :immediate-finish nil
		   :kill-buffer t
		   :jump-to-captured t)))


  ;; Denote DOES NOT define any key bindings.
  ;; It requires arguments acceptable to the `bind-keys' macro

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


### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> org-roam {#org-roam}

Start off with networked note-taking in the hope that this **GTD** thing
really works for me. I'll still have to find something to schedule
tasks and organise time with maybe _pomodoro_? Not loading this until
I'm sure this reaches some tangible stage of completion.

```emacs-lisp
(use-package org-roam
  :straight t)
```


### <span class="org-todo todo TODO">TODO</span> Journaling requirements {#journaling-requirements}

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


### <span class="org-todo todo TODO">TODO</span> [Citar](https://github.com/bdarcus/citar) for reference management? {#citar-for-reference-management}

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


### org-present for presentations {#org-present-for-presentations}

See [dawiwil's section on this](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org#presentations) from his literate init for more about
this.


## Multimedia {#multimedia}


### EMMS for music {#emms-for-music}

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


### mpv for video {#mpv-for-video}

```emacs-lisp
(use-package mpv)
```


## Web surfing and more {#web-surfing-and-more}

Got most of these from [daviwil](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org)'s literate configuration


### Gemini {#gemini}

```emacs-lisp
(use-package elpher)
```


### <span class="org-todo todo TODO">TODO</span> mail with mu4e {#mail-with-mu4e}

see [daviwil's mail.org](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Mail.org) and the configuration in his [literate config](https://github.com/daviwil/dotfiles/blob/9776d65c4486f2fa08ec60a06e86ecb6d2c40085/Emacs.org#mail).


### <span class="org-todo todo TODO">TODO</span> Browser {#browser}


### Elfeed for RSS {#elfeed-for-rss}

```emacs-lisp
(use-package elfeed
  :commands elfeed
  :config
  (setq elfeed-feeds
	'("https://drewdevault.com/blog/index.xml"
	  "https://sachachua.com/blog/feed/"
	  "https://guix.gnu.org/feeds/blog.atom"
	  "https://www.reddit.com/r/emacs/.rss"
	  "​https://news.ycombinator.com/rss"
	  "https://scripter.co/index.xml")))
```


## UI configuration {#ui-configuration}


### Highlighted line-mode {#highlighted-line-mode}

<a id="code-snippet--cursorline"></a>
```emacs-lisp
;; cursorline
(global-hl-line-mode 1)
```


### Solid window dividers {#solid-window-dividers}

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


### Something about underlines {#something-about-underlines}

Underline line at descent position, not baseline position

```emacs-lisp
(setq x-underline-at-descent-line t)
```


### <span class="org-todo done IGNORE">IGNORE</span> figure this out too - No ugly button for checkboxes {#figure-this-out-too-no-ugly-button-for-checkboxes}

```emacs-lisp
(setq widget-image-enable nil)
```


### Cursor configuration {#cursor-configuration}

```emacs-lisp
(set-default 'cursor-type  '(bar . 2))
(blink-cursor-mode 1)
```


### Line-number format {#line-number-format}

```emacs-lisp
(setq linum-format "%4d ")
```


### Visual not audible bell {#visual-not-audible-bell}

Flashes modeline for warnings from [purcell](https://github.com/purcell/mode-line-bell)

```emacs-lisp
;; No sound
(setq ring-bell-function 'ignore)

(use-package mode-line-bell
  :config
  (mode-line-bell-mode))
```


### No Tooltips {#no-tooltips}

```emacs-lisp
(tooltip-mode 0)
```


### Minibuffer appearance? {#minibuffer-appearance}

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


### Fringe {#fringe}

No fringe but nice glyphs for truncated and wrapped lines

```emacs-lisp
(fringe-mode '(0 . 0))
```


### Minimalist and ordered mode-line {#minimalist-and-ordered-mode-line}

People seem to use packages for this. I've considered using the
[doom-modeline](https://github.com/seagle0128/doom-modeline) but it seems to be pretty heavy in terms of dependencies
and I'd like a mode-line with a much more fundamental interface
although it's still a good contender considering it's very simple to
configure. I'm also considering [simple-mode-line](https://github.com/gexplorer/simple-modeline).


### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Lambda modeline {#lambda-modeline}

<a id="code-snippet--lamdba-modeline :tangle no"></a>
```emacs-lisp
(use-package lambda-line
  :straight (:type git :host github :repo "lambda-emacs/lambda-line")

  :custom
  ;; Set position of status-line
  (lambda-line-position 'bottom)

  ;; abbreviate major modes
  (lambda-line-abbrev t)

  ;; add some cushion
  (lambda-line-hspace "  ")

  ;; use a prefix symbol
  (lambda-line-prefix t)

  ;; no extra space for prefix
  (lambda-line-prefix-padding nil)

  ;; no invert colors
  (lambda-line-status-invert nil)

  ;; status symbols
  (lambda-line-gui-ro-symbol  " ●")
  (lambda-line-gui-mod-symbol " ●")
  (lambda-line-gui-rw-symbol  " ●")

  ;; padding on top and bottom of line
  (lambda-line-space-top 0)
  (lambda-line-space-bottom 0)

  ;; adjust the vertical placement of symbol
  (lambda-line-symbol-position 0.1)

  :config
  ;; activate lambda-line
  (lambda-line-mode)

  ;; set divider line in footer
  (when (eq lambda-line-position 'top)
   (setq-default mode-line-format (list "%_"))
   (setq mode-line-format (list "%_"))))
```


#### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> Mood-line because I'm fucking tired {#mood-line-because-i-m-fucking-tired}

```emacs-lisp
(use-package mood-line
  :config
  (mood-line-mode)
  )
```


### Font configuration {#font-configuration}


#### Setting a font {#setting-a-font}

<a id="code-snippet--monospaced-fonts"></a>
```emacs-lisp
;; (set-face-attribute 'default nil :font "Unifont Medium 8")
;; (set-face-attribute 'default nil :font "Sudo 9")
;; (set-face-attribute 'default nil :font "Roboto Mono-7.5")
;; (set-face-attribute 'default nil :font "Anka/Coder:pixelsize=10")
;; (set-face-attribute 'default nil :font "Cascadia Mono:style=Light:size=10")
;; (set-face-attribute 'default nil :font "Monoid-7")
;; (set-face-attribute 'default nil :font "Iosevka-8")
;; (set-face-attribute 'default nil :font "mononoki-7.5")
;; (set-face-attribute 'default nil :font "Consolas-8")
;; (set-face-attribute 'default nil :font "Hack-7.5")
;; (set-face-attribute 'default nil :font "Liga SFMono Nerd Font-8")
;; (set-face-attribute 'default nil :font "Terminus (TTF)-9")
;; (set-face-attribute 'default nil :font "Anonymous Pro-8.5")
;; (set-face-attribute 'default nil :font "Dina-8")
;; (set-face-attribute 'default nil :font "Droid Sans Mono-7.5")
;; (set-face-attribute 'default nil :font "Inconsolata:pixelsize=11")

(dolist (face '(default fixed-pitch))
  (set-face-attribute `,face nil :font "Anka/Coder Condensed-7.5"))
```

<a id="code-snippet--variable-pitch-fonts"></a>
```emacs-lisp
(set-face-attribute 'variable-pitch nil :font "Iosevka Aile:size=7")


```


#### Line spacing {#line-spacing}

Usually 0, less if possible but Emacs doesn't allow for that.

```emacs-lisp
;; Line spacing, can be 0 for code and 1 or 2 for text
(setq-default line-spacing 0)
```


### Editor theme {#editor-theme}


#### <span class="org-todo done IGNORE">IGNORE</span> Initial config for moody I guess {#initial-config-for-moody-i-guess}

Something to do with cleaner modeline for `moody.el` although I'm not
sure it works this way.

```emacs-lisp
(let ((line (face-attribute 'mode-line :underline)))
  (set-face-attribute 'mode-line          nil :overline line)
  (set-face-attribute 'mode-line-inactive nil :overline line)
  (set-face-attribute 'mode-line-inactive nil :underline line)
  (set-face-attribute 'mode-line          nil :box nil)
  (set-face-attribute 'mode-line-inactive nil :box nil)
  (set-face-attribute 'mode-line-inactive nil :box nil))
```


#### Externally sourced {#externally-sourced}

<!--list-separator-->

-  Modus themes from Protesilaos!

    This might need additional setting since modus themes are now included
    within Emacs

    ```emacs-lisp
    (use-package modus-themes
        :init
        (setq modus-themes-bold-constructs t
    	  modus-themes-italic-constructs t
    	  modus-themes-region 'no-extend
    	  modus-themes-mode-line '(2)
    	  modus-themes-prompts '(backgound bold intense)
    	  ;; modus-themes-hl-line 'accented
    	  modus-themes-intense-markup t
    	  modus-themes-region '(no-extend bg-only)
    	  modus-themes-subtle-line-numbers t)

        (setq modus-themes-completions
    	  (quote ((matches . (background))
    		 (selection . (semibold background))
    		 (popup . (background)))))

        (defun peremacs/call-modus-operandi ()
          (interactive)
          ;; heading backgrounds work better here
          (disable-theme 'modus-vivendi)
          (setq modus-themes-headings
    	    '((1 . (overline background semibold))
    	      (2 . (overline background semibold))
    	      (3 . (overline background semibold))
    	      (4 . (background semibold))
    	      (t . (regular))))
          (modus-themes-load-operandi))

        (defun peremacs/call-modus-vivendi ()
          (interactive)
          (disable-theme 'modus-operandi)
          (setq modus-themes-headings
    	    '((1 . (overline semibold))
    	      (2 . (overline semibold))
    	      (3 . (overline semibold))
    	      (4 . (semibold))
    	      (t . (regular))))
          (modus-themes-load-vivendi))


        ;; set semibold as the bold face
        ;; (for those fonts that provide this face)
        ;; (set-face-attribute 'bold nil :weight 'semibold)


        :config
        ;; Load the theme files before enabling a theme
        (modus-themes-load-themes)

        ;; Load the theme of your choice:
        ;; (peremacs/call-modus-operandi)
        (peremacs/call-modus-vivendi)
        )
    ```

<!--list-separator-->

- <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span>  Wilmersdorf for dark theme

    I saw this on [doom-themes](https://github.com/hlissner/emacs-doom-themes) but I don't want to pull all of those just
    for this, so installing from it's [GitHub](https://github.com/ianyepan/wilmersdorf-emacs-theme) using `straight.el`. But it
    fails to load with `use-package` so I'm going to have to do it manually.

    ```emacs-lisp
    (use-package wilmersdorf
      :straight (:host github :repo "ianyepan/wilmersdorf-emacs-theme")

      :config
      ;; (load-theme 'wilmersdorf t)
      )
    ```

    The download/setup process should look like this but it'll need some
    work before I can full automate it (since this is a repo that uses
    stow and I'd prefer it be under version control)

    ```sh
    mkdir ~/.emacs.d/themes
    cd ~/.emacs.d/themes
    wget https://raw.githubusercontent.com/ianyepan/wilmersdorf-emacs-theme/master/wilmersdorf-theme.el
    ```

    ```emacs-lisp
    (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
    ;; (load-theme 'wilmersdorf t)
    ;; (load-theme 'Parchment t)
    ```

<!--list-separator-->

- <span class="org-todo todo TODO">TODO</span>  Elegant Emacs from Nicolas Rougier

    Somehow figure out how to incorporate my edits into this - they were
    definitely a lot better for my workflow (doh)

    ```emacs-lisp
    (use-package nano-theme
      :straight (:host github :repo "rougier/nano-theme")

      ;; load theme separately
      ;; (nano-light)
      )
    ```

    This is my fork

    ```emacs-lisp
    ;; I'll have to manually load the theme I guess because this shit is a mess.
      (use-package elegant-emacs
        :straight (elegant-emacs :type git :host github :repo "brihadeesh/elegant-emacs"))
    ```

<!--list-separator-->

-  Tao themes

    Monochrome theme with minimal bold highlights and boxes?

    ```emacs-lisp
    (use-package tao-theme
      :config
      ;; load theme
      ;; (load-theme 'tao-yang t)
      ;; (load-theme 'tao-yin t)
      )
    ```

<!--list-separator-->

-  Expresso theme

    ```emacs-lisp
    (use-package espresso-theme
        :straight (:host github :repo "dgutov/espresso-theme")
        ;;:config
        ;; (load-theme 'espresso t)
        )
    ```

<!--list-separator-->

-  Github dark

    ```emacs-lisp
    (use-package github-dark-vscode-theme
      :config
      ;; (load-theme 'github-dark-vscode t)
      ;; unrelated but the cursor colour really needs improvement
      ;; (set-cursor-color "#ffffff")
      )
    ```

<!--list-separator-->

-  Github modern theme (light)

    ```emacs-lisp
    (use-package github-modern-theme
      :config
      ;; (load-theme 'github-modern t)
      )
    ```

<!--list-separator-->

-  Vale theme

    ```emacs-lisp
    (use-package vale
      :straight (:type git :repo "https://codeberg.org/ext0l/vale.el")
      :config
      ;; (load-theme 'vale t)
      )
    ```

<!--list-separator-->

- <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span>  Parchment theme

    Based on the screenshot of Haskell code on the [Pragmata Pro website](https://fsd.it/shop/fonts/pragmatapro/#tab-fb289adf-7c14-8).

    ```emacs-lisp
    (use-package Parchment-theme
      :straight (:host github :repo "brihadeesh/emacs-parchment-theme")
      :config
      (load-theme 'Parchment t)
      )
    ```

<!--list-separator-->

-  Almost mono theme

    ```emacs-lisp
    (use-package almost-mono-themes
      :config
      ;; (load-theme 'almost-mono-black t)
      ;; (load-theme 'almost-mono-gray t)
      ;; (load-theme 'almost-mono-cream t)
      ;; (load-theme 'almost-mono-white t)
      )
    ```

<!--list-separator-->

-  Stimmung themes for nearly monochrome appearance

    ```emacs-lisp
    (use-package stimmung-themes
      ;; :straight (stimmung-themes :host github :repo "motform/stimmung-themes") ; if you are a straight shooter
      :config
      ;; (stimmung-themes-load-dark)
      )
    ```

<!--list-separator-->

-  Commentary

    An elegant theme highlighting comments only

    ```emacs-lisp
    (use-package commentary-theme
      ;;:config
      ;;(load-theme 'commentary t)
      )
    ```


#### <span class="org-todo todo IN_PROGRESS">IN-PROGRESS</span> My themes (LOL) {#my-themes--lol}

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


#### Pulse to locate cursor with Protesilaos's pulsar {#pulse-to-locate-cursor-with-protesilaos-s-pulsar}

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
   (setq pulsar-pulse-on-window-change t)
   (setq pulsar-pulse t)
   (setq pulsar-delay 0.055)
   (setq pulsar-iterations 10)
   (setq pulsar-face 'pulsar-yellow)

   (pulsar-global-mode 1)

   :bind (("C-c l" . pulsar-pulse-line)
	  ("C-c h l" . pulsar-highlight-line)
	  ("C-l" . pulsar-recenter-middle))

   :hook
   (consult-after-jump-hook . pulsar-recenter-middle)
   (consult-after-jump-hook . pulsar-reveal-entry)
   (imenu-list-after-jump . pulsar-pulse-line))
```
