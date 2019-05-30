---
title: Contact
---

<div class="content-body">

I can be contacted using any of the methods below.

<div class="contact">
<div><a href="https://github.com/charukiewicz"><i class="fa fa-github"></i>&nbsp;charukiewicz</a></div>
<div><a href="https://twitter.com/charukiewicz"><i class="fa fa-twitter"></i>&nbsp;@charukiewicz</a></div>
<div id="mail-wrap"><a><i class="fa fa-envelope"></i>&nbsp;ch…</a>&nbsp;<button>Click to Reveal</button></div>
<div></div>
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
    }
    emNode.addEventListener('click', function() { revealEm() });
</script>
