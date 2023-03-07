+++
title = "Moved to Sourcehut!"
author = ["peregrinator"]
date = 2023-03-04T03:51:00+05:30
draft = false
+++

I wrote to Drew DeVault a couple of days back, after much deliberation
on whether I should really bother him and the like, about free access
to Sourcehut builds so I could move away from Github and Gitlab. He
responded soon after that saying that he'd given me a year's
access. And I've finally done it! The blog that started off titled
_peregrinator's sourcehut site_ along with an explanation on why it was
called that while hosted on Github-pages is finally here! The next
step would be to move to a personal or custom domain of my own, but
that's a long way into the future, yet.

In any case, this brings me closer to what I've got planned for my
internet presence - minimal and without JavaScript. Although I'm
pleased with how this has _simplified_ a lot of things, this also means
a few new things to keep in mind for me and this is perhaps of most
interest here.


## Git {#git}

I've been honing my command-line git skills over the last few years
but since repository settings are threadbare on Sourcehut, I'll have
to really step up my game here. I've already faced some minor setbacks
to my work, on this blog incidentally. I'd _gitignored_ the folder with
the Org-mode sources for all of my blog posts and other pages and then
checked out an older version of my blog posts source from the last
commit with the file. Since this was from prior to adding `gitignore`
functionality, it was at-least an entry older with a bunch of crucial
changes I'd made yesterday. I had to manually recover this eventually.

Maintaining multiple branches, juggling remotes - since this shares
its files with those from my older Github-pages site - all was a bit
overwhelming initially but I've managed to clean up most of the cruft
and I'm starting to get more confident around git.


## Content restrictions {#content-restrictions}

The biggest "hit" I've taken is the restrictions on third-party
content - see [Albums of the Year](/blog/2023/02/albums-of-the-year-2022.html), my last post for example. The
Sourcehut site documentation states that they disallow external
style-sheets, especially those accessed via CDNs but crucially
third-party embedded content[^fn:1]. This shouldn't mean
much to most - especially if the content of blog posts is text and
some code - but since some of my posts are about music, I find that
this restriction gets in my way. I cannot add embedded albums or
tracks Bandcamp. Bandcamp is what I prefer when it comes to music
since they're the most artist-friendly amongst streaming
platforms[^fn:2].

I've since changed my Bandcamp shortcode from a minimal, single
positional argument based kind to one that uses an additional URL
rendered as a simple link below the `iframe`. Of course, with Sourcehut
pages, the `iframe` is just a blank rectangle of the same dimensions as
the embedded Bandcamp content.

```html+

Find them on <a href="{{ .Get "url" }}">Bandcamp</a>
<iframe style="border: 0; width: 400px; height: 42px;"
    src="https://bandcamp.com/EmbeddedPlayer/album={{ .Get "id" }}/size=small/tracklist=false/bgcol=ffffff/linkcol=0687f5/transparent=true/" seamless>
</iframe>
```

[^fn:1]: See the documentation for
    _Limitations_ with Sourcehut sites at [https://srht.site](https://srht.site/limitations); the rest don't
    affect me as much
[^fn:2]: _Citation?_