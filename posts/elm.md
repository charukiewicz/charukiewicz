---
title: Elm In Production: 25,000 Lines Later
disqus: yes
thumbnail_description: Reflecting on our experience of using Elm in production and an evaluation of Elm's distinguishing features
thumbnail_image: https://s3.amazonaws.com/charukiewicz/assets/images/elm-logo-color-corrected-thumbnail-sm.png
date: 2017-07-17
---

<div style="margin-bottom:50px;margin-top:25px;">
<img src="https://s3.amazonaws.com/charukiewicz/assets/images/elm-logo-color-corrected-xs.png">
</div>

At [Roompact](https://roompact.com), we make a SaaS product used by university residence life departments across the United States. Our software provides an array of features that range from form-based tools, to digital roommate agreements, to email and text message broadcasting, to a central news feed that acts as both a communications tool and data aggregator for residence hall staff.

Roompact was founded in 2013, and since its inception, a combination of plain JavaScript, jQuery, and an assortment of jQuery-esque libraries had been what the entire front end of the application was built with. In October of 2016, I realized that we were long past due for an upgrade. The straw that broke the camel's back occurred when a feature we had worked on over the summer and released in August had already started feeling like a legacy application. Built as a single-page application (SPA) making very heavy use of Ajax calls to a JSON-based RESTful API as its back end, its 5,000 lines of front end code were already becoming very difficult to work with and modify, hardly a month after release. "When did this turn into jQuery spaghetti?" I thought.

## Trying Elm

The search for a replacement front end framework had me considering React and Vue.js as the top candidates for several weeks. But I had a feeling that I should examine Elm more closely. I had read about Elm in the past and it had been showcased at a Haskell meetup I attended in Chicago. I was not by any means an advanced Haskeller when making the consideration to use Elm, but I knew that several years of writing small Haskell programs and reading about the language would have left me with knowledge transferable to Elm. It was also my belief in the benefits of statically typed functional programming that made the opportunity to at least try Elm too tempting to pass up.

I decided to follow the general strategy outlined in Evan Czaplicki's [How to Use Elm at Work](http://elm-lang.org/blog/how-to-use-elm-at-work) post. One day in November of 2016 I set out to make a small internal tool that solved the problem of having no UI to configure a certain one of our features. The project took me about three full days to complete. The experience involved a lot of fighting against the compiler and resisting the feeling of being trapped by having to write in a functional style. By the end, I had written a bit over 500 lines of Elm. I realize that despite running into compiler errors often, and having to completely eschew techniques that were commonplace in imperative code, the constraints imposed by Elm were actually rather helpful. The compiler offered protection against silly mistakes, and functional code was easy to read and naturally highly composable. These were the types of benefits that I had read about when learning the fundamentals of Haskell.

## Teaching Elm

A few weeks after finishing my little project, I introduced one of my engineers to Elm. He would be writing another internal tool that was quite a bit larger than mine. More importantly, he had no previous functional programming experience whatsoever. In order to be able to adopt Elm at our company, it was absolutely imperative that I would be able to get him productive in what was to him a completely foreign language rather quickly. In order to accomplish this, my approach was to:

1. Pair program with him on a significant portion of this initial project, but make him write most of the code
2. Emphasize the importance of reading type signatures, both in our own code and in any documentation we were referencing
3. Treat compiler errors as helpful feedback, rather than as a signal indicating failure
4. Practice approaching each problem with a functional mindset (e.g. "How can we apply `List.map` or `List.filter` rather than a `for` loop and array mutation?")

This project took him a few weeks to complete. The end result was highly successful, and both him and I learned quite a bit about Elm as we worked on it together. Most importantly, by the end, my engineer was comfortable enough with Elm as to work independently for extended periods of time. The lesson had been a success, and it also proved that about a week of intense training, someone who has never written functional code can build a solid understanding of the basics of Elm. Within month, they should be able to work independently on code that will eventually make it into production.

<blockquote>
<p>Work has gotten really interesting again.</p>
</blockquote>

Another important factor that emerged during this process was a human one: writing Elm code was both fun and interesting. My favorite quote from my new-to-Elm engineer during this process was the one above. Hearing this was not a top initial priority when looking for a new tool, but it was a very reassuring thing to hear. As the Chief Technology Officer of a company whose main focus is to build software, my responsibilities do not end at ensuring my team is productive. I view it as an obligation to ensure that each team member feels the importance of their work, engages in work that they have a personal affinity towards, and continually develops professionally. Simply writing code in Elm was immediately hitting two out of three of these goals.

## Using Elm

With these two trials of Elm being very successful, I had all the evidence I needed: we were going to more forward with Elm. Our first user-facing application of Elm would come in short order. Without going into extensive detail, we spent the entire first half of 2017 making the largest and most complex feature that Roompact has ever seen: a highly customizable form-builder system with integrations to the rest of the data in out software.

With almost every single piece of data on each page in this feature being dynamic (questions, input types, order values, tags, answers, form template and submission edit histories, etc.), the need for managing all of this data effectively was paramount. Moreover, this data would have to be shared across multiple views seamlessly: an edit to a form template would have to be reflected in the corresponding form submission creation page immediately; a new form submission would have to be visible in the multiple tabular views in addition to its own individual page view.

Not only was the scope and complexity of this feature to be extremely broad, but it would also serve as a replacement for two existing features that were no longer up-to-par, and not worth updating. This would easily be the most high-stakes project we had ever undertaken.

With all of this in mind, I was quite convinced that Elm would be the best tool for the job. And so, we used Elm for the entire front end.

Released in early June, it is now over 22,000 lines of Elm code in the form of a single Elm application. Feedback from our summer users has been nothing short of glowing. I am certain that it was the decision to use Elm that make it possible to build such an intricate front end to such a high degree complexity without making any compromises in performance or reliability.

## Reflecting on Elm

In the rest of this post I am going to outline what we have learned as we have used Elm; both its strengths and its weaknesses. This is not meant to be an Elm tutorial, but it is meant to inform someone with little-to-no knowledge of the language of its distinguishing features. Every point discussed below is aimed at addressing the experiences of using Elm in a production setting. That is, software that will likely be written by several people, that must be bug-free, performant, address a certain set of functionality requirements, and will see significant use by end users.

### Elm has an incredibly powerful type system

Relative to other front end tools, Elm's type system is its most distinct and powerful feature. Elm is statically typed, meaning all code is verified during the compilation process (more on that later). More importantly, Elm allows for the creation of Algebraic Data Types, which are referred to as [Union Types](https://guide.elm-lang.org/types/union_types.html) in Elm. This allows the programmer to model much of the business logic of the application in type system, to be verified statically by the compiler, rather than in code that will be evaluated at runtime.

One simple example is that of a three-way state. Suppose I have a tag input field. When I arrive to the page with this input, certain tags may already be present. I can then edit the tag list, either by adding or removing tags. But here's the catch: if I press "Cancel" to return to a previous view in the application, the tag list much revert to its original state. If I press "Save" the changes must be applied.

There are a number of ways to do this in JavaScript, one solution would be:

1. in addition to the master tag array for that field, create temporary arrays for added and for removed tags
2. for each tag change, apply it to the master array and keep a record of the change in the corresponding temporary array
    * if a tag is removed, remove it from the master array and add it to the removed array
    * if a tag is added, add it to the master array and to the added array
3. apply or revert the changes depending on the final user action
    * if the "Save" button is pressed, use the tags stored in both temporary arrays to permanently save the changes (e.g. http request to the back end)
    * if the "Cancel" button is pressed, use the temporary arrays to identify which tags to add back into or remove from the master array
4. clear the temporary arrays

In JavaScript, our solution relies on using several data structures to help with the bookkeeping of keeping track of which tags were added or removed. This might work, but I have to make many considerations in order to avoid possible errors. What if something is not re-initialized correctly after the user visits the page for a second time? Are we resetting them every time that we need to? How do we keep the tag list that the user sees in the DOM in sync with the state?

I chose this approach because there is no great way to model the current state of each tag in the tag itself. Attempting to do so might involve adding a `status` field containing a string that indicates one of the three possible states. Or worse yet, I could try to model this by juggling several boolean fields (e.g. `added_status`, `removed_status`).

Even the single-field approach likely to result in chains of if-statements that perform string comparisons in several places in the program. I will also have to ensure that my `status` field is always initialized with any tag object in order to protect against runtime errors. I could attempt to solve this latter problem by creating prototype functions that extend a `Tag` constructor object, but there is nothing forcing anyone to use these prototypal functions to create `Tag` objects to begin with. In short, adding such a field to my tag object is an encumbrance, as I have to remember to handle this extra field throughout my program.

By contrast, in Elm, modeling the possible states of each tag is incredibly easy. We can write this as follows:

```haskell
-- The type representing the possible states of the tag
type TagState = Current | Added | Removed


-- The type representing a single tag
type alias Tag =
    { tagId : Int
    , tagName : String
    , tagStatus : TagState
    }
```

In the above example, every value of type `Tag` will contain a `tagStatus` field, which will contain a value of type `TagState`, which in turn has to be one of the three states I want to represent. The important thing to note here is that now every tag value **must** have a `tagStatus` field, and it **must** always contain one of the three defined `TagState` values. If this field is not initialized (e.g. at the JSON decoder for a tag) or its values are not handled exhaustively (e.g. in my view code), the program will not compile. I will show an example of the latter scenario below.

### Elm has a great compiler

Elm's compiler is what does the heavy lifting of enforcing the constraints of the type system, and I would consider it to be a huge asset when writing Elm code. Other statically typed languages have compilers, but Elm's is in a league of its own.

Let's consider the snippet of code in the section above. With the above types, every `Tag` in my application to always have a `TagState`. Let's see how we would use this to our advantage to address the problem of keeping our DOM in sync with our data:

```haskell
-- Function that takes a tag value and returns an html
-- value that will be rendered by the Elm program
displayTag : Tag -> Html Msg
displayTag tag =
    -- perform a match against the tagStatus field of the tag parameter
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

    Removed

Add a branch to cover this pattern!

If you are seeing this error for the first time, check out these hints:
<https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/missing-patterns.md>
The recommendations about wildcard patterns and `Debug.crash` are important!

Detected errors in 1 module.
```
</div>

The compiler tells us what the cause of the error is, exactly where it is, and what we need to do to fix it. The large majority of compiler errors in Elm are written in this manner. This is wildly helpful when dealing with something like potentially dozens of user-defined types, each with numerous possible values. This is particularly helpful when one developer might be editing another developer's code: it is not necessary to look at the definition of the `TagState` type in order to safely edit code that relies on it; if I miss something the compiler will let me know.

There is one other key benefit that comes out of this combination of static typing a powerful compiler: Elm absolutely never encounters runtime exceptions. In a talk recorded in April of 2017, Richard Feldman from NoRedInk [describes how the 100,000 lines of Elm code they have built up since 2015 have never thrown a runtime exception](https://www.youtube.com/watch?v=XsNk5aOpqUc#t=4m30s).

### Writing in a functional style has significant productivity benefits

Everyone who knows about Elm knows that it is a functional language. However, I think that relatively few developers have written enough functional code to build an appreciation for just how pleasant reading and writing functional code is, and the productivity gains that come as a result. Here are some of the hallmark features of Elm code:

**Pure Functions** - Virtually all functions in Elm are considered 'pure'. This means that given a set of parameters, a function will always produce the same result. Such functions also referred to as being [referentially transparent](https://en.wikipedia.org/wiki/Referential_transparency), meaning they can be replaced with their corresponding return values without altering the behavior of the program. Because of the constraints that enforce this property, pure functions lack the ability to produce side effects (making HTTP requests, changing HTML on the page, printing output somewhere, etc.).

These traits combine to result in a significantly lower the cognitive load required to read Elm code. For example, if you see a function whose type signature is `Int -> Int`, meaning that it takes one `Int` parameter and returns an `Int` value, you can safely assume that it will at most be doing some sort of numerical manipulation without any other side effects. If you are searching for code that validates email addresses, you know that you can look elsewhere (perhaps for a function that takes a `String` and returns a `Bool`).

**Immutable Values** - All values in Elm are immutable; they cannot be changed after they are set. This may seem limiting to someone coming from writing JavaScript, but in a functional paradigm, changing values is not necessary. The standard approach is to return a new value rather that overwrite an old one. Immutability eliminates a whole array of possible issues in a program, ranging from race conditions caused by concurrent code, to uncontrolled global state modification.

**Higher-Order Functions** - A higher order function is simply a function that takes another function as a parameter, or returns a function as its result. This style of programming is very common in Elm and leads to code that is well suited function composition, and in turn, reusability. Take a look at an example of the `map` function below (which takes a function and applies that function to every element in a list):

```haskell
square : Int -> Int
square x = x * x

normalList = [1, 2, 3, 4, 5]

squaredList = List.map square normalList
```

In the above code, the `square` function is applied to every element in `normalList`. When this code is evaluated, `squaredList` will contain `[1, 4, 9, 16, 25]`.

**Pattern Matching** - This is without a doubt one of the most useful features in Elm. Pattern matching allows you to to write code that will only get evaluated when the "shape" of the value being examined matches the defined pattern. Consider the following example:

```haskell
type PermissionLevel = AdministratorPermissionLevel | StandardPermissionLevel

type UserGroup = AdministratorUserGroup | StandardUserGroup


-- Function checks whether a user can edit a post

checkIfUserCanEditPost : PermissionLevel -> UserGroup -> Bool
checkIfUserCanEditPost requiredPermissionLevel currentUserGroup =
    case (requiredPermissionLevel, currentUserGroup) of
        -- A standard user can edit a standard post
        (StandardPermissionLevel, StandardUserGroup) ->
            True

        -- An administrator can edit any post
        (_, AdministratorUserGroup) ->
            True

        -- Deny any other possible combination of values
        _ ->
            False
```

In the above code, we combine the `requiredPermissionLevel` and `currentUserGroup` parameters into a tuple in the `case` statement and evaluate them together as we try to match one of the cases. The `_` value will match any value in the case statement. We use it to avoid having to define `(StandardPermissionLevel, AdministratorUserGroup)` and `(AdministratorPermissionLevel, AdministratorUserGroup)` as two separate cases. Instead, we tell compiler to produce code that evaluates to true anytime the user is an administrator. We also use the `_` value in the final case statement as a catch-all, to deny all other possible combinations of required permission level and user group.

### Elm's Model-Update-View architecture is very well-suited for building web applications

The core architectural pattern in every Elm web application is what is referred to as [The Elm Architecture](https://guide.elm-lang.org/architecture/), consisting of three main parts:

The **Model** is the state of the application. The Model consists of a single data structure that contains every piece of data used in the application. It will usually grow incrementally as an application grows in features and complexity, but how it is structured is up to the developer. In most applications the Model will take the form of a record type (similar to an object in JavaScript) which may have any number of top level fields that may be any type of data structure (including themselves being record types).

The **Update** is the portion of the application that handles both changes to the Model as well as any I/O that the Elm application has to perform (http requests, calling external JavaScript functions, etc.). No other portion of the program can change the state of the Model or perform I/O. The Update is called anytime a `Msg` value is produced in the application. Such a `Msg` value will usually represent the action and may have additional data bound to it (e.g. `UserSearchInput "john"`).

The **View** is the portion of the program that renders HTML and handles user inputs. The View always takes the Model as an argument, so any conditional logic that uses data to dictate how the HTML on the page is changed during runtime must be based off of data in the Model. The View is automatically called by the Elm runtime anytime any value in the Model changes. User inputs in the View will produce `Msg` values, which will result in the Elm runtime invoking the Update.

So in general, the execution of an Elm program is as follows:

1. The Model enters a particular state
2. The View is rendered based off of the state of the Model
3. The user interacts with the application, a `Msg` value is produced
4. The Update is called, receiving the `Msg` value as a parameter, which results in a change to the Model (return to step 1)

This structure and the separation of concerns between the different portions of the application make it easy to both build and later refactor even extremely large applications. This structure also eliminates nearly all issues with data going out of sync with the DOM, or different DOM elements being out of sync from one-another, as the View will always re-render the DOM based off of the contents of the Model. To someone who is not used to using this type of architecture, seeing it in action for the first time may feel like magic. It is not uncommon to think "wow all I did was change the value in the model and all of the HTML relies on that value updated automatically".

### Elm has a very powerful debugger

One of the features released in the latest version of Elm (0.18) is known throughout the Elm community as the [Time Traveling Debugger](http://elm-lang.org/blog/the-perfect-bug-report). When opened, the debugger displays the current state of the program as well as the history of `Msg` values produced as the user has interacted with the program. When one of the older `Msg` values in the list is clicked, the entire Elm application will revert to that point in history in the execution of the program. This which will include the state at that point in time as well as the entire contents of the DOM. Clicking through the `Msg` list effectively allows one to replay the entire history of the current session.

What's more is that this entire history can be exported as a JSON file. So a user can be asked to reproduce the steps that led to a bug, export the history, and send that history file to a developer that will fix the problem. The debugger is easily enabled via a `--debug` flag appended during compilation time, and requires no external tools or plugins.

### Elm has a readable syntax

This may be a point of contention, but it is my opinion that Elm's syntax (largely taken from Haskell), is very readable:

* It tends to be quite terse, with individual lines of Elm code being very short.
* It does away with unnecessary curly brackets and semicolons.
* Function parameters are delineated via spaces.
* Functions and variables start with lower case letters and are always written in camelCase.
* Types and module names always start with uppercase letters and are written in PascalCase.
* Elm code is indented only with spaces (killing the tabs vs. spaces debate).
* Indentation largely does not matter in most places to begin with (though most of the community uses a utility to auto-format their code, discussed below).

### Elm has a great set of standardized development tools

The Elm community has developed a number of tools over time that remove many of the pain points of development.

* The standard `elm` binary comes with four primary utilities:
    * `elm make` - the compiler (which is also what enables the debugger via the `--debug` flag)
    * `elm package` - the package build tool; can be used to quickly install new packages or download all dependencies in an existing project
    * `elm repl` - a simple read-eval-print loop; a good way to test code and ideas in the command line
    * `elm reactor` - a simple web server and websocket-based live reload used for rudimentary development
* [`elm-format`](https://github.com/avh4/elm-format) - a utility that auto-formats code to the community standards; most editors will have plugins to have to auto-run each time a file is saved
* [`elm-upgrade`](https://github.com/avh4/elm-upgrade) - a utility that helps automatically upgrade much of your code when a new version of Elm is released (more on this later)

### The Elm community is very friendly and helpful

In my experiences, the following three communities are the best place for Elm help and discussion:

* [/r/elm](http://www.reddit.com/r/elm) - The Elm Reddit community. A place for news and general discussion.
* [Elm Slack](http://elmlang.herokuapp.com/) - The Elm Slack team. A great place to go for help on a certain topic. There are always users active here, and in my experiences, skill levels range from total beginner to expert. I have been surprised to hear answers from people who obviously have very advanced knowledge of things like the Elm compiler; it is reassuring to know that language experts have a willingness to help Elm novices.
* [Elm Discuss](https://groups.google.com/forum/?fromgroups#!forum/elm-discuss) - The Elm Google Group. Like the other two, this community is very active, with discussions ranging from beginners asking for help, to discussions of very advanced topics, project proposals, etc.

### Elm applications have excellent performance and additional optimization is easy

Although Elm is a very high level language, the JavaScript that the compiler produces is extremely fast.

In August of 2016, Elm 0.17 (last version of Elm at the time of this writing), even [non-optimized Elm code was able to outperform React, Angular 2, and Ember](http://elm-lang.org/blog/blazing-fast-html-round-two).

In a different set of benchmarks posted in May of 2017, [Elm's performance was on par with React and Angular 4](https://rawgit.com/krausest/js-framework-benchmark/f37bbd413c435d3fff3f2fcd5207e1cba1523507/webdriver-ts-results/table.html), which were all among the fastest frameworks in the benchmark (having a slowdown of 1.30 - 1.40 relative to the optimal vanilla JavaScript implementation of the benchmark). The fastest framework intended for production use, Inferno, scored 1.07.

In practice, runtime performance should rarely be a concern with Elm for normal web applications. In the event that additional optimizations are required, elm has two libraries which can increase the performance of the application.

* [Html.Lazy](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Lazy) - contains functions that can be used to cache the results of view functions, reducing the need to re-render certain elements.
* [Html.Keyed](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Keyed) - contains functions that can be used to optimize situations when elements are getting added, removed, or re-ordered (such as in a list)

Functions in both of the above modules are drop-in replacements for functions from the standard Html module, meaning no substantial rearchitecting of code is required to apply such functions.

### Elm applications can be rather large when compiled

The amount of code produced by the Elm compiler can be somewhat lengthy. Our 22,000 line application compiles to a file with over 53,000 lines of JavaScript that is 1.6MB in size.

Fortunately, using the [Google Closure Compiler](https://developers.google.com/closure/compiler/) with simple optimizations enabled, this file can be reduced to be a mere 450KB in size. A minor downside of using the GCC is that it is written in Java, so the Java Runtime is required to run it.

There is a [version written in Node.js](https://github.com/google/closure-compiler-js), but it is considered an experimental release, and in my experiences, this compiler is far slower on large JavaScript files such as the one in our case. I have a powerful Core i7 6700K @ 4.00Ghz on my Linux machine, and whereas the Java version takes 2-3 seconds to complete, the Node.js version takes 43 seconds. On substantially weaker hardware, like an EC2 instance used for a development or build environment, the JavaScript version would take several minutes to run.

### The Elm core libraries do not yet have certain web API bindings, but interoperability with JavaScript code is safe and easy

Not everything is possible in native Elm code. For example, there is no official library for using the `localStorage` API, as the Elm API is still being developed. However, the good news is that Elm has very well thought out [JavaScript interoperability](https://guide.elm-lang.org/interop/javascript.html). There are two primary methods for doing so:

* **Ports** can be used to talk to any JavaScript code outside of the Elm application during runtime. This technique can also be used to send data *into* Elm with functions that the Elm application object exposes.
* **Flags** can be used to set values in Elm during the initialization of the application. This may be used to set values passed to the browser from the web server that Elm must have access to, such as user configuration settings or authentication tokens. This technique would likely be used when Elm is being used in a full stack MVC framework (such as Ruby on Rails or Laravel).

A distinguishing feature of this interoperability model is that it ensures type safety and the integrity of the program. Even though an Elm application makes the use of flags and ports, it will still use compile-time type checking and never encounter runtime exceptions.

### The Elm language and core libraries are prone to change as new versions of the compiler are released

This point may sound scarier than it is, but its implications should certainly be considered before using Elm for production use. Elm is currently on version 0.18, with a 0.19 release coming likely in the next few months. 0.17 was released in December 2016, right as we were finishing our second small Elm project. As a result, we experienced the process of upgrading Elm in our first two small applications. To give a summary of the experience:

* The process was well documented and relatively simple. There were several syntax changes, but most of this was handled by the `elm-upgrade` tool I mentioned above.
* There were a few changes to the way the HTTP library worked, which we had to spend some time on. This portion of the process likely took a lot longer than it would today, as we were so new to Elm.
* We had to wait to upgrade until all of our dependency libraries were upgraded as well.

I will add that this last point may have huge potential ramifications in a production application. I have been somewhat reserved in using external libraries in our application, particularly avoiding ones with large dependency trees or a lot of code. I can foresee a scenario where some dependency used by your application gets abandoned, and your team may have to support it. Certainly this is a risk with any library in any language, but the Elm compiler will refuse to even attempt to compile your application unless every dependency in your project supports the current version.

If such an abandonment scenario takes place with single module library that has 150 lines of code, maintaining that library will likely be quite straightforward. It may not even require any changes, short of a version bump in the package file. But I would stay far away from a library like [elm-mdl](https://github.com/debois/elm-mdl), a material design implementation in Elm, which contains 10,000 lines of Elm code. If your application becomes highly dependent on such a library, and the maintainer stops supporting it, you will have to make the decision between forking the library and maintaining it on your own, or never upgrading to the newest version of Elm.

### In Elm, doing what might seem hard can actually be quite easy, and the inverse is also true

All of Elm's unique features often come together to produce a language that often flips the definitions of 'easy task' and 'difficult task' on their heads.

* Want to add a new possible value to one of your union types, which will necessitate changes to the code in dozens of places in your application? Easy, just start by changing your type definition and the compiler errors will help you find everywhere that needs updating.

* Want to decode some JSON? Hard, especially if the JSON is heavily nested and it must be decoded to custom types defined in your application. Doing this will require an understanding of how JSON decoding works in Elm and will usually result in quite a bit of code (our application contains over 900 lines of JSON decoders alone).

* Want to create multiple different views in your application that each have complex data interdependencies? Easy, The Elm Architecture's Model-View relationship make this type of thing almost trivial to do. It will also be almost impossible for the data to get out of sync across different views.

* Want to measure the height of an element on the page at the moment a user clicks on it? Hard, in order to do this we had to make heavy use of event bubbling and writing JSON decoders for the native `event.target` object that is produced by an `onclick` event.

Generally speaking, however, the trade off is worth it. The easy tasks that become difficult usually do so because you gain some sort of benefit (such as type safety) as you do them in Elm. The difficult tasks that become easy usually result in massive productivity and reliability gains, particularly as an Elm application reaches large sizes. Our 22,000 line Elm application is easier to refactor than our 5,000 line jQuery-based application by a wide margin. The Elm application will age well, only becoming more reliable and performant as we make improvements and add features over time. The jQuery-based one will not, and will be slated for replacement when its limitations become too prominent.

## Conclusion

Using Elm in production has been a been a very successful endeavor at Roompact. Our latest project, with a front end written solely in Elm, has exceeded all expectations, both those of our users as well as our own. We have managed to take a set of functionality that would have been exceptionally difficult to build using our old methods, and using the strengths of the Elm language and architecture, successfully developed the largest feature in our entire software product to date. All of this done with a very high degree of maintainability and reliability. This post has been a record of our experiences with Elm up to this point.

The decision to use Elm for the first time was difficult due to the risks associated with the unknowns that would come with a departure from normalcy. The decision to continue using Elm will not be.
