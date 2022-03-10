# plain

You can find **vim** or at least **vi** on almost every unix like systems. 
It may be not installed by default, but can usually be installed very quickly.

Many system tools like **less** have a kind of vim navigation implemented.
Other tools like the file manager **ranger** have **vi key bindings**.

Before we extend vim, let's take a look at some functionalities that are **valid for all** vim installations.

<!--more-->

## exit

First of all press `ESC` to get in **command mode**, enter `:qa` and you're out. 
It sounds a bit funny, but jokes about how to exit vim have been around for decades for a reason.

## modes

The **command mode** let you execute command like **undo**, **redo**, **find** and so on.
The **insert mode** let you enter text.
When you are in **visual mode** you can select select text and do operations on the selection.

## movement

You can use the arrow keys for movement, but I suggest, to **use the vim navigation keys**

* `h` - left
* `j` - down
* `k` - up
* `l` - right

It feels a little bit exhausting the fist time you do it, but when its getting into your **mechanical brain**, you won't want to miss it.

* `CTRL-D` - scroll down half of the screen
* `CTRL-U` - scroll up half of the screen

## geting into insert mode

* `i` - insert text before the cursor
* `a` - insert text after the cursor
* `I` - insert text before the first non-blank in the line
* `A` - insert text at the end of the line

## geting into command mode

Press `ESC`.

## some commands

* `J` - join n lines and remove the indent
* `:[range]s[ubstitude]/{pattern}/{string}/[flags]` - replace text in buffer 
* `:w[rite]` - write buffer to file
* `:x` - write buffer to file and close buffer
* `x` - delete char under cursor
* `:qa` - exit vim if all buffers have been saved
* `:qa!` - exit vim and discard changes

## more

There are more commands to checkout. You can use the `:h commmand` pattern to find out more about every command available in vim.
