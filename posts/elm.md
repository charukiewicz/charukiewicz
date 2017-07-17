---
title: Elm In Production: 25,000 Lines Later
disqus: yes
thumbnail_description: Experiences of using the Elm programming language in production
thumbnail_image: nothing
date: 2017-07-17
---

At [Roompact](https://roompact.com), we make a SaaS software platform used by university residence life departments across the United States. Our software provides an array of features that range from an templatable forms, to email and text message broadcasting, to a central news feed that acts as both a communications tool and data aggregator for residence hall staff.

Roompact was founded in 2013, and since its inception, a combination of vanilla JavaScript, jQuery, and an assortment of jQuery-esque libraries had been what the entire front end of the application was built with. In October of 2016, I realized that we were long past due for an upgrade.

## jQuery Spaghetti

The metaphorical straw that broke the camel's back was the fact that a feature we had worked on over the summer and released in August was already feeling like a legacy application. Built as a single-page application (SPA) making very heavy use of Ajax calls to a JSON-based RESTful API as its back end, its 5,000 lines of front end code were already becoming very difficult to modify, hardly a month after release. "When did this become a pile of jQuery spaghetti?" I thought.

The problem with jQuery is not that it is inherently flawed. It is that it, along JavaScript itself, do absolutely nothing to help the programmer as the piece of software that is being written grows in size. jQuery's strengths are its ease of use and its terseness for things like DOM manipulation, event listener creation, or making http requests. But in my opinion, jQuery no longer has any place being at the core of a large front end application, as it offers nothing from an architectural standpoint.

As an application grows, this absence of structure will almost inevitably result in a tangled mess of random DOM manipulations, nested callbacks, and nonsensical structure. This is particularly likely in real world development, where several people will often work on the same code, and there is always a tug of war between doing it right and getting it done. For doing something like building a 5,000 line SPA, jQuery is the wrong tool for the job, and there is no shortage of better tools out there.

## A New Tool For the Front End
