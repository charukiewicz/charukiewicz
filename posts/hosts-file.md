---
title: Replacing Adblock Plus with the hosts file
disqus: yes
date: 2014-07-15
---

<div style="color:#555;font-size:14px;">
*Updated on February 15, 2016* <small>[[jump](#update)]</small>
</div>

## The Reign of Adblock Plus

I started using Adblock Plus in 2006, the year it was released for Mozilla Firefox.  This was two years before Google Chrome was even released.  For anyone who was even slightly technologically savvy, the advent of Adblock Plus had a huge impact on web browsing.  It changed the playing field and gave people a huge reason to migrate to Firefox and away from Internet Explorer.  Between addons (specifically Adblock Plus), and tabbed browsing, Firefox was a big deal.

In 2011, I encountered an issue with Firefox where it simply refused to open on my Windows machine.  Even a reinstall wouldn't fix whatever problem I had at the time, so I migrated to Google Chrome.  I've been using Chrome ever since.  What came with me, however, was Adblock Plus.

A few months ago I read [an article](http://www.reddit.com/r/programming/comments/25j41u/adblock_pluss_effect_on_firefoxs_memory_usage/) about ad blocking extensions exactly like Adblock Plus.  The article came with somewhat surprising news.  It turns out that blocking ads in the browser is a demanding process.  It uses a bit of CPU power but in particular, it uses a lot of RAM and slows down page load times.  This was something I had never really bothered to think about or consider before.  Blocking ads seems like it would do nothing but help one's browser performance.

This news came to me around a time where my browser usage was becoming more and more intensive.  With Google making Chrome more and more into its own self-sufficient ecosystem of applications and dynamic content, I had fewer reasons to have regular applications open and more reasons to have many tabs open.  It was (and still is) not uncommon for me to have over 10 tabs open when I am browsing the internet.  Between Gmail, Google Music, sometimes Facebook, a few Reddit tabs, and maybe a YouTube tab, I found that I was frequently devoting over 2 gigabytes of RAM to Google Chrome alone.  Google Chrome had become sluggish, no longer operating at the high speed Google always claimed it was king of.

## The hosts file

Enter the hosts file.  Well, *reenter* the hosts file.  Originally implemented in the 1970s, the hosts file was used by operating systems to map hostnames (such as google.com) to IP addresses (such as 74.125.224.72).  The hosts file was used to navigate [ARPANET](http://en.wikipedia.org/wiki/ARPANET), a precursor to the Internet.  Users would either need to create and update, or get their hands on a copy of an updated hosts file to actively be able to browse ARPANET via domain names. In 1984, a system which replaced the need for a manually updated hosts file was released.  It was called the Domain Name System, which we typically refer to today as just DNS.

But the hosts file was here to stay, and had become a key part of virtually every operating system with any sort of networking capability.  It gave the user the ability to locally map any hostname to any IP address.  Here is an example of what most default hosts files will look like (this one taken from Arch Linux):

``` bash
#
# /etc/hosts: static lookup table for host names
#

#<ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	localhost.localdomain	localhost
::1		localhost.localdomain	localhost

# End of file
```


Any line that starts with # is a comment, and does nothing when the file is actually parsed by the computer.  At the start of every other line we have an IP address, and at the end we have a hostname.  We can see that the file's role in its current state is to map the "localhost" hostname to the default loopback IP (127.0.0.1 or 0.0.0.0 in IPv4 and ::1 in IPv6) so that anytime we enter "localhost" in our browser address bar (or anytime any application uses it as a hostname), the computer will connect to itself.  This shortcut is often used by anyone who does any sort of web development or other network application work.

The hosts file above also demonstrates another capability which we can take advantage of.  We can, in effect, block connections from any website if we route the site's hostname to 127.0.0.1 using the hosts file, as the contents of the hosts file takes precedent over any DNS mappings we receive from the internet.  So if we add a line such as this:

``` bash
127.0.0.1 reddit.com
```

we tell our computer to take us to 127.0.0.1 instead of reddit's normal IP address everytime we enter reddit.com in our browser.  So, by redirecting all traffic that would otherwise go to reddit.com to ourselves, reddit becomes unreachable.  All we need now is a list of ad serving domains that we want to block and the hosts file serves the exact same purpose as Adblock.  The difference being that the hosts file uses no RAM and no CPU.  It does not slow down any browser, and it completely eliminates connections to any domain listed in it.  So the hosts file affects Firefox, Chrome, and any other browser and application we may be using.

Fortunately, there are kind people on the internet that have compile pre-existing hosts files filled with thousands of malicious and ad-serving domains.  The first site I found is [http://winhelp2002.mvps.org/hosts.htm](http://winhelp2002.mvps.org/hosts.htm), which includes not only a hosts file in both .zip and .txt form, but a great explanation of how the hosts file works and various types of domains to block.  The second is [http://someonewhocares.org/hosts/](http://someonewhocares.org/hosts/), which also offers a great description as well as instructions of how to update the hosts file on your PC.

## Time for some automation

I would like to take it a step further and write a short bash script to automatically update our hosts file using the hosts files provided by both of these sites.  This will be written to work on Linux, but should probably work on OSX as well.  Ideally, every time we run the script we want to grab the most updated versions of each site's hosts file, so we have the most up-to-date version of a list of malicious and ad-serving domains.

So, the algorithm we want to perform will be something like this:

1. Make a copy of our original hosts file as a backup (**only** if this is our first time running the script)
2. Download the pre-loaded hosts file from mvps.org
3. Append (**not** overwrite) it to our existing hosts file
4. Download the pre-loaded hosts file from someonewhocares.org
5. Append (**not** overwrite) it to our hosts file
6. Delete the files we downloaded from both sites, as we do not need them anymore

In addition to this, if we run our script a second time or any additional time, instead of making a copy of the current hosts file, we want to overwrite our primary hosts file with the copy we took we ran the first time.  This is so that we are starting with a clean hosts file every time we run the script, and not adding tens of thousands of redundant lines.

After a little bit of experimenting, the script is as follows:

``` bash
#!/bin/bash

echo "Checking if copy of original hosts file exists..."
if [ -e /etc/hosts-original ]
	then
		echo "Copy of original exists."
		cat /etc/hosts-original > /etc/hosts	
	else
		echo "Copy of original does not exist.  Copying..."
		cat /etc/hosts > /etc/hosts-original
fi

echo "Downloading mvps.org hosts file..."
wget http://winhelp2002.mvps.org/hosts.txt --output-document=hosts-mvps

echo "Downloading someonewhocares.org hosts file..."
wget http://someonewhocares.org/hosts/zero/hosts --output-document=hosts-swc

echo "Adding mvps.org hosts file content to main hosts file..."
cat hosts-mvps >> /etc/hosts
echo "Adding someonewhocares.org hosts file content to main hosts file..."
cat hosts-swc >> /etc/hosts

echo "Cleaning up..."
rm hosts-mvps
rm hosts-swc

echo "Completed!"
```

You can view and download the same file on [GitHub](https://github.com/charukiewicz/scripts/blob/master/hosts-update.sh).  I encourage you to open it in a text editor after downloading it to confirm it is exactly what I have in the box above.  You will need to run the script with root permissions by prefixing with the **sudo** command because the entire **/etc/** directory is read only.

If you are a new Linux user (or an old, forgetful, Linux user) attempting to run this script for the first time, open a terminal and type the following commands:


```
cd ~/Downloads
sudo sh hosts-update.sh
```

The first line will change to the Downloads directory of your home folder.  The second line will actually execute the script.  The first line is not necessary if you know what you are doing and/or have moved the script to a different directory.  You will be prompted to enter your UNIX password to give yourself the root privileges mentioned above.

Windows users, unfortunately you will have to do this process manually.  You will need to download the contents of both hosts files and open up the one on your computer in a text editor, and then paste both inside.  Once again, **do not overwrite the original hosts file content**.  Also, do not open long files in regular Notepad.  It will crash.  Use [Sublime](http://www.sublimetext.com/) or [Notepad++](http://notepad-plus-plus.org/).  Detailed instructions on how to update the Windows hosts file are on both of the hosts file sites I linked above.

Android users, if you have rooted your phone you have an option like this as well.  There is an app on F-Droid called [AdAway](https://f-droid.org/repository/browse/?fdid=org.adaway), which does exactly what we did here.  Installing the app and giving it root permissions will then automatically update your **/system/etc/hosts** file with its own proprietary list of ad-serving domains.

ChromeOS users, unfortunately there are no good options for ChromeOS.  First of all, editing the file even using sudo does not work.  There is a workaround method, however every time ChromeOS updates the hosts file will be reset.

With that, enjoy your Adblock alternative that takes absolutely zero system resources.  You will see empty boxes where ads would be on certain websites, or the ads should just be gone all together.  Feel free to contact me with any questions. [\@charukiewicz](https://www.twitter.com/charukiewicz/)

<a name="update"></a>

<i>**Update (Feb, 15, 2016)**: There has been a lot of material that has either come out or I have read about since writing this article.  Namely, there are a few really good scripts out there that do what my bash script does, but are more feature filled.  They pull from more sources, allow you to include your own whitelist, etc.

A few options worth checking out:

  * [hosts](https://github.com/StevenBlack/hosts) - A hosts file and updater script written in Python
  * [Hostsblock](https://gaenserich.github.io/hostsblock/) - Another feature-filled utility
  * [Pi-hole](http://pi-hole.net/) - Set up a Raspberry Pi to filter your LAN 
  * [Adblock via /etc/hosts](https://www.reddit.com/r/linux/comments/45e27d/adblock_via_etchosts/) - reddit discussion on this topic

</i>
