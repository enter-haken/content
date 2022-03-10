# outside vim

When you get used to the **vim key bindings** you might want to use it in other places. 

<!--more-->

## bash 

First of all you should set your default editor in your `~/.bashrc` to

```
export EDITOR=nvim
```

so it can be used, everytime when the default editor is requested, like `git commit -va`.

For bash itself you should activate the **vim-mode**

```
set -o vi
```

From now on your bash typing skills will **get on speed**.

## packages

There are some packages which are using vim key bindings

| package | description                 |
|---------|-----------------------------|
| less    | show text files             |
| ranger  | file system browser         |
| tig     | text mode interface for git |
| evince  | pdf viewer                  |

## browser 

There is a plugin called **vimium** available for [firefox][1] and [chrome][2], which brings your browsing capabilities up to a next level.

[1]: https://addons.mozilla.org/de/firefox/addon/vimium-c/
[2]: https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
