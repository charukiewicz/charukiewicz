---
title: Contact
---

<div class="content-body">

Interested in getting in touch? Feel free to contact me using any of the methods below. I have expertise in:

- Growing a software development team in a SaaS company/startup
- Selecting tools and programming languages for commercial software projects
- Using functional programming commercially, including evaluating trade-offs
- Teaching technical skills both to experienced programmers and non-programmers

#### Contact Methods

<div class="contact">
<div title="Email" id="mail-wrap"><a><i class="fa fa-envelope"></i>&nbsp;c.ch…</a>&nbsp;<button>Click to Reveal</button></div>
<div title="GitHub"><a href="https://github.com/charukiewicz"><i class="fa fa-github"></i>&nbsp;charukiewicz</a></div>
<div title="Twitter"><a href="https://twitter.com/charukiewicz"><i class="fa fa-twitter"></i>&nbsp;@charukiewicz</a></div>
</div>

</div>

<script>
    var emNode = document.getElementById('mail-wrap');
    function revealEm() {
        var emComp1 = "c.charukiewicz";
        var emComp2 = "@";
        var emComp3 = "gmail.com";
        var em = emComp1 + emComp2 + emComp3;
        emNode.innerHTML = '<a href="mailto:' + em + '"><i class="fa fa-envelope"></i>&nbsp;' + em + '</a>'
    }
    emNode.addEventListener('click', function() { revealEm() });
</script>
