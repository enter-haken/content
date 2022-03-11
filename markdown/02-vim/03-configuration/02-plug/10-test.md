# vim-test

Software testing is an **essential part of software development**. 
Before **vim-test**, you had to switch to another terminal to run tests there.

**vim-test** gives you the option to run tests **from inside vim**.

<!--more-->

## configuration

Using **neoterm** as a test environment gives you the option to always
run the test at the location for which **neoterm** is configured.

```
let test#strategy = "neoterm"
```

If you have a test file open, you can press

```
nmap <silent> <leader>rt :TestNearest<CR>
```

to run a test **under the cursor**.

If you want to **run all tests** from the **currently active buffer**, you can press

```
nmap <silent> <leader>rT :TestFile<CR>
```

You can also **run the entire test-suite** with

```
nmap <silent> <leader>ra :TestSuite<CR>
```

If you want to navigate to the **last executed test** you can do

```
nmap <silent> <leader>rg :TestVisit<CR>
```

This switches to the buffer with the test file and sets the cursor to the **last executed test**.

## installation

```
Plug 'vim-test/vim-test'
```

## further reading

- [vim test - git repository][1]

[1]: https://github.com/vim-test/vim-test
