# template

A template is used for every generated html file.

## variables

The following data can be used within every template.

### body

The **body** contains all html data of the markdown source.

When you place a

```
<!-- more -->
```

within the markdown document, everything before this comment will be treated as an **teaser**.

This **teaser** will be added to **the first document** in the folder.


### title

The **title** is the first **h1 tag** of the markdown document.

### breadcrumb

A list containing all the documents the way up to the root document.

### siblings

Every document in the same folder.


[1]: https://hexdocs.pm/eex/EEx.html
