---
created_at:  "2020-05-11"
---

# relaunch

It has been a while, since I launched my blog on [github][1].
Meanwhile I have rented a baremetal server at [Hetzners server auction][2]. 
It took me a few months to breathe life into the server. 

It has

* 3TB hard disks (RAID 1)
* 32GB memory
* Intel Core-i7 CPU

fine for me. 

I could have used my old [engine][3], but I decided to put my blog on new feets.

<!--more-->

Starting a blog on github is almost a [no brainer][4].
You create a repository with `*username*.github.io`, and put HTML content into it. 
Static content will be available from now on.

There are some [restrictions][5] like

* maximum of 1GB disk size
* maximum of 100GB traffic per month
* soft limit of 10 builds per hour

I think, I didn't hit those limits once.

## So why the relaunch?

First of all it has become a static website again. 
Every site you see is based on a single template.

The blog has become more of a second class citizen. 
This does not mean I won't write any blog posts any more.
I just want to write more about craftsmanship, in a more book like manner.

A few months a go, I also booked `hake.one`, with several goals.

First of all, I want to serve my content (you're just reading)
In the second step, my experients, which needs also an backend, should be available under this domain. 

The stack at the beginning is quiet simple.


```{lang=dot}
digraph {
   node [ fontname="helvetica",style="filled,rounded",color=white,shape=box];
   edge [fontname="helvetica", fontsize=10 ];

   outside -> nginx [label = < request >];
   nginx -> book [label = < sites_enabled >];
   nginx -> applicationA [label = < sites_enabled >];
   nginx -> applicationB [label = < sites_enabled >];

   book -> book_container [label = < proxy_pass >];
   applicationA -> applicationA_container [label = < proxy_pass >];
   applicationB -> applicationB_container [label = < proxy_pass >];

   outside [label = < <b>outside world</b> >];
   nginx [label = < <b>nginx</b> >];

   book [label = < https://hake.one >];
   applicationA [label = < https://app-a.hake.one >];
   applicationB [label = < https://app-b.hake.one >];

   book_container [label = < http://*ip*:*port*<br />container >];
   applicationA_container [label = < http://*ip*:*port*<br /> container >];
   applicationB_container [label = < http://*ip*:*port*<br /> container >];

}
```

[1]: https://enter-haken.github.io
[2]: https://www.hetzner.com/sb  
[3]: https://github.com/enter-haken/blog
[4]: https://pages.github.com/
[5]: https://help.github.com/en/github/working-with-github-pages/about-github-pages#usage-limits
