+++
title = "Blog revamp and starting to understand Hugo better"
author = ["peregrinator"]
date = 2023-02-23T16:24:00+05:30
lastmod = 2023-02-23T16:24:00+05:30
draft = false
series = "Blogging with Emacs"
+++

I'd decided to make the switch to a blogging workflow that I could use
with Emacs back in December and [wrote about](/blog/2022/12/hugo-org-and-starting-over-at-a-new-blog.html) setting it up from
scratch. Since I wasn't yet acquainted with writing original layout
templates, style-sheets or with organising content into sections in as
simple and sane a manner as I wanted to, I'd settled for outsourcing
most of this to a fairly [basic theme](https://github.com/LukasJoswiak/etch). Over time, I grew dissatisfied
with how the site looked and how it organised my content and so I
spent some time customising the theme, which took a while to figure
out. I wasn't happy with it still. I then tried changing themes a few
times but couldn't find anything that really worked for me. That I
didn't want any JavaScript I didn't understand, or could understand
for that matter, effectively eliminated a lot of the options I had
considered.

It then dawned on me that I could maybe attempt writing a theme for
myself from (nearly) scratch when I found two themes that seemed to
check out most of my requirements. The first of these was [rocinante](https://github.com/mavidser/hugo-rocinante/) by
[Sid Verma](https://github.com/mavidser), a great and adequately minimal theme with added support for
photo albums as posts. My only qualms with it were the somewhat messy
style sheets and cryptic templates that made personalising a bit of an
ordeal. The second, however, was simply genius and it took me close to
no time to figure it out, despite thinking it to be too advanced for
me - there was no theme sub-module and everything was in the home
directory it was from somebody's personal website.

Needless to say, it was Drew DeVault's and I'd seen it as something of
an inspiration from the start. A quick glance at [Drew Devault's blog](https://drewdevault.com)
should convey what I mean by minimal and functional. I jumped right
into a local clone of his [sourcehut repo](https://git.sr.ht/~sircmpwn/drewdevault.com) and got down to making it my
own. I added some minor spice to the `single.html` layout under `blog` and
made an additional few for

1.  posts from my Wordpress blog I didn't want listed on the homepage
2.  a section index that listed the above
3.  fiction (just the one post)
4.  an _About me_ page (not a section, unlike before)
5.  the browser friendly copy of my [Literate Emacs Configuration](/emacs/literate-emacs-configuration.html) with a
    table of contents in the sidebar and heading anchors.

I realised I didn't want unnecessary taxonomy pages like before or
like those from the rocinante theme and that all my regular blog
posts, Emacs configuration and fiction on the homepage. The prospect
of having to write descriptions for each of these - had I maintained
separate sections for each like before - was daunting, to say the
least.

I also loved the idea of displaying "featured posts" from the blogs I
follow through Drew's own [openring](https://git.sr.ht/~sircmpwn/openring), written in Go. The only issue I
encountered was with adding this to the Github actions workflows since
it's not as straightforward as the one Sourcehut uses and the absurdly
large number of modules is mind-boggling. Until I find a way of
getting this automated, I'll have to keep at running the command
manually every few days before committing/pushing changes.

```sh

openring \
    -s https://drewdevault.com/blog/index.xml \
    -s https://sourcehut.org/blog/index.xml \
    -s https://ambikamath.com/feed/ \
    < webring-in.template \
    > layouts/partials/webring-out.html
```

There were also some issues with date handling in the ox-hugo setup
and I ended up rewriting the org-capture template to allow for entries
into both the main blog section and the miscellaneous one. The capture
template now looks like this:

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

That's about it for now. I deliberately kept this brief and avoided
discussing a bunch of tangential points like design choices and the
"criteria" for making this the best starting point for my blog. I'll
perhaps cover those in later articles.
