---
title: Keeping a Web Application Fast with AWS and Ansible
disqus: yes
thumbnail_image: https://sandbox.charukiewi.cz/charukiewicz/_site/images/sisyphus-thumbnail.png
thumbnail_description: Amazon Web Services and Ansible make rapidly scaling up or down in order to meet web traffic demands easy and inexpensive.
date: 2016-08-21
---

<img src="/images/sisyphus-embedded2.png" alt="Sisyphus rolling a stone up a hill" title="'One must imagine Sisyphus happy.' —Albert Camus, The Myth of Sisyphus, 1942">

I work at a company called [Roompact](https://roompact.com).  We make a software platform to university housing departments across the country.  Our web application provides several pieces of functionality that range from reporting features, to message broadcasting, to a central news feed that acts as both a communication tool and data aggregator.  As a company, perhaps the single most important responsibility we have is ensuring that our users can rest assured that our software will be available whenever they need it.

One of the biggest technical challenges that we face in regards to maximizing uptime is in the huge disparity in server loads between the middle of each semester and the relatively short periods of time where unusually large numbers of users use some of the more technically intensive features in our application.  The beginnings and ends of each school year are punctuated by these spikes.  In order to meet these demands, we take advantage of the flexibility of Amazon Web Services combined with the power of Ansible and scale up or down as our needs change.

## Infrastructure Changes

At the beginning of this year, we made the decision to switch from Rackspace to Amazon Web Services.  There were two primary reasons as to why:

1) Massive cost savings.  After mapping out our entire infrastructure using the [AWS Monthly Calculator](https://calculator.s3.amazonaws.com/index.html), my estimates suggested that servers that were on average slightly *more powerful* than those we had at Rackspace would cost us **70% less** on AWS.  Months into the switch, this estimate proves to be correct.
2) Features, flexibility, and documentation.  AWS provides numerous tools and services that I knew would come to play key roles in our application or the infrastructure surrounding it.  Moreover, AWS has more consistent and better documentation, pricing information, and (due to its larger user base) more tutorials and how-tos written about each piece of functionality it offers.  I have found that easily available and consistent documentation is key in effectively utilizing the various tools and services.

A challenge in transitioning our entire infrastructure to AWS was that nobody at our company had actully set it up.  The original production infrastructure was set up in 2014 (shortly before Roompact launched) by Rackspace engineers, a feature of their 'Managed Hosting' service.  This was great at the time, as it allowed for focus on building the application, but this created an extra workload in moving everything to AWS now, years later.

One option in moving everything would be to replicate the entire infrastructure by hand.  That is, SSH into each server, install and configure everything, and then move on to the next one.  With over half a dozen servers, this approach would be somewhat time consuming, error prone, and would have to be repeated each time we wanted to add another server or if we ever opted to move away from AWS entirely.

## Repeatable Server Builds

<div class="body-img">
<img src="/images/build-server-button-sm2.png" alt="Build Server Button" title="I'm sure that if this existed, it would make running provisioning tools just that much more satisfying.">
</div>

I began looking for a way to automate this setup.  Examining server provisioning tools like Chef, Puppet, Saltstack, and even the AWS equivalent called CloudFormation, I decided that these were complex beyond our needs for the foreseeable future.  Instead, I chose to go with [Ansible](https://www.ansible.com/), a rather simple provisioning tool with easily digestible documentation and a reasonable learning curve.  Certain features of Ansible stuck out at me as very appealing:

* Easily readable, YAML based "playbooks". These are effectively scripts and are what actually gets read by Ansible during the provisioning process.  They differ from something like bash scripts in that they are idempotent.  Ansible is smart about checking whether something is already installed or configured before making any changes; running the same playbook numerous will not cause damage.
* Agentless architecture.  There is no need to install anything on target servers.  Everything is done over SSH via user supplied credentials.
* Ease of use.  Creating a server, removing a server, or even recreating our entire infrastructure on another hosting provider requires updating a few IP addresses in a "hosts" file and re-running the correct playbook.  In the event of a total infrastructure rebuild, a 'master' playbook could be used to invoke all of the others automatically and in the correct order.
* Portability and repeatability.  By configuring an entire server through a playbook, there is no room for mistakes or forgetting steps.  Playbooks can also be committed into version control as well as stored and shared on a system like GitHub.

After choosing Ansible as our provisioning tool, writing and testing the playbooks that recreated our entire infrastructure took about two weeks.  In the end, everything came out exactly as I had hoped.  There were even a few positive side benefits, such as making slight modifications to our master playbook that would install everything on a single server instance—great for quickly making inexpensive development severs for each of our engineers.

## Preparing for a Traffic Surge

Just a few weeks after completing these changes, we received notice from one of our largest clients that they would be going through one of their end-of-the-school-year processes over a span of two days in late April.  What this meant was that between residents and staff, we would need to handle over 10,000 users across two days.

Without any context, this number may not seem so significant.  However, the particular feature that was going to be used most extensively during this timeframe was one of the most query and iteration-heavy features in our application.  This was the first time that we would ever have such a high demand in such a short span of time, but also the first time that we were properly equipped to handle it.

Our server architecture up to this point included:

* Several Nginx + PHP web servers running the main application
* An Nginx + Node.js web server for websockets
* A pair of MySQL database servers in a master/slave configuration
* Redis servers for caching, low latency data access, and pub/sub
* A low-spec Ansible server for scripts, templates, and provisioning

<div class="body-img">
<img src="/images/ansible-flowchart-sm3.png" alt="Server Diagram" title="In reality it should look more like a spiderweb than a star.">
</div>

## Vertical Scaling: Database Servers

My scaling strategy in this situation was to focus first and foremost on the database servers.  Due to the nature of our database configuration where all write queries are sent to the master database and all read queries are sent to the slave database, I opted to scale each of the two servers vertically (increasing the power of each server) rather than horizontally (creating additional servers).  Horizontal scaling of the slave server is relatively easy, doing so would involve adding additional slaves and an internal load balancer to share read queries between them.  However, doing the same for the master server would not be so trivial; at a minimum, this would require a fair amount of configuration changes beyond just creating another server and cloning the data.

<div class="body-img">
<img src="/images/db-scale-up-sm2.png" alt="Scaling databases" title="It's easy to see how after a certain height, it just makes more sense to add another stack.">
</div>

The downside of vertical scaling is that it requires a server restart.  However, with only about 2 minutes of downtime, the two database servers were upgraded, quadrupling the number of CPU cores and RAM on each server.  Doing this is something that AWS makes extraordinarily easy.  The decision to scale this much was one based off of experience with previous heavy demand scenarios; I was confident that a 4x increase in power on each server would be sufficient to handle the incoming wave of users.

## Horizontal Scaling: Web Servers

![](/images/ga-spike-nrw2.png)
