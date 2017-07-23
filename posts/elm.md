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

## Enter Elm

The search for a replacement front end framework had me considering React and Vue.js the top candidates for several weeks. But I had a feeling that I should examine Elm more closely. I had read about Elm in the past and it was showcased at a Haskell meetup I attended in Chicago. I was not by any means an advanced Haskeller when making the consideration to use Elm, but I knew that several years of writing small Haskell programs and reading about the language would have left me with skills transferable to Elm. It was also my belief in the benefits of statically typed functional programming that made the opportunity to at least try Elm too tempting to pass up. 


