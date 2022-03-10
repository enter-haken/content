# Content 

Blog sources for [hake.one](https://hake.one)

## requirements

* [static][1] 

## build

```
$ make
```

will build the whole site.

You can find the result in the `./output` folder.

## preview

When you want to browse a preview of the site you can call

```
$ make serve
```

to start a web server.
You can see the result under `http://localhost:8000`.

## while editing

```
$ make wait
```

will listen to changes of `./markdown` and will **rebuild the whole site** on save.

```
$ make wait_template
```

will listen to changes of `./template/default.eex` and will **rebuild the whole site** on save.

```
$ make wait_css
```

will listen to changes of the `./css` folder and will **rebuild the whole site** on save.

## known issues with the template

* check table formatting
* padding of first line of a code block

## write about 

* nord theme across packages
* terraform 
* docker

## Contact

[hake.one](https://hake.one). Jan Frederik Hake, <jan_hake@gmx.de>. 
[@enter_haken](https://twitter.com/enter_haken) on Twitter. 
[enter-haken#7260](https://discord.com) on discord.

[1]: https://hexdocs.pm/eex/EEx.html
[2]: https://hexdocs.pm/mix/main/Mix.Tasks.Escript.Build.html
[3]: https://hake.one
[4]: https://github.com/enter-haken/content/blob/main/template/default.eex

[1]: https://github.com/enter-haken/static
