# jsonc

Some json files **may contain comments**.
Comments are not **part of the json specification**, so syntax highlighting may show errors.

[jsonc][1] solves this problem.

<!--more-->

jsonc [provides a list][2] of well known json config files.
If one of these files is detected, the **filetype is switched** to **jsonc** to fix the syntax highlighting.

## installation

```
Plug 'neoclide/jsonc.vim'
```

[1]: https://github.com/neoclide/jsonc.vim
[2]: https://github.com/neoclide/jsonc.vim/blob/master/ftdetect/jsonc.vim
