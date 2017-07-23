---
title: Elm In Production: 25,000 Lines Later
disqus: yes
thumbnail_description: Experiences of using the Elm programming language in production
thumbnail_image: https://s3.amazonaws.com/charukiewicz/assets/images/elm-logo-color-corrected-thumbnail-sm.png
date: 2017-07-17
---

<div style="margin-bottom:50px;margin-top:25px;">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/elm-logo-color-corrected-xs.png">
</div>

At [Roompact](https://roompact.com), we make a SaaS software platform used by university residence life departments across the United States. Our software provides an array of features that range from an templatable forms, to email and text message broadcasting, to a central news feed that acts as both a communications tool and data aggregator for residence hall staff.

Roompact was founded in 2013, and since its inception, a combination of plain JavaScript, jQuery, and an assortment of jQuery-esque libraries had been what the entire front end of the application was built with. In October of 2016, I realized that we were long past due for an upgrade. The straw that broke the camel's back occurred when a feature we had worked on over the summer and released in August had already started feeling like a legacy application. Built as a single-page application (SPA) making very heavy use of Ajax calls to a JSON-based RESTful API as its back end, its 5,000 lines of front end code were already becoming very difficult to work with and modify, hardly a month after release. "When did this become a pile of jQuery spaghetti?" I thought.

## Trying Elm

The search for a replacement front end framework had me considering React and Vue.js the top candidates for several weeks. But I had a feeling that I should examine Elm more closely. I had read about Elm in the past and it was showcased at a Haskell meetup I attended in Chicago. I was not by any means an advanced Haskeller when making the consideration to use Elm, but I knew that several years of writing small Haskell programs and reading about the language would have left me with knowledge transferable to Elm. It was also my belief in the benefits of statically typed functional programming that made the opportunity to at least try Elm too tempting to pass up.

I decided to follow the general strategy outlined in Evan Czaplicki's [How to Use Elm at Work](http://elm-lang.org/blog/how-to-use-elm-at-work) post. One day in November I set out to make a small internal tool that solved the problem of having no UI to configure a certain one of our features. The project took me about three full days to complete. The experience involved a lot of fighting against the compiler and resisting the feeling of being trapped by having to write in a functional style. By the end, I had written a bit over 500 lines of Elm. I realize that despite running into compiler errors often, and having to completely eschew techniques that were commonplace in imperative code, the constraints imposed by Elm were actually rather helpful. The compiler offered protection against silly mistakes, and functional code was easy to read and naturally highly composable. This was exactly the type of stuff I had read about when dabbling with Haskell.

## Teaching Elm

A few weeks after finishing my little project, I introduced one of my engineers to Elm. He would be writing another internal tool that was quite a bit larger than mine. More importantly, he had no previous functional programming experience whatsoever. In order to be able to adopt Elm at our company, it was absolutely imperative that I would be able to get him productive in what was to him a completely foreign language rather quickly. In order to accomplish this, my approach was to:

1. Pair program with the learner on most of this initial project, but make them write most of the code
2. Emphasize the importance of reading type signatures, both in our own code and in any documentation we were referencing
3. Treat compiler errors as helpful feedback, rather than as a signal indicating failure
4. Practice approaching each problem with a functional mindset (e.g. "How can we apply `List.map` or `List.filter` rather than a `for` loop and array mutation?")

This project took a few weeks to complete. The end result was highly successful, and both him and I learned quite a bit about Elm as we worked on it together. Most importantly, by the end, my engineer was comfortable enough with Elm as to work independently for extended periods of time. The lesson had been a success, and it also proved that about a week of intense training, someone who has never written functional code can build a solid understanding of the basics of Elm. Within month, they should be able to work independently on code that will eventually make it into production.

<blockquote>
<p>Work has gotten really interesting again.</p>
<p>— Roompact Software Engineer, during his first ever Elm project</p>
</blockquote>

Another important factor that emerged during this process was a human one: writing Elm code was both fun and interesting. My favorite quote from my new-to-Elm engineer during this process was the one above. Hearing this was not a top initial priority when looking for a new tool, but it was a very reassuring thing to hear. As the Chief Technology Officer of a company whose main focus is to build software, my responsibilities do not end at ensuring my team is productive. I view it as an obligation to ensure that each team member feels the importance of their work, engages in work that they have a personal affinity towards, and continually develops professionally. Simply writing code in Elm was immediately hitting two out of three of these goals.

## Using Elm

With these two trials of Elm being very successful, I had all the evidence I needed: we were going to more forward with Elm. Our first user-facing application of Elm would come in short order. Without going into extensive detail, we spent the entire first half of 2017 making the largest and most complex feature that Roompact has ever seen: a highly customizable form-builder system catered to our audience. With almost every single piece of data on the page (questions, input types, order values, tags, answers, form template revision history, form submission revision history, etc.) being dynamic, the amount of data that the front end had to manage would be extreme. Moreover, this data would have to be shared across multiple views seamlessly: a user would have to be able to create a form and then be able to switch to a different view to be able to submit it. Upon submission, they would have to be able to switch to a tabular view to examine submissions to that new template in aggregate.

Not only was the scope of this feature to be extremely broad, but it would also serve as a replacement for two existing features that were no longer up-to-par, and not worth updating. This would easily be the most high-stakes project we had ever undertaken. And we used Elm for the entire front end.

Released in early June, it is now approximately 22,000 lines of Elm code.
