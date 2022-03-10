# basis setup 

Before setting up any plugins, you should take a look at your base vim settings.

<!--more-->

The first line will choose the prevered colorscheme.
In my case it is [nord][1].

```
colorscheme nord
```

To have a kind of **custom namespace** for your own keyboard shortcuts, you can define a
a leader key.
The default is set to `\`

```
let mapleader=','
```

To set the current file in the buffer as the **window title** you can do a

```
set title
```

You get **line numbers in front of each line** by setting

```
set number
```

When you want to **search case insensitive** within a buffer, you set

```
set ignorecase
set incsearch
set ignorecase
set smartcase
```

For German Umlaute, you need

```
set termencoding=utf8
set enc=utf8
set fileencoding=utf8
```

Tab stops may vary by projects, and have to be overridden on project base.

```
set tabstop=2
set softtabstop=2
set shiftwidth=2
```

Start next line with the same ident.

```
set autoindent
```

Replace tabs with spaces

```
set expandtab
```

Disable swap files

```
set noswapfile
set nobackup
set nowritebackup
```

No need for folding

```
set nofoldenable
```

When you want to switch buffers without saving, you need to set.

```
set hidden
```

This becomes handy, when you have some buffers with no file in the background,
for example some text comming from an external command like `read !tree` or so.

These are **not so many changes** to the original vim configuration.

Of course you can set up a more detailed configuration, but you have to keep in mind, that you have to do some gardening over time.

[1]: https://github.com/arcticicestudio/nord-vim
