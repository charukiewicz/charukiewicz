---
title: Keeping a Web Application Fast with AWS and Ansible
disqus: yes
thumbnail_image: https://s3.amazonaws.com/charukiewicz/assets/images/sisyphus-thumbnail.png
thumbnail_description: Amazon Web Services and Ansible make rapidly scaling up or down in order to meet web traffic demands easy and inexpensive.
date: 2016-10-17
---

<img src="https://s3.amazonaws.com/charukiewicz/assets/images/sisyphus-embedded.png" alt="Sisyphus rolling a stone up a hill" title="'One must imagine Sisyphus happy.' —Albert Camus, The Myth of Sisyphus, 1942">

## Maximal Uptime and Performance

I work at a company called [Roompact](https://roompact.com).  We make a software platform used by university housing departments across the country.  Our web application provides an array of features that range from an assortment of templatable digital forms, to message broadcasting, to a central news feed that acts as both a communications tool and data aggregator.  As a company, perhaps the single most important responsibility we have is ensuring that our users can rest assured that our software will be available whenever they need it.  To me, this means not only that our website is online, but that every page and feature is functioning quickly and correctly.

One of the biggest technical challenges that we face in regards to ensuring maximal uptime and performance is in the huge disparity in server loads between the beginning, middle, and end of each school year; the beginnings and ends of each being punctuated by very large numbers of users utilizing the more technically intensive features in our application.  In order to meet these demands, we take advantage of the flexibility of Amazon Web Services combined with the power of Ansible and scale up or down as our needs change.

## Infrastructure Changes

At the beginning of this year, we made the decision to switch from Rackspace to Amazon Web Services.  There were two primary reasons as to why:

1) Massive cost savings.  After mapping out our entire infrastructure using the [AWS Monthly Calculator](https://calculator.s3.amazonaws.com/index.html), my estimates suggested that servers that were on average slightly *more powerful* than those we had at Rackspace would cost us **70% less** on AWS.  Months into the switch, this estimate proves to be correct.
2) Features, flexibility, and documentation.  AWS provides numerous tools and services that I knew would come to play key roles in our application or the infrastructure surrounding it.  Moreover, AWS has more consistent documentation, pricing information, and (due to its larger user base) more tutorials and how-tos written about each piece of functionality it offers.

A challenge in transitioning our entire infrastructure to AWS was that nobody at our company had actully set it up.  The original production infrastructure was set up in 2014 (shortly before Roompact launched) by Rackspace engineers, a feature of their 'Managed Hosting' service.  This was great at the time, as it allowed for focus on building the application, but this created an extra workload in moving everything to AWS now, years later.

One option in moving everything would be to replicate the entire infrastructure by hand.  That is, SSH into each server, install and configure everything, and then move on to the next one.  With over half a dozen servers, this approach would be somewhat time consuming, error prone, and would have to be repeated each time we wanted to add another server or if we ever opted to move away from AWS entirely.

## Repeatable Server Builds

<div class="body-img">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/build-server-button.png" alt="Build Server Button">
</div>

I began looking for a way to automate this setup.  Examining server provisioning tools like Chef, Puppet, Saltstack, and even the AWS equivalent called CloudFormation, I decided that these were complex beyond our needs for the foreseeable future.  Instead, I chose to go with [Ansible](https://www.ansible.com/), a rather simple provisioning tool with easily digestible documentation and a reasonable learning curve.  Certain features of Ansible stuck out at me as very appealing:

* Easily readable, YAML based "playbooks". These are effectively scripts that act as the instructions for Ansible during the server provisioning process.  They differ from something like bash scripts in that they are idempotent.  Ansible is smart about checking whether something is already installed or configured before making any changes; running the same playbook numerous will not cause damage (in most cases).
* Agentless architecture.  There is no need to install anything on target servers.  Everything is done over SSH via user supplied credentials.
* Ease of use.  Creating a server, removing a server, or even recreating our entire infrastructure on another hosting provider requires updating a few IP addresses in a "hosts" file and re-running the correct playbook.  In the event of a total infrastructure rebuild, a 'master' playbook could be used to invoke all of the others automatically and in the correct order.
* Portability and repeatability.  By configuring an entire server through a playbook, there is no room for mistakes or forgetting steps.  Playbooks can also be committed into version control as well as stored and shared on a service like GitHub.

Writing and testing the playbooks that recreated our entire infrastructure took about two weeks.  In the end, everything came out exactly as I had hoped.  There were even a few positive side benefits, such as making slight modifications to our master playbook that would install everything on a single server—great for quickly making inexpensive development severs for each of our engineers.

## Preparing for a Traffic Surge

Just a few weeks after completing these changes, we received notice from one of our largest clients that they would be going through one of their end-of-the-school-year processes over a span of two days.  The particular feature that was going to be used most extensively during this timeframe was one of the most query and iteration-heavy in our application.  This was the first time that we would ever have such a high demand in such a short span of time, but also the first time that we were properly equipped to handle it.

Our server architecture up to this point included:

* Several Nginx + PHP web servers running the main application
* An Nginx + Node.js web server for websockets
* A pair of MySQL database servers in a master/slave configuration
* Redis servers for caching, low latency data access, and pub/sub
* A low-spec Ansible server for playbooks, templates, and provisioning

<div class="body-img">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/ansible-flowchart.png" alt="Server Diagram">
</div>

From previous experiences, I knew that this infrastructure would not be enough to handle the extra traffic we were to be faced with.  A scaling plan had to be made and executed.

## Vertical Scaling: Database Servers

My scaling strategy in this situation was to focus first and foremost on the database servers.  Due to the nature of our database configuration where all write queries are sent to the master database and all read queries are sent to the slave database, I opted to scale each of the two servers vertically (increasing the power of each server) rather than horizontally (creating additional servers).

Horizontal scaling of the slave server is relatively easy, doing so would involve adding additional slaves and an internal load balancer to share read queries between them.  However, doing the same for the master server would not be so trivial; maintaining data consistency and ensuring proper data conflict resolution requires special tools and configuration.

<div class="body-img">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/db-scale-up.png" alt="Scaling databases" title="It's easy to see how after a certain height, it just makes more sense to add another stack.">
</div>

The downside of vertical scaling is that it requires a server restart.  However, with only about 2 minutes of downtime, the two database servers were upgraded, quadrupling the number of CPU cores and RAM on each server.  Doing this is something that AWS makes extraordinarily easy.  The decision to scale this much was one based off of experience with previous heavy demand scenarios; I was confident that a 4x increase in power on each server would be sufficient to handle the incoming wave of users.

## Horizontal Scaling: Web Servers

A very different strategy could be applied to our web servers.  Since traffic is distributed between the web servers automatically via our Elastic Load Balancer, and there is no interaction at all during runtime between the web servers (each request is isolated to whichever server it gets routed to), additional web servers can be added without issue.

This horizontal scaling does require ensuring that changes are made in all the necessary places when a server is added.  In our case, after using Ansible to create a new web server, it was also necessary to adjust the appropriate AWS Security Group (a feature similar to a firewall) to allow the new web servers to connect to the database and cache servers, as well as chance the rsync configuration on the master web server to copy any code deployed in the future to the new web servers.

After some consideration as well as some practice of the above configuration steps, I made the decision to not add any web servers initially.  Since adding more web servers can be done without any downtime, and the process itself is so quick with Ansible (taking only a minute or two), I felt confident knowing that I would be able to add more servers if necessary.  I would be monitoring traffic on those days, and would be able to respond the moment I started seeing spikes or getting high CPU usage alerts.

## Weathering the Traffic Surge

I imagine that the feeling of knowing the application you have built and are responsible for will experience a massive traffic spike on a particular day is not unlike what a medieval lord may have felt knowing that a siege on their castle was impending.  As a young company, there is a lot at stake in a situation where your core product will be tested to its limits.  At the same time, as a young company, your ability to draw on previous experiences and past data to guide decisions will be limited.

Going into the first day of the our client's close out process I felt confident, albeit not certain, that the steps I took in preparation of this moment would be sufficient.  Although they were planned carefully, ultimately the decisions of how much to scale our hardware were more educated guesses than the product of exact calculations.  And just like fortifying your castle walls in the middle of a siege is a bad idea, taking our database offline during record breaking traffic levels was not going to be a good option either.

![](https://s3.amazonaws.com/charukiewicz/assets/images/ga-spike-nrw.png)

### Day One

Monitoring server loads during the first day of the surge was uneventful, but revealed that scaling the databases was absolutely necessary.  The two MySQL servers were definitely benefiting from the extra CPU cores.  The web servers were faring well without any scaling, but each was handling a substantial number of requests.  As the day came to a close, we noticed that only approximately 25% of our users at the given school had completed the close out process.  This meant that the majority was yet to come.

### Day Two

The second day started much like the first, although I was quite cognizant of the fact that we would be getting up to three times as much traffic as we had the previous day.  As noon approached, it was evident that we were going to run into trouble.  Each of our web servers was moving towards 90% CPU.
