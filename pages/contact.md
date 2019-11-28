---
title: Contact
---

<div class="content-body">

Interested in getting in touch? Feel free to contact me using any of the methods below. I have expertise in:

- Growing a software development team in a SaaS company/startup.
- Selecting tools and programming languages for software projects.
- Using functional programming commercially, including evaluating trade-offs.
- Teaching technical skills both to experienced programmers as well as novices.

#### Contact Methods

<div class="contact">
<noscript>
<style>#mail-wrap{ display: none; }</style>
<div title="Email"><i class="fa fa-envelope"></i>&nbsp;ch&nbsp;[dot]&nbsp;cz&nbsp;[at]&nbsp;pm&nbsp;[dot]&nbsp;me</div>
</noscript>
<div title="Email" id="mail-wrap"><a><i class="fa fa-envelope"></i>&nbsp;ch…</a>&nbsp;<button>Click to Reveal</button></div>
<div title="GitHub"><a href="https://github.com/charukiewicz"><i class="fa fa-github"></i>&nbsp;charukiewicz</a></div>
<div title="Twitter"><a href="https://twitter.com/charukiewicz"><i class="fa fa-twitter"></i>&nbsp;@charukiewicz</a></div>
</div>

</div>

<script>
    var emNode = document.getElementById('mail-wrap');
    function revealEm() {
        var emComp1 = "ch.cz";
        var emComp2 = "@";
        var emComp3 = "pm.me";
        var em = emComp1 + emComp2 + emComp3;
        emNode.innerHTML = '<a href="mailto:' + em + '"><i class="fa fa-envelope"></i>&nbsp;' + em + '</a>'
        if(typeof ga == "function") {
            ga('send', 'event', 'contact_page', 'contact_info', 'show_email', null);
        }
    }
    emNode.addEventListener('click', function() { revealEm() });
</script>
