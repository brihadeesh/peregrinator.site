+++
title = "Hugo, Org and starting over at a new job"
author = ["peregrinator"]
date = 2022-12-05T00:00:00+05:30
lastmod = 2022-12-05T12:29:19+05:30
tags = ["emacs"]
draft = false
creator = "Emacs 29.0.50 (Org mode 9.6 + ox-hugo)"
series = "Blogging with Emacs"
+++

I'd decided to give up on my free WordPress blog a while back, after
having watched a SystemCrafters [video](https://youtu.be/AfkrzFodoNw) on how to blog from Emacs (_d'oh_,
I just _have_ to do everything from Emacs). Of course, daviwil only
covered the basics of writing and exporting using Emacs' built-in
packages and later for deploying it on GitHub / Sourcehut pages. And
it took me a good year to get down to making the switch but apparently
moving to a new place for work is the motivation it required. It felt
like cheating to use Jekyll on GitHub and I wanted something that
could be deployed to a Sourcehut site easily too (Sourcehut blocks any
CDN-based CSS loaded into the site's HTML) and I wanted something
extremely minimal, like Drew Devault's [blog](https://dredevault.com/) but with even fewer
frills - no images anywhere except for if a blog post required
them. Looking at his blog source, however, made me realise that there
was a lot more to that minimalism than one could see.


## Basic setup {#basic-setup}

This has come through fairly well, so far. I've got an [org-capture
setup](/emacs/emacs-literate-configuration/#ox-hugo-since-the-go-org-keep-wrecking-up-links) for this that links up every new entry captured into a master
posts file, adding all the relevant info.

```emacs-lisp

(with-eval-after-load 'org-capture
          (defun org-hugo-new-subtree-post-capture-template ()
            "Returns `org-capture' template string for new Hugo post.
        See `org-capture-templates' for more information."
            (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
                   (fname (org-hugo-slug title)))
              (mapconcat #'identity
                         `(
                           ,(concat "* TODO " title)
                           ":PROPERTIES:"
                           ,(concat ":EXPORT_HUGO_BUNDLE: " fname)
                           ":EXPORT_FILE_NAME: index"
                           ":EXPORT_HUGO_AUTO_SET_LASTMOD: t"
                           ":END:"
                           "%?\n")          ;Place the cursor here finally
                         "\n")))

          (add-to-list 'org-capture-templates
              '("h"                ;`org-capture' binding + h
                "Hugo blog post"
                entry
                (file+olp "~/my_gits/brihadeesh.github.io/content-org/blog/posts.org" "Posts")
                (function org-hugo-new-subtree-post-capture-template))))
```

Exporting to markdown (Org just doesn't have a good enough support
yet), tags and organisation of pages into bundles is handled by
[ox-hugo](https://ox-hugo.scripter.co), a wonderful package for Emacs written by Kaushal Modi
([website](https:scripter.co)). The header arguments in the capture template cover
everything. With Emacs's `.dir-locals.el` feature, a file of that name
in the home directory of the blog ensures every new entry or
modification into the master posts file gets auto-exported to markdown
on save. The contents are quite simple.

```emacs-lisp

;; ~/.dir-locals.el
(("content-org/"
  . ((org-mode . ((eval . (org-hugo-auto-export-mode)))))))
```

With Emacs's Org mode, this posts file has subheadings under a
_Posts_ header, each of which is a blog post and is exported to a
sub-directory under `~/content/posts/` as a lone `index.md` keeping with
the page-bundle kind of organisation.

A `tree` run for the content directory shows:

```sh

$ tree content
content
├── about
│   └── index.md
├── emacs
│   └── index.md
├── emacs-literate-configuration
│   └── index.md
├── _index.md
├── posts
│   ├── a-dark-side-to-pets
│   │   └── index.md
│   ├── introduction
│   │   └── index.md
│   ├── misunderstanding-evolution
│   │   └── index.md
│   └── pets-put-in-context
│       └── index.md
└── publications
    └── index.md
```

where every sub-directory in the top-level directory has a page of its
own while the home-page is the sole `_index.md` in the same. What I've
got going feels a little hacky but I'll figure this out.


## Issues {#issues}

There's still a lot to fix

1.  heading anchors on top-level pages are superfluous
2.  maybe consider switching to a theme-agnostic setup like Drew's
3.  get rid of unnecessary indentation like in the table of contents and headings
4.  add anchors even to lower level headers
5.  switch to a Sourcehut site (eventually and when I can afford it)


## Further reading {#further-reading}

This is but a blog post written, and edited, within half an hour so I
haven't likely covered a lot of important bridging information. I'll
add some links to others' blog posts or documentation as I come across
them.

1.  ox-hugo: [website](https://ox-hugo.scripter.co) and [GitHub](https://github.com/kaushalmodi/ox-hugo)
2.  (alternatively) [go-org](https://github.com/niklasfasching/go-org), the native Org backend for Hugo
