# nerdtree

During development you need to access the filesytem **on a convinient way**. 
[NERDTree][1] solves this problem.

<!--more-->

## Navigation 

`?` will **toggle a help page**.

These are some shortcuts, I use frequently.

With the `m` key you **can manupilate** the filesystem.

```
NERDTree Menu. Use j/k/enter, or the shortcuts indicated
=========================================================
> (a)dd a childnode
  (m)ove the current node
  (d)elete the current node
  (r)eveal the current node in file manager
  (o)pen the current node with system editor
  (c)opy the current node
  print (p)ath to screen
  (l)ist the current node
  Run (s)ystem command in this directory
```

If you add a childnode with preceding slash, a directory is created.

You can press `r`, to **reload** the current filesystem view.
Pressing `C` will set up a new root.
You can open the file tree **recursively** by pressing `O`, 
but beware, if you have many sub directories (like home), **this operation can crash vim**.

## configuration

First of all, hidden files, like dot files should be visible

```
let NERDTreeShowHidden=1
```

To toggle the file tree buffer, you can use a shortcut for quick access.

```
nmap <Leader>n :NERDTreeToggle<CR>
```

If you have a file open in a buffer,

```
nmap <Leader>f :NERDTreeFind<CR>
```

will open NERDTree at the position of the file.
This is usefull, if you have opened two files in different projects. 
Every time you press `<Leader>f`, you will get to the right position in every project.

## install

```
Plug 'preservim/nerdtree'
```


[1]: https://github.com/preservim/nerdtree
