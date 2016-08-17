---
title: Software Development on the Chromebook Pixel
disqus: yes
date: 2015-06-20
---

## Background

In March of this year, Google released the new [Chromebook Pixel](https://www.google.com/chromebook/pixel/).  Having used ChromeOS for most of a year on the Acer C720 Chromebook and very much enjoying it, I did not hesitate to retire the C720 and buy the Chromebook Pixel LS.  This "Ludicrous Speed" version of the Pixel comes with a Core i7 processor, 16 GB of RAM, and a 64 GB SSD.  Both versions of the new Pixel sport a fantastic 2560 x 1700 pixel resolution screen (which has a unique 3:2 aspect ratio), a great keyboard, touchpad, and a 12 hour battery life.  Each Pixel also has two USB-C ports, which can be used for charging, data transfer, display and audio output, and even ethernet.

The Chromebook Pixel LS is a fantastic device, with very fairly priced hardware.  I have absolutely no complaints about the build quality and hardware features at all, although I will admit that I would have happily paid a bit more for a 128 GB SSD.  But this post is not a Chromebook Pixel LS review.  You can find hundreds of those all over the internet.  Instead, I am going to talk about my software development environment and workflow on the Pixel.  After using it on a daily basis for nearly 3 months now, I can share the experience of using the Pixel for this purpose with detail.

## Environment Setup

When I used the C720, I did all of my software development in Linux via crouton.  This allowed me to run Linux side-by-side with ChromeOS, and switch between the two seamlessly.  In Linux, I was able to do all the things I would normally do: install packages, run daemons, host a local MySQL and Apache server, etc.

Going into the purchase of the Chromebook Pixel, my research revealed that it was actually quite possible to do all of my software development without relying on Linux through crouton.  I will discuss the motivations for this decision later on.  But doing this required a bit of a setup.  I will walk through everything I did in the first few weeks of using the Chromebook Pixel.

#### Developer Mode

Putting the Chromebook into [developer mode](https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/chromebook-pixel-2015#TOC-Developer-Mode) is the first step towards getting the most out of it.  Developer mode primarily allows for access to a full featured Linux shell (via the `shell` command) in the terminal.  This is necessary for the successful execution of the next few items on this list.

To put the Chromebook in developer mode:

1. Hold down the **ESC** and **Refresh (F3)** keys.
2. While holding the keys, press the **Power** button.  This will cause the Chromebook to reboot.
3. When you are met with the white recovery screen, press **Ctrl-D** and follow the instructions.

That is all there is to it.  But it is worth noting that this process **clears everything stored locally on your Chromebook**.  Any important files should be backed up prior to putting a Chromebook into developer mode.

#### dev\_install

Once the Chromebook is in developer mode, you can install the [dev\_install](https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/install-software-on-base-images) script, which gives access to a number of useful packages aimed at Chromium OS developers.  These are tools that you would find on most Linux systems.  My purpose for running this script was to get access to sshfs, but since installation takes up a bit of SSD space, it is worth mentioning that there is now a Chrome app that acts as an alternative to this process (described in the next section).

To run the script:

1. Open a terminal with **Ctrl+Alt+T**.
2. Type `shell` to go into the true Linux shell (which is what developer mode enabled).
3. Type `dev_install`.  This begins the install process and prompts the user with a few questions.

Once this is complete, the `emerge` command becomes available, which can be used to install the various aforementioned packages.  Unfortunately, `emerge` does not give access to all the packages one would expect to be able to install (it is no `apt-get` or `pacman`), but it can be useful.

#### sshfs / sftp

sshfs is a utility that allows an remote filesystem to be mounted in a local directory.  Simply put, you can take a directory that is on some server somewhere and turn it into a ChromeOS folder.  Doing this allows you to manipulate all of the files in said folder with any ChromeOS applications.

sshfs can be installed with the `emerge` command.  Installing the `sshfs-fuse` package will enable the `sshfs` command.  The syntax for its usage is

`sshfs [user]@[host-ip-address]:[/path/to/directory] [/path/to/mountpoint]`

There are a number of other flags you can specify (such as `-p` for port).  I found that the command would give me an error if I used the host's domain name rather than IP address, but your mileage may vary.

The other way to mount a remote directory is through the [SFTP File System](https://chrome.google.com/webstore/detail/sftp-file-system/gbheifiifcfekkamhepkeogobihicgmn) Chrome app.  I have not personally tested this functionality, but it looks like this is actually a great potential alternative to the need for developer mode and dev\_install altogether.  I discovered this app thanks to a recommendation from the [ChromeOS subreddit](http://www.reddit.com/r/chromeos/comments/39s3ew/a_tip_for_chromebook_web_developers/).

#### Caret

[Caret](https://chrome.google.com/webstore/detail/caret/fljalecfjciodhpcledpamjachpmelml) is an awesome Sublime-like text editor for ChromeOS.  It is a Chrome app, so it gets its own dedicated window and shares a large number of Sublime's features.  Used in conjunction with sshfs or sftp, Caret can be used to edit remote files on any server.  Make sure to set the `disableReload` option to `true` in the Caret configuration file to prevent the cursor from bouncing to the top of the file every few seconds (which happens only when editing remote files).

#### Chrome MySQL Admin

[Chrome MySQL Admin](https://chrome.google.com/webstore/detail/chrome-mysql-admin/ndgnpnpakfcdjmpgmcaknimfgcldechn) is a lightweight MySQL Chrome app that is very easy to use.  It is not quite as powerful as MySQL workbench or even phpMyadmin, but it gets the job done for database servers that do not have phpMyadmin installed.

One of the great aspects of Chrome MySQL Admin which I have not seen anywhere else is that the app will sync your saved database connections to Chrome.  This means that if you access the app on another computer later on, your connections are available to you as long as you are logged into Chrome with your Google account.  If security is an issue, simply do not add a connection to the app's favorites list or do not log into your Google account on a computer where it may be dangerous to do so.

#### crouton

[crouton](https://github.com/dnschneid/crouton), mentioned earlier, allows for the installation of Linux into a chroot side-by-side with ChromeOS.  crouton allows for the installation of various operating systems, including a few versions of Ubuntu, Kali Linux, Debian, etc.  There is also [chroagh](https://github.com/drinkcat/chroagh) which is a fork of crouton made specifically to cater to Arch Linux.

When installed, crouton can be accessed via the ChromeOS terminal directly in a tab using only a command line interface, as well as with a graphical desktop environment (Xfce being the default).  You can configure crouton to start its own window session and then switch between ChromeOS and Linux using keyboard shortcuts, or as of a few months ago, you can now use the `xiwi` target in your installation to make the Linux GUI run inside of a resizeable (and full-screenable) ChromeOS window.

Even though I am not using crouton for most of my development, there are certain situations where having acess to full blown Linux is useful.  I consider my crouton installation a sort of emergency backup that only gets used once in a while when I need access to specific tools locally.

#### Vim

Vim is certainly not directly related to ChromeOS, but its use in my workflow has become very significant.  Vim is a lightweight and very old command line based text editor that has a very strong following amongst a large number of software developers.  Vim also has a significant learning curve.  I will discuss the role that Vim plays in my development setup more later.

#### tmux

Where Vim is the yin, tmux is the yang.  tmux (short for "Terminal Multiplexer") is a utility that allows for the splitting of a terminal into multiple panes.  This may seem pointless if you are using a local machine with a desktop environment where you can just open as many terminal windows as you need, but it becomes a necessity when working over ssh.  Overall, tmux is a significant time saver to anyone who does a lot of command line work.

## Environment Decisions

As I said towards the beginning of this post, my goal was to do development on the Pixel without using crouton, and only having it installed as a sort of emergency backup.  I had a few reasons for this:

* While crouton is usually reliable, experience has shown that silent updates to ChromeOS will break functionality that crouton depends on.  Fixing these issues is usually as simple as updating crouton, but sometimes it may take a few days for the update to actually be released by the crouton developers.
* Configuration of all of the various daemons and servers to replicate the actual application I am developing to a local environment is a Sisyphean task.  In the past year, due to various operating system reinstalls and even an SSD failure, I have to reinstall the application infrastructure at least five separate times.  The arrival of the Pixel prompted me to move this infrastructure to a remote development server and I am fairly confident I will never have to go through this process again.
* Actually running all of the daemons and servers mentioned above as local applications takes up system resources.  The Chromebook Pixel LS can absolutely handle doing this, but with how easy it is to avoid doing this, it is a better option to outsource this work.  By not having to run things like a MySQL database, a Redis instance, a NodeJS server and an Apache server locally, I can preserve the Pixel's CPU, RAM, and particularly the SSD space for other things that cannot be offloaded.  Just as importantly, a reduction in load on the CPU means a longer battery life.
* The super high resolution screen of the Chromebook Pixel is not handled very well by desktop environments like Xfce.  Text in many panels and tabs ends up being absolutely tiny and the interface overall does not scale very well.  Changing configuration can fix a few things but it is quite obvious that the environment is not yet ready to handle such a screen perfectly.  This problem could be avoided by using crouton in command line mode only straight out of the ChromeOS shell, but at that point the usage becomes indistinguishable from using a remote server.

Looking at these points, we can see that there is no single overwhelming reason not to use a local instance of Linux via crouton to do development on the Pixel.  But in aggregate, these points add up to make a solid case against using doing so.  What's more is that they also build a case against using a local development application setup *in general*, regardless of operating system.  Offloading the replication of the development application to a remote server seems like a better option all around, whenever doing so is possible.  This is something that I had not really thought so much about until I was faced with this decision around the time I bought the Pixel.

## Evolution of the Workflow

So the question is, what do I actually do?  I have listed my tools and I just described what I opted *not* to do.  Now, onto what I actually do use.  To begin with, my actual development application is hosted on a remote Linux server.  This server is an Ubuntu 14.04 VPN that replicates our production servers but on a much smaller scale.

My initial plans for using the Pixel included strongly relying on sshfs and Caret to do my development.  That is, I would mount the remote directory that contained the project source code using sshfs, and then use Caret for the actual editing.  This was the most appealing option initially, particularly because I had been coming from using Sublime.

I found that using Caret was okay, but not perfect.  The main reason for this was the fact that I was editing a rather large project (hundreds of files with well over 100k lines of code) remotely.  Loading all of these files as a project into Caret took a substantial amount of time (longer than even the slowest of IDEs opening), and I had to go through this process every time I would remount the remote directory, which was at least once a day.  I also experienced minor synchronization issues with the files themselves and the file tree displayed in the Caret sidebar.

At this point I realized that I had a few options.  I could either deal with these minor issues and trudge onwards with Caret, or I could attempt a few fixes by making permutations of the same overall setup (such as using sftp instead of sshfs, and seeing if that changed anything).  I also had the option to do all of the work using a different approach altogether.  The option of using Vim was staring me in the face.

I was somewhat apprehensive about switching to using Vim initially, as I knew it would probably slow me down to begin with.  This proved to be an unnecessary concern.  The basic knowledge I had picked up of Vim from using it in college (knowing things like normal vs insert mode, and commands like `dd`, `yy`, `p`, `o`, `cw`, `:##`, and `:wq`) was sufficient to get started.  As time passed, I read a few tutorials and gradually added new commands to my regular usage.  As this happened, my [.vimrc file](https://github.com/charukiewicz/dotfiles/blob/master/vim/.vimrc) also grew.  Using tmux also was a challenge at first, as its key bindings are somewhat unintuitive.  But with a bit of looking at reference material, and through sheer persistence, I was able to become comfortable with Vim in conjunction with tmux within a few weeks.

At this point, I have moved away from using Caret for nearly all programming and do virtually everything in Vim.  Vim lives on the remote server that I do my development on.  When I connect to my server, the first thing I do is start tmux and then usually create at least three panes.  One is for Vim, and the others will usually be for some sort of cli utilities or server console output.  It is worth mentioning that the combination of the high resolution and aspect ratio of the Pixel's screen makes looking even at very small text on multiple panes really easy.

I do still use Caret for some things.  When I download a file that I want to open and look at, Caret is the best option to use on ChromeOS.  Additionally, if I open a log file or something similar, Caret is no worse of an option than Vim is for the purpose of viewing it.  So to sum up, I found that remotely using Vim is the best option to do any serious programming, but to simply view files, using Caret locally is comparable, if not better.

Finally, for database management I use a conjunction of the Chrome MySQL Admin app and phpMyAdmin depending on which servers I am working with.  In the case of exporting and particularly importing very large database files, I will simply ssh into the database server and use the command line to get any work done.  When I am working with Redis, I will use the command line application to do everything.

## Parting Thoughts

Taking the time to write this post has allowed me to realize that even though the tools and environment setup on my Chromebook Pixel are far removed from what the average ChromeOS user would use on a daily basis, I am still using the operating system in the underlying manner that goes in line with what was envisioned by Google.  That is, all of my work is done remotely, in "the cloud", with only a minor reliance on the actual software on the Chromebook itself.  Looks like Google was right all along.

A corollary of all of this is that this setup is not actually bound to the Chromebook Pixel itself.  On days that I work from home, I will use a full sized PC, which is running Manjaro Linux.  To get started, all I have to do is ssh into my development server and I pick up exactly where I left off from the office the day before.  The Pixel might not even leave my bag on those days.

Furthermore, if my Pixel got smashed, stolen, ran over by a train, or stopped a bullet, I would be able to continue working the moment I got my hands on any computer that I could access ssh on.  And since I ended up not even using sshfs in the end, I could quite easily avoid putting a replacement Chromebook in developer mode and going through the first few steps of my setup altogether.  The only thing I would need to do on a fresh Chromebook would simply be to log into my Google account.  Caret and Chrome MySQL Admin would already be installed thanks to the sync features ChromeOS has.

All in all, I am very pleased with this setup and it suits my need perfectly.  I get access to the Chromebook Pixel's fantastic hardware, get to use the extremely snappy and minimal ChromeOS, and ultimately work in an environment that is totally decoupled from the actual device, lending itself to maximum portability by being accessible from any computer that I would ever need to work from.
