# vim autoformat

Need **a switch army knife for formating source code files**?
Here comes [vim-autoformat][1].

<!--more-->

Many languages are [configured by default][2].
Most languages come with an autoformat capability.

So vim-autoformat can work probably, [python support is needed][3].
You can install the [python support for vim][4] with

```
python3 -m pip install pynvim
```

Additionally the **python host should be set**

```
let g:python3_host_prog='/usr/bin/python3'
nmap <Leader>a :Autoformat<CR>
```

`<Leader>a` gives you a quick access to autoformat.
The current buffer **will be replaced** with the formated content.

## installation

```
Plug 'chiel92/vim-autoformat'
```

[1]: https://github.com/vim-autoformat/vim-autoformat
[2]: https://github.com/vim-autoformat/vim-autoformat#default-formatprograms
[3]: https://github.com/vim-autoformat/vim-autoformat#requirement
[4]: https://github.com/neovim/pynvim
