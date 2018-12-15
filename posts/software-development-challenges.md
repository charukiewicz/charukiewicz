---
title: Five Major Challenges In Building Software
disqus: yes
thumbnail_description: A discussion of five key difficulties that every software developer faces.
thumbnail_image: https://s3.amazonaws.com/charukiewicz/assets/images/sisyphus-thumbnail.png
date: 2017-06-10
---

<div style="margin-bottom:50px;">
<img alt="Hand-drawn picture of Sisyphus pushing a stone up a hill by Christian Charukiewicz" src="https://s3.amazonaws.com/charukiewicz/assets/images/sisyphus-embedded-crop.png">
</div>


Software in an omnipresent aspect in the world of today. The vast majority of people today have a continuous interaction with software. Nearly every moment of every day for most is in some way reliant on code somebody has written. For this large majority of people, software is a *sine qua non*.
 
But the minority of people who create software that sees use by others know that building it is remarkably difficult. Making it comes with obstacles that are unique to it. In this post I will describe a few of these defining challenges.


## 1. Seemingly insignificant details are often crucial

In software, what seems inconsequential will often be just the opposite. Perhaps the most famous example of this is that of the Ariane 5 rocket, whose 1996 maiden flight resulted in it veering off course and exploding less than a minute after takeoff. The cause of this issue was an [improper conversion of a floating point number to an integer somewhere in the rocket's guidance software](https://en.wikipedia.org/wiki/Cluster_(spacecraft)). A single line of code that resulted in a $370 million mistake.
 
More recent issues in other industries have occurred as well. In 2012, the trading firm Knight Capital lost $440 million in 45 minutes because [someone forgot to remove an unintended block of code from one of their eight trading servers](https://en.wikipedia.org/wiki/Knight_Capital_Group#2012_stock_trading_disruption). Just a few weeks ago, in February of this year, an engineer at Amazon Web Services doing server maintenance [typed a command with a few erroneous parameters](https://aws.amazon.com/message/41926/), resulting in thousands of websites and other services going offline for several hours. Dozens of well known organizations such as Expedia, Kickstarter, and U.S. Securities and Exchange Comission were affected.
 
High profile examples such as these get people's attention, but they also serve to demonstrate that seemingly minor mistakes can and do result in critical software failures. When building software, the details matter.

<div class="body-img">
<img alt="Hand-drawn graph showing complexity increasing exponentially as number of features increases" src="https://s3.amazonaws.com/charukiewicz/assets/images/features-vs-complexity-sm2.png">
</div>

## 2. Software complexity grows exponentially

Let's play a game. I am going to give you a certain number of coins and you need to tell me how many possible arrangements of "heads" and "tails" there are. For example, if I give you one coin, there are obviously only two arrangements, one for each face of the coin. If I give you two coins, there are four possible arrangements…

<div style="padding-left:50px;">
2 coins = {HH, HT, TH, TT}
</div>

Three coins?  Let's see…

<div style="padding-left:50px;">
3 coins = {HHH, HHT, HTH, HTT, THH, THT, TTH, TTT}
</div>

That's eight possible arrangements. Now, how many coins would I have to give you for you to make at least 1,000 arrangements?  Have a guess in mind?  The answer: 10 coins. The formula for calculating this is:

<div style="padding-left:50px;">
(2 possible arrangements per coin)<sup>(10 coins)</sup> = 1,024 possible arrangements
</div>

How many coins for at least a million arrangements?  Turns out it's only 20.

<div style="padding-left:50px;">
(2 possible arrangements per coin)<sup>(20 coins)</sup> = 1,048,576 possible arrangements
</div>

Going from 10 to 20 coins is a thousand-fold increase in the number of possible arrangements. Why is this the case?  A single coin only has two possibilities, but adding it to a set of coins results in a doubling of the number of possibilities for the entire set. This is an exponential rate of increase.
 
Software complexity grows in much the same way. When creating a piece of software, making a small addition can be rather simple. But it can result in an exponential increase in complexity on the entire program. Suppose you have a settings page with five settings, each setting having two possible states. That's 32 possible configurations. Adding a sixth setting will result in 64 possible setting configurations. Each one of these configurations must be tested to ensure everything functions as intended.

This rapid growth in complexity forces developers to be careful when designing large applications. Those that are not often pay the price in the form of buggy or generally unreliable code that can be very difficult and time consuming to work with.


## 3. Creating the user interface is just as difficult as writing the rest of the code

A key component of building most software is creating its user interface. Even after all much of the issues with underlying complexity and architectural details have been addressed, making an application that is usable by people requires designing and building an interface that allows for interacting with the software.

User interfaces are software that must be built much in the same way as the rest of an application, but they have the unique requirement of being intuitive and usually visually appealing. Making them requires not only technical ability, but also knowledge of design principles, as well as an intimate understanding of the types of users that will be consuming the software. Making a health insurance website for people over the age of 50 will require a different design approach than a social media application intended to be used by college students. Both will certainly require design expertise.

User interfaces also take a very long time to make. The end user will never see the long hours that go into interating over designs, perfecting layouts, and deciding on things like color, spacing, and numerous other details that can completely change an end user's experience. Doing this requires a lot of time, regardless of how experienced a software developer is at making user interfaces.

The process of creating a user interface can be compared to drawing a portrait. Most people can recognize a well drawn portrait. But few people will be able to draw one themselves. Those that will be able to will have had years of practice, and the process will still require time and patience. Software developers that make user interfaces, even if they do it by writing code, require a similar progression of skill development that can take years to achieve mastery in.


<div class="body-img">
<img alt="Hand-drawn image of expectation being a fairly straight line and reality being a curvy, loopy line" src="https://s3.amazonaws.com/charukiewicz/assets/images/expectation-vs-reality.png">
</div>

## 4. Nobody really knows how long building something will take
 
We are going to go on a road trip from New York City to San Francisco. Let's pull out our United States road atlas and plan the route we will take. We trace a path following Interstate 80 westbound from New York to our destination. Looking at the map key, we try to estimate the distance; about 3,000 miles.
 
Assuming that we will average 75 miles per hour, we will be driving for 40 hours. That's quite a bit further than we can comfortably drive nonstop, so let's plan on spending a night in a motel somewhere in the middle of our trip. This should take about 10 hours. Let's also not forget that we will have to stop for gas several times. Assuming 6 stops of 10 minutes each, we will add an hour to our trip. So our whole trip will take 51 hours in total.
 
But in reality, we will come to discover that this estimate fails to account for numerous delays that only become known to us over the course of our trip. Starting the trip during Monday morning rush hour costs us several hours. An accident that causes traffic in Pennsylvania does the same. Our stop in a motel in Illinois ends up taking 13 hours rather than 10. We get pulled over for speeding in Nebraska. We need to stop at a mechanic shop in Wyoming because our car's oil level is far too low. We end up spending a second night in a motel, because it turns out that driving 1,500 miles per day is only feasible in theory. We get caught in rush hour traffic again in Sacramento.

So how long does our trip take?  By the time we check the time in San Francisco, we find that it has been 76 hours since we have left New York City!  Our initial estimate of 51 hours was off by nearly 50%. We did not account for numerous factors, from an extra motel stay to getting pulled over, to being stuck in traffic several times. But how could we?  Most of these only became apparent once we were driving.
 
Estimating the length of a software project is in many ways like planning our road trip. But whereas the road trip is measured in hours or days, a software project is measured in weeks or months. Even after spending several days planning a large piece of software, issues will arise over the course of development. Problems will emerge only as certain details are decided and small issues are resolved. This cycle of discovery and resolution of problems is an inherent trait of software development. This is also exactly why a component that is slated to take two weeks may end up taking five. A project planned to take 16 weeks can end up spaning 28.
 
To complicate matters further, the cause of a delay may have nothing to do with the project itself. A bug in an unrelated feature may require several hours of attention in order to fix. A completely unrelated meeting may end up taking an afternoon. Small delays over a period of months can add up to weeks. When planning a large piece of software, the best we can do is have rough guess as to how long building it will take. It is prudent to realize that any such guess is subject to change.


<div class="body-img">
<img alt="Hand-drawn image of a button with the word 'Delete' underneath it" src="https://s3.amazonaws.com/charukiewicz/assets/images/delete-button.png">
</div>

## 5. Sometimes the best solution is to delete something
 
When a physical object gets worn out and need to be discarded or replaced, the need to do so ends up being quite apparent. A bicycle tire gets worn down to its innertube, causing a flat. A computer's motherboard fails after several years, preventing it from turning on. A car's transmission blows out after it has driven 350,000 miles and it will no longer start. Even a derelict apartment building may need to be demolished as renovating it may not be economical.
 
Software is different. Software never gets worn out. A piece of code running for the first time is no different than when it runs for the billionth time. As long as the underlying hardware is functional, code can continue to run *ad infinitum*. This is where one of the major challenges of software development occurs. Sometimes the best solution is to delete something.

The need for this type of deletion of software can manifest itself in many ways. Perhaps there is an old feature that is only utilized by a small minority, yet those that do use it frequently report issues. Other times there may be a large component that sees very heavy use, yet it is poorly built and updating it to meet user requests does not make sense. In such a case, building an improved feature that will replace the old one may make sense.
 
In all cases, deletion is challenging. Users may get frustrated and annoyed. In the case of a replacement, new documentation has to be created. The time spent making the old component may seem wasted. Or in some cases, the condemned component interacts with several others, so there will be work involved in ensuring that the peripheral components continue to function without it.
 
But at the same time, the consequences for not deleting something can be worse than pruning it. The time spent on supporting an old piece of software can end up amounting to more than building an improved replacement. Slow and buggy features may drive users to give up on using a feature altogether. An old feature may be a glutton for system resources, slowing the entire application down for everybody. In such cases, the benefits of removal often outweigh the costs.



---------

*A modified version of this post originally appeared on the [Roompact On Duty Blog](https://blog.roompact.com/). [Roompact](https://roompact.com/) is residential education software for colleges and universities that allows housing and residence life programs to track their educational efforts and make their administrative work more efficient.*
