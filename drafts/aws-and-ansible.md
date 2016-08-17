---
title: Building and Maintaining a Robust Technical Infrastructure with AWS and Ansible
disqus: yes
thumbnail_image: https://sandbox.charukiewi.cz/charukiewicz/_site/images/sisyphus-thumbnail.png
thumbnail_description: Amazon Web Services and Ansible make rapidly scaling up or down in order to meet web traffic demands easy and inexpensive.
date: 2016-05-30
---

<img src="/images/sisyphus-embedded2.png" alt="Sisyphus rolling a stone up a hill" title="'One must imagine Sisyphus happy.' —Albert Camus, The Myth of Sisyphus, 1942">

The school year is cyclical.  At the beginning of each Fall semester, educators prepare for the incoming nine-to-ten months of work ahead of them.  A lot of time and effort goes into planning, training staff, and finalizing curricula, among many other tasks.  Then, at the end of each Spring semester, what might be a similar amount of work goes into the conclusion of the academic year, always with knowledge that the beginning of the next is a few months away.  A Sisyphean task.

At universities across the United States, residence life professionals and student staff engage in the task of managing residence halls.  They follow a similar cycle in the overseeing and education of what will usually be thousands of new and returning students that will live in residence halls for the duration of each year.  A growing number of institutions rely on [Roompact](https://roompact.com/) to help with this enterprise.

## Technical Challenges

As a company, perhaps the single most important responsibility we have at Roompact is ensuring that our users can rest assured that our software will be available whenever they need it.

<!-- NO INCLUDE And when they need it most is at the aforementioned beginnings and ends of every school year, when entire bodies of students are either moving in or moving out, often all in a span of a day or two.  The move in and move out processes are without a doubt the most technically onerous components of our application, with huge numbers of database reads and writes, and exigent amounts of computation that must happen at each web server. -->

One of the biggest technical challenges that we face in regards to maximizing uptime is in the huge disparity in server loads between the middle of each semester or the summer season, and the relatively short periods of time where unusually large numbers of users invoke these extremely technically intensive processes.  The beginning and end of each school year is punctuated by these spikes.  In order to meet these demands, we take advantage of the flexibility of Amazon Web Services combined with the power of Ansible and scale up or down as our needs change.

## Infrastructure Changes

At the beginning of this year, we made the decision to switch from Rackspace to Amazon Web Services.  There were two primary reasons as to why:

1) Massive cost savings.  After mapping out our entire infrastructure using the [AWS Monthly Calculator](https://calculator.s3.amazonaws.com/index.html), my estimates suggested that servers that were on average slightly *more powerful* than those we had at Rackspace would cost us **70% less** on AWS.  Months into the switch, this estimate proves to be correct.
2) Features, flexibility, and documentation.  AWS provides numerous tools and services that I knew would come to play key roles in our application or the infrastructure surrounding it.  Moreover, AWS has more consistent and better documentation, pricing information, and (due to its larger user base) more tutorials and how-tos written about each piece of functionality it offers.  I have found that easily available and consistent documentation is key in effectively utilizing the various tools and services.

A challenge in transitioning our entire infrastructure to AWS was that nobody at our company had actully set it up.  The original production infrastructure was set up in 2014 (shortly before Roompact launched) by Rackspace engineers.  This was great at the time, as it allowed us to focus on building the application, but this created an extra workload in moving everything to AWS.

One option in moving everything would be to replicate the entire infrastructure by hand.  That is, SSH into each server, install and configure everything, and then move on to the next one.  With over half a dozen servers, this approach would be somewhat time consuming, very mistake prone, and would have to be repeated each time we wanted to add another server or if we ever opted to move away from AWS entirely.

## Repeatable Server Builds

<div class="body-img">
<img src="/images/build-server-button-sm2.png" alt="Build Server Button" title="I'm sure that if this existed, it would make running provisioning tools just that much more satisfying.">
</div>

I began looking for a way to automate this setup.  Examining server provisioning tools like Chef, Puppet, Saltstack, and even the AWS equivalent called CloudFormation, I decided that these were complex beyond our needs for the foreseeable future.  Instead, I chose to go with [Ansible](https://www.ansible.com/), a rather simple provisioning tool with easily digestible documentation and a reasonable learning curve.  Certain features of Ansible stuck out at me as very appealing:

* Easily readable, YAML based "playbooks". These are effectively scripts and are what actually gets read by Ansible during the provisioning process.  They differ from something like bash scripts in that they are idempotent.  Ansible is smart about checking whether something is already installed or configured before making any changes; running the same playbook numerous will not cause damage.
* Agentless architecture.  There is no need to install anything on target servers.  Everything is done over SSH via user supplied credentials.
* Ease of use.  Creating a server, removing a server, or even recreating our entire infrastructure on another hosting provider requires updating a few IP addresses in a "hosts" file and re-running the master playbook.
* Portability and repeatability.  By configuring an entire server through a playbook, there is no room for mistakes or forgetting steps.  Playbooks can also be committed into version control as well as stored and shared on a system like GitHub.

After choosing Ansible as our provisioning tool, the writing and testing the playbooks that recreated our entire infrastructure took about two weeks.  In the end, everything came out exactly as I had hoped.  There were even a few positive side benefits, such as making slight modifications to our master playbook that would install everything on a single server instance—great for quickly making inexpensive dev severs for each of our developers.

## Preparing for a Traffic Surge

Just a few weeks after completing these changes, we received notice from one of our largest clients that they would be going through their own checkout process over a span of two days in late April.  What this meant was that between residents and staff, we would need to handle nearly 10,000 users across two days (and since all of these users would be in the same timezone, this really meant two eight-hour periods).  This, of course, would be in addition to all of our regular traffic.  This was the first time that we would ever have such a high demand in such a short span of time, but also the first time that we were properly equipped to handle it.

Our setup up to this point has been eight servers:

* 2 Nginx + PHP web servers running the main application
* 1 Nginx + Node.js web server for websockets
* 2 MySQL database servers in a master/slave configuration
* 2 Redis servers for caching, low latency data access, and pub/sub
* 1 Ansible server for scripts, templates, and provisioning

<div class="body-img">
<img src="/images/ansible-flowchart-sm3.png" alt="Server Diagram" title="In reality it should look more like a spiderweb than a star.">
</div>

My scaling strategy in this situation was to focus first and foremost on the two database servers.  Due to the nature of our database configuration where all write queries are sent to the master database and all read queries are sent to the slave database, I opted to scale each of the two servers vertically (increasing the power of each server) rather than horizontally (creating additional servers).  Horizontal scaling of the slave server is relatively easy (doing so would involve adding additional slaves and an internal load balancer to share read queries between them), but doing the same for the master server is not so trivial; special care is required to maintain the [ACID properties](https://en.wikipedia.org/wiki/ACID) of the database.

<div class="body-img">
<img src="/images/db-scale-up-sm2.png" alt="Scaling databases" title="It's easy to see how after a certain height, it just makes more sense to add another stack.">
</div>

The only downside of this vertical scaling is that it requires a server restart.  However, with only about 2 minutes of downtime, the two database servers were upgraded in a way that quadrupled the number of CPU cores and RAM on each server.  The decision to scale this much was one based off of experience with previous heavy demand scenarios; I was confident that a 4x increase in power on each server would be sufficient to handle the incoming wave of users.

![](/images/ga-spike-nrw2.png)
