---
created_at: "2016-05-11"
---

# days left 

After almost four years, I am moving on towards a new job. 
Removing the german holydays, weekends and vacations, there are only 23 working days left. 

This is not very much time, considering the work, which have to be completed before I leave.
So I decided to build something simple to direct my attention to the last days.

<!--more-->

I currently running a [Gentoo][1] system with [dwm][2] as a window manager.
My *.xinitrc* looks like this: 

```
xscreensaver &
(conky | while read LINE; do xsetroot -name "$LINE"; done) &
exec dwm
```

[conky][3] is one way to update the root window in a specific intervall.
Now I need a little programm, that returns my last working days.
After a little [python magic][4] my *.conkyrc* looks like this:

```
update_interval 60.0

TEXT
${exec daysLeft -d 2016-06-17 -w -e 2016-05-18 2016-05-27 2016-05-16 2016-05-26 } working days left | ${exec oneLineStatus} | ${exec date "+%d.%m.%Y %R"}
```

I think, the [first version][5] is all I need, to keep fokus on the last days of my current job.

<blockquote class="twitter-tweet" data-lang="de"><p lang="en" dir="ltr">the days are counted... <a href="https://t.co/QYpCi9HG7B">pic.twitter.com/QYpCi9HG7B</a></p>&mdash; Jan Frederik Hake (@enter_haken) <a href="https://twitter.com/enter_haken/status/730390519705128962">11. Mai 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[1]: https://gentoo.org
[2]: http://dwm.suckless.org
[3]: https://github.com/brndnmtthws/conky
[4]: https://github.com/enter-haken/daysleft
[5]: https://twitter.com/enter_haken/status/730390519705128962 
