---
title: Let's Encrypt With Let's Encrypt
---

## What is website encryption?

As of today the pages on this site are being served up over SSL.  This means that the sever this site is hosted on is encrypting each webpage before it serves it to your browser.  Encryption makes the data unreadable to third parties, and also ensures that the data that you see has not been tampered with.

An encrypted website can be identified by the **https://** as opposed to the **http://** at the beginning of the address bar, and a (usually green) lock icon just to the left of the actual address text.  The state of the lock icon also serves to warn against possible faults in the encryption.  In Google Chrome, a red lock icon and ~~**https**~~ being stricken out indicates a serious fault in the SSL on the site (either the encryption is broken or the identity of the host has not been verified).  An orange lock icon is less severe, and typically indicates that domain may be encrypted but some of the elements on the page are not.

As a rule of thumb, if the connection is not in the "green" status, you should never enter sensitive data (credit card numbers, SSNs, personal info) anywhere on the site.  Other browsers such as Firefox may not adhere to this same color system for indicating whether SSL is working on a site, but you can always click the lock icon for more information about the encryption status.  This should be true for all browsers on all operating systems.

## How is this site encrypted?

Quite a while ago, an organization called [Let's Encrypt](https://letsencrypt.org/) was created to serve as a new certificate authority.  A certificate authority serves as a trusted, unbiased organization that independently verifies the authenticity of servers that want to serve encrypted web content to a browser.

Before Let's Encrypt, a website owner had to pay money to a certificate authority like DigiCert, Comodo, or Symantec in order to get an SSL certificate.  Prices of SSL certificates from these authorities are in my opinion very expensive.  The cheapest one I can see is a single domain certificate from Comodo for $76 per year, ranging all the way up to a wildcard certificate (covering all of a website's subdomains) from Symantec for a whopping $1,999 per year!  For a website like this one, paying over $6 a month just to serve my visitors lightly styled HTML pages over SSL is a waste of money.

But this is where Let's Encrypt comes back into the picture.  Let's Encrypt is a free service that is the product of a collaboration between organizations like [Mozilla, Akami, Cisco, and the EFF](https://letsencrypt.org/sponsors/) that aims to bring free SSL certificates to the entire internet.  What's more is that Let's Encrypt is a totally automated service, not requiring any human intervention on behalf of the certificate authority to issue a certificate for a particular host.

A couple weeks ago, I signed up to request an invite to the Let's Encrypt beta program.  The opportunity to serve my site over SSL without having to pay a ton of money (in this case, for nothing other than a bit of my time) was a good prospect to me.  I did not hesitate to submit this site to participate in the beta program.  Today, I got an invite.

## Encryption Steps

I will not go into much detail into how the actual SSL setup process, because there really was not much to it.  Anyone with a moderate amount of Linux experience should be able to follow the instructions and complete the process within 20 minutes.  The email I received inviting me to the beta program contained most of the instructions for setting up SSL.  In short, the steps were like this:

1. Clone the `letsencrypt` client (a command line tool written in Python) from the Let's Encrypt GitHub repo
2. `cd` into the cloned repo and run a script with `./letsencrypt` and a few option flags (provided in the email)
3. Follow the wizard and select the domain that is to be served over SSL (based off of available Apache/Nginx configurations)
4. Add a [redirect from HTTP to HTTPS](http://serverfault.com/a/570290/256141) in my `/etc/apache2/sites-enabled/` configuration file for this domain
5. Ensure that none of the assets (like Disqus comments) on my site are being served over HTTP (to avoid the "orange lock" warning mentioned earlier)

## Why Encrypt?

The lingering question here is quite simple: Why bother encrypting?  This is just a blog website that has a relatively small amount of content.  The most sensitive piece of information here is probably my email address, and the biggest risk associated with that is my inbox getting hit with spam.  It is not like encryption is doing anything to mitigate that either.  It would appear as though me taking any time at all to encrypt this site is utterly pointless.

But I believe that there is a reason.  I am a proponent of encryption becoming a *de facto* standard for how we share data over the internet.  Encrypted data should not just be the content your bank website sends you when you check your account balance.  Nor should it be just your payment gateway connection when you click "Checkout with PayPal" on a store's site.  I believe that **everything** should be encrypted, all of the time.  That means all communication, all transactions, all entertainment, and all information access in general.

When encryption is the standard, the discrepancy between important encrypted data (like your medical records on your hospital's website) and unimportant data (like this blog post) vanishes.  By encrypting everything, important encrypted content becomes obscured by all of the unimportant encrypted content.  This makes it very difficult for a malicious entity to target important encrypted data.  An attacker may waste time and money attempting to decrypt data exchanged between your computer and some server, only to find that the data is a [sad pepe meme](http://i.imgur.com/VUd7QZe.jpg), for example.

The other component of my belief for encrypting everything is simply from a privacy standpoint.  I believe that nobody should have the ability to track what you do on the internet, and making encryption a standard is perhaps the most important thing we can do to protect against that.  This is particularly important for protecting people who are not tech savvy, and who are most likely to have their information compromised or make dangerous decisions on the internet.

Fortunately, this belief is not novel.  Companies like Google and Apple are moving rapidly towards an [encryption by default](https://nakedsecurity.sophos.com/2015/10/21/new-android-marshmallow-devices-must-have-default-encryption-google-says/) standard.  Brucer Schneier also made [a good post](https://www.schneier.com/blog/archives/2015/06/why_we_encrypt.html) about the importance of encrypting everything.  And as of next month, Let's Encrypt will go public and anyone will be able to use the service to serve encrypted versions of their own website.

The bottom line is that while the decision to encrypt my website looked at in isolation seems pointless, looking at it as part of growing standard of encrypting everything paints a very different picture.
