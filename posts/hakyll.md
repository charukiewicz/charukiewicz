---
title: Switching from Jekyll to Hakyll
disqus: yes
date: 2015-05-15
---

## Motivations

Earlier this year I decided to begin learning Haskell.  I have been working my way through the [Learn You a Haskell](http://learnyouahaskell.com/chapters) textbook.  So far it has been a very interesting experience and a pleasant departure from the normalcy of imperative programming that I am used to.  As I get further into it, however, I am realizing that the learning curve is only getting steeper.  I think the following image is true:

![](/images/haskell-curve.png)
<center>Source: [Learning Curves (for different programming languages)](https://github.com/Dobiasd/articles/blob/master/programming_language_learning_curves.md)</center>

At this point I am fairly sure that I am somewhere between a low and high point in the initial series of peaks.  Either way, since *Learn You a Haskell* is a little slow in terms of how quickly it introduces material, I figured it would be useful to begin doing something practical with Haskell with what I have learned.  I read about [Hakyll](http://jaspervdj.be/hakyll/) last year, a while after initially making this blog in [Jekyll](http://jekyllrb.com/).  At the time I was somewhat intimidated by it.  Not knowing any Haskell at all can make looking at even the relatively short `site.hs` file feel like reading hieroglyphics.

Now that I am fairly comfortable with the basic syntax of Haskell, I realize that there is not really all that much to Hakyll in terms of complexity.  Getting a blog up with Hakyll might be even faster than getting a blog up with Jekyll (barring the couple couple of *gigabytes* of data and *dozens* of dependencies required to get Hakyll working).

## The Experience so Far

The initial switch to Hakyll was incredibly simple and easy.  In fact, I was not even intending on doing it on the night that I did, I only meant to take a read through the website and had planned on doing it some weekend soon.  Instead, after updating `hakyll`, compiling the default `site.hs` file, and then running a local preview server with the executable's `watch` command, I realized that that was all there was to it.

Experience with both Markdown and Jekyll did definitely help me understand what I was doing.  I moved the content from my Jekyll directory over to my Hakyll directory, built the site, initiated a git repository, and after a push to GitHub and a pull on my droplet, the Hakyll version of the blog was live.

I find the simplicity of Hakyll to be really appealing, although I realize that there must be a ton of moving parts abstracted away from the user that go into making the whole thing work.  With little to no premade Hakyll themes floating around, and what seems like far fewer directories and files then Jekyll throws at the user by default, I get the impression that building a site with Hakyll will feel a lot more like a "ground up" approach.

## Not All Positives

Although I have an overall positive impression of Hakyll at the moment, even in my very short time using it I have encountered a string of issues.  I will say that the initial process of getting the site up and running was very smoothly done on my [Manjaro Linux](https://manjaro.github.io/) PC.  I am grateful for Manjaro's access to the [Arch User Repository](https://aur.archlinux.org/), where I have been able to download every single application I have ever needed since I started using it.  That last statement is not an exaggeration; literally *every single one*.

The issues that I had encountered, however, have been on both my Digital Ocean droplet (where this blog is hosted) as well as in the [crouton](https://github.com/dnschneid/crouton) chroot of my Chromebook.  In both the droplet and in crouton, I am running Ubuntu 14.04.  I began by attempting to install Hakyll on the droplet, and the first thing I got was strange exit errors even when trying to update `cabal`.  It turns out that even updating `cabal` requires a lot of memory, so I scaled up my droplet from 500 MB to 2 GB.

Resizing the droplet solved the memory issue, but allowed me to discover that the install process would crash when attempting to install `pandoc`.  After doing some research it appeared that the issue was caused by a `cabal` bug.

I [found instructions](https://gist.github.com/yantonov/10083524) on how to move past Ubuntu's default `ghc` version of 7.6.3 to 7.10.1, along with a newer `cabal`.  After quite a bit of waiting for everything to install multiple times, I finally managed to get Hakyll running and my `site.hs` file compiled on my droplet.  Except, when I resized my droplet back down to 500 MB it appeared that `ghc` was broken, my `site` executable file was broken, and `cabal` was having issues.

Having conceded that getting Hakyll working on the droplet was a lost cause, I decided to try to get it working on the Chromebook.  I went through the entire 45 minute long install process on the Chromebook, only to find that when I finally ran the `build` command with the `site` executable, I was getting some sort of text encoding error from `pandoc`.

At this point I have given up on both the Chromebook and the droplet.  I assume the Chromebook's issue is fixable.  For the time being I am content with only being able to compile and build my website from my Manjaro PC.

## A Few Lessons Learned

I think I have heard the phrase "cabal hell" somewhere on the [Haskell subreddit](http://www.reddit.com/r/haskell) a few times.  I have also heard mention of things like different `ghc` versions leaving people with uncompilable code.  I think that I am now catching a glimpse of both of these.

These issues are both unpleasant and costly, particularly in terms of time.  I certainly hope that other experiences I have plan on having with Haskell do not turn into more of the same.  I have faith in Haskell and its incredibly helpful community, but I have now witnessed firsthand not everything always being hunky-dory.
