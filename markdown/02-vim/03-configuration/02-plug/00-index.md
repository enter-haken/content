# plug

When the basic vim configuration is set up, we need to think about **extending vim**.

There are many plugin managers out there.
I use [plug][1] as a plugin manager, because it comes with a simple configuration

<!--more-->

Before you can use plug you have to install it according the [project description][2].

Basically you start with

```
call plug#begin()
```

Then you can add Plugs like

```
Plug '*github_user_name*/*project_name*'
```

and close it with

```
call plug#end()
```

Here are **some plugs** I use on a daily basis.

[1]: https://github.com/junegunn/vim-plug
[2]: https://github.com/junegunn/vim-plug#installation
