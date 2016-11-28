---
title: Three Elements of an Effective Software Development Team
disqus: yes
thumbnail_image: https://s3.amazonaws.com/charukiewicz/assets/images/laptop-sm-thumb.png
thumbnail_description: Christian, the CTO at Roompact, shares some of the guiding principles behind how the Roompact development team excels.
date: 2016-11-28
---

<img src="https://s3.amazonaws.com/charukiewicz/assets/images/laptop-sm-color.png">

Between the months of August and October of 2014, [Roompact](https://roompact.com/) served 35,000 pages to users. Over the same period of time in 2016, Roompact served well over one million pages.  Roompact users today visit more often, navigate to more pages, and spend significantly more time on the site than ever before.  These increases are the result of more features, better performance, and improved usability.  Roompact today is the most polished and functional version of the software to date.

<div class="body-img">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/usage-sm-color-2.png" style="width:300px !important;">
</div>

In this post, I am going to share a few of the key elements that make our small software development team effective and enable the type of growth mentioned above.  I will discuss our drive to innovate, our emphasis on learning and education, and the essential tools and techniques of our software development methodology.

## Innovation

Perhaps the most fundamental aspect of our software development team is our drive to innovate.  We continuously seek out new techniques, strive for a more performant and better organized architecture, and develop more effective ways to write clean and reusable code.  These measures ultimately help us build features that have fewer bugs, take less time to build, and provide a better user experience.

One specific example of the application of such innovation is in the design of our user interfaces.  Newer features are created with painstaking effort to ensure their interfaces are clean and intuitive while giving users the ability to perform their intended actions as easily as possible.

The design of our new features begins with planning a page layout.  Here, we must determine the overall structure of the page—making decisions about where components such as user inputs and relevant data will be.  This may involve asking ourselves questions like:

* Should this input be a dropdown or a search bar?
* Should the data be presented as a list or a more interactive table?
* Which pieces of data are relevant to someone who will be using this feature?

Once a layout is determined, we make use of things like animation, color, and icons to provide visual cues to the user about where to click, where to focus their attention, and feedback as to whether an action is completed successfully or not.  This entire process of developing a layout and then adding styling and animation can be iterated over several times before a design is deemed suitable for the final product.

The results of this extra effort are evident.  Our newest features are very heavily used, yet they receive the smallest number of related support requests.  Even more affirming is the positive feedback we hear, particularly when it speaks to their ease of use:

<blockquote>
<p>Shout out to the roompact! I set aside two hours to figure out microsurveys. It took five minutes. And it looks AWESOME. So excited for this new feature. Thanks for making such a useful tool that is so easy to use!</p>
<p>— [Johnna M.](https://www.facebook.com/roompact/posts/1267808656584118)</p>
</blockquote>

Another more technical example of our innovation is in the front end architecture of our newest features.  Every major feature we have released this year has been what can be referred to as a "single page application" (SPA).  What this means is that once a user arrives at one of these features, either through sidebar navigation or via direct link, their browser will download all of the data necessary to perform every function of the feature.

Although this early loading of the data may seem unnecessary, the result is a better user experience.  For example, when searching for users to tag in a dynamic form field, the search results in an SPA will always appear instantaneously, regardless of whether the search is being performed at an institution with a few hundred or several thousand users.

This new approach differs significantly from the one utilized in our older features, where each search query was sent to the server and then used to perform a database lookup.  This often resulted in noticeable delay between search input and results display, and would be most apparent when the list of results was very long.

<div class="body-img">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/speedo-sm-padded.png" style="width:500px !important;">
</div>

Other benefits of an SPA, such as smoother and faster "page" navigation (SPAs can give the illusion of having multiple pages), lead to a better experience as well.

## Education

Another major aspect of the success of our development team is a focus on education.  Software development requires substantial breadth and depth of knowledge spanning many distinct skill sets.  And while everyone on our development team has an academic background in Computer Science, this is not sufficient.  Although there is no better background for software engineering than a degree in Computer Science, most curriculums cover only a small portion of the skills required for even rudimentary software development.  Continuing to learn after graduation is a necessity.

Our emphasis on learning begins immediately.  Each new team member is given small tasks that will build their skills as a productive software engineer.  As time goes on, larger projects require a composition of the skills that are learned early on.  Even interns begin working independently within a few days of starting their internships.  There is no better way to learn software development than to be actively engaged in it.

<blockquote>
<p>Within the first three weeks of my internship with Roompact, I was able to learn more than I have ever learned in an entire year of schooling.</p>
<p>— [Artur S.](https://blog.roompact.com/2016/09/21/reflections-from-artur-sak-one-of-roompacts-2016-summer-interns/)</p>
</blockquote>

One other component of education that goes beyond building knowledge is developing understanding.  Everyone on the development team is challenged to not only learn *how* to build software, but to also understand *why* it is built the way it is.  This may range from understanding why a single line of code works the way it does, to why it is better to use one database schema over another, to why architectural decisions that initially seem appropriate may be problematic in the long run.

Building an understanding of *why* involves asking questions and critical thinking.  Everyone on our development team is encouraged to scrutinize their own work.  This may involve asking questions like: "Why is this solution the best one?" or "Will this cause any problems when we scale this feature?"  Other times this will involve taking the time to explain a topic in detail, often beyond what is necessary for the task at hand.  Through questioning and examination, everyone learns not only the *hows*, but also the *whys* of building software.

This understanding of *why* is vital for long term growth as a software engineer.  Understanding *why* transcends individual projects and programming languages.  The piece of software being worked on may be different, or the syntax of the code might be new, but the fundamental principles seldom change.  Knowledge of *why* is also the essence of the distinction between familiarity and expertise in a given topic.

## Methodology

A third key aspect of the success of our development team is is our methodology.  This ranges from the tools we use to help us stay organized, to the process our code goes through before it reaches our production servers.

One of the most important tools we use while building software is called "version control."  Version control allows us to keep track of every single change ever made in our code in a central repository.  Should a feature break, or should we simply need to refer to how something was written previously, version control allows us to browse our entire project history.

Another feature of our version control system that is absolutely crucial to effective software development is called "branching."  This allows each engineer to create their own "branch" in the code repository, which they can then use to build new features without interfering with other developers.  More importantly, branching allows us to build features and make changes without breaking the production website.  Once a feature or set of changes are completed, a branch can be seamlessly merged back into the main line of code.

<div class="body-img">
![](https://s3.amazonaws.com/charukiewicz/assets/images/branches-lg-color-sm.png)
</div>

A component of our software development methodology that goes beyond use of tools is our code review process.  This is a procedure that we undergo each time a set of code changes are completed.  Here, the author of the code will sit with at least one other engineer (the 'reviewer') and walk them through their changes.  The reviewer will provide feedback, ask questions, and point out any issues with the code that the author is submitting.

This process may be somewhat daunting for new engineers, as their work is examined to a degree of closeness that is not common outside of software development, but any feelings of anxiety quickly turn into confidence with the right approach.  The purpose of a code review is to educate the author as well as any reviewers, to catch bugs early on, and to improve code quality.  With a reassuring attitude from the reviewers, code review becomes a collaborative effort to the benefit of everyone involved.


## Continual Improvement

The aspects of the Roompact software development team I described in this post are key contributors to its success.  However, if there is one additional point to end this post on, it is to mention that we are continually seeking to improve each of these aspects of our team.

This quarter, we have begun to put additional focus on the deliberate learning of specific technologies and concepts, rather than just a broad improvement of software development skill.  Just last week we developed a plan for a better code review process, one that will allow for more reviews of smaller segments of code rather than lengthy reviews that had only come at the end of projects up until now.  And even at this very moment, we are in the process of evaluating new tools to improve the way in which we build our user interfaces with the goal of producing code that is more terse and comprehensible.

As our product and our company continue to grow and develop, I look forward to the opportunity to continue to innovate in our software, to overcome any challenges we may face, and to continue to build a team of effective software engineers.

---------

*This post originally appeared on the [Roompact On Duty Blog](https://blog.roompact.com/). [Roompact](https://roompact.com/) is residential education software for colleges and universities that allows housing and residence life programs to track their educational efforts and make their administrative work more efficient.*
