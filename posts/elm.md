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
</blockquote>

Another important factor that emerged during this process was a human one: writing Elm code was both fun and interesting. My favorite quote from my new-to-Elm engineer during this process was the one above. Hearing this was not a top initial priority when looking for a new tool, but it was a very reassuring thing to hear. As the Chief Technology Officer of a company whose main focus is to build software, my responsibilities do not end at ensuring my team is productive. I view it as an obligation to ensure that each team member feels the importance of their work, engages in work that they have a personal affinity towards, and continually develops professionally. Simply writing code in Elm was immediately hitting two out of three of these goals.

## Using Elm

With these two trials of Elm being very successful, I had all the evidence I needed: we were going to more forward with Elm. Our first user-facing application of Elm would come in short order. Without going into extensive detail, we spent the entire first half of 2017 making the largest and most complex feature that Roompact has ever seen: a highly customizable form-building system catered to our business domain. With almost every single piece of data on the page (questions, input types, order values, tags, answers, form template revision history, form submission revision history, etc.) being dynamic, the amount of data that the front end had to manage would be extreme. Moreover, this data would have to be shared across multiple views seamlessly: a user would have to be able to create a form and then be able to switch to a different view to be able to submit it. Upon submission, they would have to be able to switch to a tabular view to examine submissions to that new template in aggregate.

Not only was the scope of this feature to be extremely broad, but it would also serve as a replacement for two existing features that were no longer up-to-par, and not worth updating. This would easily be the most high-stakes project we had ever undertaken. And we used Elm for the entire front end.

Released in early June, it is now approximately 22,000 lines of Elm code in the form of a single Elm application. Feedback from our summer users has been nothing short of glowing. I credit Elm for making it possible to build such an intricate front end to such a high degree of reliability. I would like to use the rest of this post to outline what we have learned as we have used Elm; both its strengths and its weaknesses.

--------------------

### Elm has an incredibly powerful type system

Relative to other front end tools, Elm's type system is its most distinct and powerful feature. Elm is statically typed, meaning all code is verified during the compilation process (more on that later). More importantly, Elm allows for the creation of Algebraic Data Types, called [Union Types](https://guide.elm-lang.org/types/union_types.html) in Elm. This allows the programmer to move as much of the business logic as possible into the type system and away from the runtime code.

One simple example is that of a three-way state. Suppose I have an input field with tags. Some of which were there when I got to the page, others that I may **add** as I am on the page, and others that I may **remove** while I am on the page. But here's the catch: if I press "Cancel" to return to a previous view in the application, the tag list much revert to its original state. If I press "Save" the changes must be applied.

In order to do this in JavaScript, one common solution would be:

1. create a list for added tags and another for removed tags
2. populate each list depending on which tags are added or removed by the user
3. apply the changes to the master tag list for that input entry only if the "Save" button is pressed

This might work, but it could be error prone. What if something is not re-initialized correctly after the user visits the page for a second time? Are we resetting them every time that we need to? How do we keep the tag list that the user sees in the DOM in sync with the state?

In Elm, I can model this as follows:

```haskell
-- Each file in Elm is a module, so we are giving it a name
-- and listing what any importing modules get access to
module TagData exposing (TagState, Tag)

-- The type representing the possible states of the tag
type TagState = Current | Added | Removed


-- The type representing a single tag
type alias Tag =
    { tagId : Int
    , tagName : String
    , tagStatus : TagState
    }
```

In the above example, every value of type `Tag` will contain a `tagStatus` field, which will contain a value of type `TagState`, which in turn has to be one of the three states I want to represent. Below, I will show an example of code that would use this value to display a tag.

### Elm has a great compiler

Elm's compiler is what does the heavy lifting of enforcing the constraints of the type system, but I would consider it to be its own benefit. There are other statically typed languages that have compilers, but Elm's is in a league of its own.

Let's consider the snippet of code in the section above. With the above types, every `Tag` in my application to always have a `TagState`. Let's see how we would use this to our advantage to address the problem of keeping our DOM in sync with our data:

```haskell
-- Function that renders tags
displayTag : Tag -> Html Msg
displayTag tag =
    case tag.tagStatus of
        Current ->
            -- Display a standard tag
            div [ class "tag" ] [ text tag.tagName ]

        Added ->
            -- Display a tag, but include the 'tag-added' class
            -- so that we can style these tags differently
            div [ class "tag tag-added" ] [ text tag.tagName ]

        Removed ->
            -- Display an empty div*
            div [] []
```

<small style="color: #999;">
\* Note that it would be possible to restructure this code in a way that does not display an empty \<div> in the case of a removed tag, but the above code results in the clearest example.
</small>

But what if we had forgotten to handle one of our cases? Suppose we did not include the `Removed` case.


<div class="sourceCode">
```
==================================== ERRORS ====================================

-- MISSING PATTERNS --------------------------------------------------- TagDisplay.elm

This `case` does not have branches for all possibilities.

72|>    case tag.tagStatus of
73|>        Current ->
74|>            div [ class "tag" ] [ text tag.tagName ]
75|>
76|>        Added ->
77|>            div [ class "tag tag-added" ] [ text tag.tagName ]

You need to account for the following values:

    TagData.Removed

Add a branch to cover this pattern!

If you are seeing this error for the first time, check out these hints:
<https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/missing-patterns.md>
The recommendations about wildcard patterns and `Debug.crash` are important!

Detected errors in 1 module.
```
</div>

The compiler tells us what the cause of the error is, exactly where it is, and what we need to do to fix it. The large majority of compiler errors in Elm are written in this manner. This is wildly helpful when dealing with something like potentially dozens of user-defined types, each with numerous possible values. This is particularly helpful when one developer might be editing another developer's code: I do not have to look at the definition of the `TagState` type in order to safely edit code that relies on it; if I miss something the compiler will let me know (it even tells me that the missing value is defined in the `TagData` module).

There is one other key benefit that comes out of this combination of static typing a powerful compiler: Elm absolutely never encounters runtime exceptions. In a talk recorded in April of 2017, Richard Feldman from NoRedInk [describes how the 100,000 lines of Elm code they have built up since 2015 have never thrown a runtime exception](https://www.youtube.com/watch?v=XsNk5aOpqUc#t=4m30s).

### Writing in a functional style has huge benefits

Everyone who knows about Elm knows that it is a functional language. However, I think that relatively few developers have written enough functional code to build an appreciate for just how nice reading and writing functional code is. Here are some of the hallmark features of Elm code:

**Pure Functions** - Virtually all functions in Elm are considered 'pure' (which is also referred to as "referentially transparent"). This means that given a set of parameters, a function will always produce the same result. Pure functions also lack the ability to produce side effects (making HTTP requests, changing HTML on the page, printing output somewhere, etc.).

These two traits combine to significantly lower the cognitive load required to read Elm code. If you see a function whose type signature says it takes one `Int` parameter and returns an `Int` value, you know it is doing some sort of numerical manipulation. If you are looking for code that validates email addresses, look elsewhere (perhaps for a function that takes a `String` and returns a `Bool`).

**Immutable Values** - All values in Elm are immutable; they cannot be changed after they are set. This may seem limiting to someone coming from writing JavaScript, but in a functional paradigm, changing values is not necessary. The standard approach is to return a new value rather that overwrite the old one.

This is the way in which the state in an Elm application (referred to as the "Model") gets updated. Each time you want to update a value, you will invoke your application's `update` function, which will always take your entire current model and a value (referred to as a `Msg`) that describes which changes to apply. An entirely new model value is returned, and replaces the old one. Worry not, the compiler optimizes the code that handles this process, so it remains blazing fast. But it allows for excellent debugging methods (covered below).

**Higher-Order Functions** - A higher order function is simply a function that takes another function as a parameter, or returns function as its result. This leads the excellent opportunities for function composition. Take a look at an example of the `map` function below (which takes a function and applies that function to every element in a list.

```haskell
square : Int -> Int
square x = x * x

normalList = [1, 2, 3, 4, 5]

squaredList = List.map square normalList
```

In the above code, the `square` function is applied to every element in `normalList`. When this code is evaluated, `squaredList` will contain `[1, 4, 9, 16, 25]`.

**Pattern Matching** - This is without a doubt one of the most useful features in Elm. Pattern matching allows you to to write code that will only run when the "shape" of a certain value matches. Consider the following example:

```haskell
type UserGroup = AdministratorUserGroup | StandardUserGroup

type PermissionLevel = AdministratorPermission | StandardPermission


-- Function checks whether a user can edit a post

checkIfUserCanEditPost : PermissionLevel -> UserGroup -> Bool
checkIfUserCanEditPost requiredPermissionLevel userPermissionGroup =
    case (requiredPermissionLevel, userPermissionGroup) of
        -- A standard user can edit a standard post
        (StandardPermission, StandardUserGroup) ->
            True

        -- An administrator can edit any post
        (_, AdministratorUserGroup) ->
            True

        -- Deny any other possible combination of values
        _ ->
            False
```

In the above code, we combine the `requiredPermissionLevel` and `userPermissionGroup` parameters into a tuple in the `case` statement and evaluate them together as we try to match one of the cases. The `_` value will match any value in the case statement. We use it to avoid having to define `(StandardPermission, AdministratorUserGroup)` and `(AdministratorPermission, AdministratorUserGroup)` as two separate cases. Instead, we tell compiler to produce code that evaluates to true anytime the user is an administrator. We also use the `_` value in the final case statement as a catch-all, to deny all other possible combinations of required permission level and user group.

### Elm has a readable syntax

This may be a point of contention, but it is my opinion that Elm's syntax (largely taken from Haskell), is very readable:

* It tends to be quite terse, with individual lines of Elm code being very short.
* It does away with unnecessary curly brackets and semicolons.
* Function parameters are delineated via spaces.
* Functions and variables start with lower case letters and are always written in camelCase.
* Types and module names always start with uppercase letters and are written in PascalCase.
* Elm code is indented only with spaces (killing the tabs vs. spaces debate).
* Indentation largely does not matter in most places to begin with (though most of the community uses a utility to auto-format their code, discussed below).

### Elm has a great set of simple development tools

The Elm community has developed a number of tools over time that remove many of the pain points of development.

* The standard `elm` binary comes with four primary utilities:
    * `elm make` - the compiler
    * `elm package` - the package build tool; can be used to quickly install new packages or download all dependencies in an existing project
    * `elm repl` - a simple read-eval-print loop; a good way to test code and ideas in the command line
    * `elm reactor` - a simple web server and websocket-based live reload used for rudimentary development
* [`elm-format`](https://github.com/avh4/elm-format) - a utility that auto-formats code to the community standards; most editors will have plugins to have to auto-run each time a file is saved
* [`elm-upgrade`](https://github.com/avh4/elm-upgrade) - a utility that helps automatically upgrade much of your code when a new version of Elm is released (more on this later)

### Elm applications have excellent performance and additional optimization is easy

Although Elm is a very high level language, the JavaScript that the compiler produces is extremely fast.

In August of 2016, Elm 0.17 (last version of Elm at the time of this writing), even [non-optimized Elm code was able to outperform React, Angular 2, and Ember](http://elm-lang.org/blog/blazing-fast-html-round-two).

In a different set of benchmarks posted in May of 2017, [Elm's performance was on par with React and Angular 4](https://rawgit.com/krausest/js-framework-benchmark/f37bbd413c435d3fff3f2fcd5207e1cba1523507/webdriver-ts-results/table.html), which were all among the fastest frameworks in the benchmark (having a slowdown of 1.30 - 1.40 relative to the optimal vanilla JavaScript implementation of the benchmark). The fastest framework intended for production use, Inferno, scored 1.07.

In practice, runtime performance should rarely be a concern with Elm for normal web applications. In the event that additional optimizations are required, elm has two libraries which can increase the performance of the application.

* [Html.Lazy](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Lazy) - offers functions that can be used to cache the results of view functions, reducing the need to re-render certain elements.
* [Html.Keyed](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Keyed) - offers functions that can be used to optimize situations when elements are getting added, removed, or re-ordered (such as in a list)

Functions in both of the above modules are drop-in replacements for functions from the standard Html module.

### The Elm community is very friendly and helpful

In my experiences, the following three communities are the best place for Elm help and discussion:

* [/r/elm](http://www.reddit.com/r/elm) - The Elm Reddit community. A place for news and general discussion.
* [Elm Slack](http://elmlang.herokuapp.com/) - The Elm Slack team. A great place to go for help on a certain topic. There are always users active here, and in my experiences, skill levels range from total beginner to expert. I have been surprised to hear answers that sometimes require substantial understanding of how the Elm compiler works.
* [Elm Discuss](https://groups.google.com/forum/?fromgroups#!forum/elm-discuss) - The Elm Google Group. Like the other two, this community is very active, with discussions ranging from beginners asking for help, to discussions of very advanced topics, project proposals, etc.

### Elm applications can be rather large when compiled

The amount of code produced by the Elm compiler can be somewhat lengthy. Our 22,000 line application compiles to a file with over 53,000 lines of JavaScript that is 1.6MB in size.

Fortunately, using the Google Closure Compiler with simple optimizations enabled, this file can be reduced to be a mere 450KB in size. A minor downside of using the GCC is that it is written in Java, so the Java Runtime is required to run it. There is a version written in Node.js, but it is considered an experimental release, and in my experiences, this compiler is far slower on large JavaScript files such as the one in our case.

### The Elm core libraries do not yet have many web API bindings, but interoperability with JavaScript code is safe and easy

Not everything is possible in native Elm code. For example, there is no official library for using the `localStorage` API, as the Elm API is still being developed. However, the good news is that Elm has very well thought out [JavaScript interoperability](https://guide.elm-lang.org/interop/javascript.html). There are two primary methods for doing so:

* **Ports** can be used to talk to any JavaScript code outside of the Elm application during runtime. This technique can also be used to send data *into* Elm.
* **Flags** can be used to set values in Elm during the initialization of the application. This may be used to set values passed to the browser from the web server that Elm must have access to, such as user configuration settings or authentication tokens. This technique would likely be used when Elm is being used in a full stack MVC framework (such as Ruby on Rails).

### The Elm language and core libraries are subject to change as new versions of the compiler are released

This point may sound scarier than it is, but it should certainly be considered for production use. Elm is currently on version 0.18, with a 0.19 release coming likely in the next few months. 0.17 was released in December 2016, right as we were finishing our second small Elm project. As a result, we experienced the process of upgrading Elm in our two small applications. To give a summary of the experience:

* The process was well documented and relatively simple. There were several syntax changes, but most of this was handled by the `elm-upgrade` tool I mentioned above.
* There were a few changes to the way the HTTP library worked, which we had to spend some time on. This portion of the process likely took a lot longer than it would today, as we were so new to Elm.
* We had to wait to upgrade until all of our dependency libraries were upgraded as well.

I will add that this last point may be a huge potential ramifications in a production application. I have been somewhat reserved in using external libraries in our application, particularly avoiding ones with large dependency trees or a lot of code. I can foresee a scenario where some dependency in your application gets abandoned, and your team may have to support it. Certainly this is a risk with any library in any language, but **the Elm compiler will refuse to even attempt to compile your application unless every dependency in your project supports the current version**.

If this abandonment scenario takes place with single module library that has 150 lines of code, that should not be a big deal and may even require no changes at all, short of a version bump in the package file. But I would stay far away from a library like [elm-mdl](https://github.com/debois/elm-mdl), a full material design implementation in Elm, which contains 10,000 lines of Elm code. If your application becomes highly dependent on such a library, and the maintainer stops supporting it, you will have to make the decision between forking the library and maintaining it on your own, or never upgrading to the newest version of Elm.
