# neoterm

NeoVim comes with an build in terminal.
When you want to **reuse the same terminal**, you can use neoterm.

<!--more-->

You can open a new Terminal with `Tnew`, and close it with `Tclose`. If a terminal is open you can attach to the terminal by pressing `a`. Wenn you want to leave the terminal focus, you have to press `<C-\><C-n>`.

It is also possible to run a command when opening a terminal by `:T {command}`.

## configuration

I mainly use the build in terminal for unit testing.
So I setup neoterm to open **at the bottom** with a **size of 20 lines**.

Unit tests are producing a lot of lines, so I set up neoterm with autoscroll.

```
let g:neoterm_size='20'
let g:neoterm_default_mod = 'botright'
let g:neoterm_autoscroll = 1
let g:neoterm_keep_term_open = 1
```

## installation

```
Plug 'kassio/neoterm'
```

## further reading

* [neoterm git repository][1]

[1]: https://github.com/kassio/neoterm
