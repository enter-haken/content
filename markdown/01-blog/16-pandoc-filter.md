---
created_at: "2017-02-20"
---

# using pandoc filters to create graphs with hakyll

When you want to convert one document format into an other, [Pandoc][1] is your friend. 
[Hakyll][2] is using it for converting Markdown into HTML. 
Once installed (eg. via cabal / stack) you can call pandoc from command line.

```
$ echo "# test" | pandoc -t native
[Header 1 ("test",[],[]) [Str "test"]]
```

This simple example shows the native format.
A list of definitions can be found at [Hackage][3].
Every document format read is converted into this native format. 
It is the pandoc internal representation of the document.

```
$ echo "# test" | pandoc -w html
<h1 id="test">test</h1>
```
You can get a html output as well. 
A [pandoc filter][4] can be used to inject a custom behavior between reading and writing a document. 
This feature is needed to write filters to work with Hakyll

<!--more-->

At first I have to look, how to get a graph, more precisely the graph visualization into the Haskell world.
Due to my input comes from a markdown document, it will be plain text.
The simple approach is to call the external `dot` process with this `String` and read the result.
If a library is needed for further implementation this part can be switched out.

```
import System.Process

graph = "digraph { a -> b; b -> c; a -> c; }"

main :: IO()
main = do
    svg <- readProcess "dot" ["-Tsvg"] graph
    putStr svg 
```

In this example you can pipe a `String` to an external process and get a result as a `String IO`.

```
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"
 "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<!-- Generated by graphviz version 2.38.0 (20140413.2041)
 -->
<!-- Title: %3 Pages: 1 -->
<svg width="89pt" height="188pt"
 viewBox="0.00 0.00 89.00 188.00" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
<g id="graph0" class="graph" transform="scale(1 1) rotate(0) translate(4 184)">
<title>%3</title>
<polygon fill="white" stroke="none" points="-4,4 -4,-184 85,-184 85,4 -4,4"/>

...

<g id="edge2" class="edge"><title>b&#45;&gt;c</title>
<path fill="none" stroke="black" d="M33.3986,-72.411C36.5136,-64.3352 40.3337,-54.4312 43.8346,-45.3547"/>
<polygon fill="black" stroke="black" points="47.1265,-46.5458 47.4597,-35.9562 40.5955,-44.0267 47.1265,-46.5458"/>
</g>
</g>
</svg>
```

This looks promising. 
I choose `svg`, because it can be easily integrated into a html document.

At first a create a simple environment for testing. 
I use a `index.html` as a simple template,

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>hakyll test</title>
    </head>
    <body>
       <div id="content">
            $body$
        </div>
   </body>
</html>
```

and a `index.markdown` with some test data.

    # hallo
    
    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
    
    ```
    codeblock
    ```
    
    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam
    
    ```{lang="dot"}
    digraph graphName { a -> b; b -> c; a -> c; }
    ```

A hakyll main function can look as following.

```
{-# LANGUAGE OverloadedStrings #-}
import Hakyll

main :: IO ()
main = hakyll $ do
    match "index.markdown" $ do
        route $ setExtension "html"
        compile $ pandocCompiler 
            >>= loadAndApplyTemplate "template.html" defaultContext

    match "template.html" $ compile templateCompiler
```

This function will create a single `index.html` in the output folder.
The interesting part here is the `pandocCompiler`. 
There is a [derived compiler][5] `pandocCompilerWithTransform` which allows you to specify a transformation for the given content.
Given the type signature `pandocCompilerWithTransform :: ReaderOptions -> WriterOptions -> (Pandoc -> Pandoc) -> Compiler (Item String)`, I have an entry point for the filter.
I need something that takes a `Pandoc` and returns a `Pandoc`.

```
graphViz :: Pandoc -> Pandoc
graphViz = walk codeBlock

codeBlock :: Block -> Block
codeBlock (CodeBlock _ contents) = Para [Str contents]
codeBlock x = x
```

The [walk function][6] is used to do something with a specified Pandoc structure.
For the filter it is a `CodeBlock` to look for. 
This example converts all `CodeBlock`s into paragraphs.

At this point I need the `String` representation of the dot lang graph. 

```
svg :: String -> String
svg contents = unsafePerformIO $ readProcess "dot" ["-Tsvg"] contents
```

[unsafePerformIO][7] is a kind of 'backdoor'. 
It should be used only with care. 

With the new walker,

```
codeBlock :: Block -> Block
codeBlock cb@(CodeBlock (id, classes, namevals) contents) = 
    case lookup "lang" namevals of
        Just f -> RawBlock (Format "html") $ svg contents
        nothing -> cb
codeBlock x = x
```

I can call the custom compiler with the `graphViz` function.


```
pandocPostCompiler :: Compiler (Item String)
pandocPostCompiler = pandocCompilerWithTransform
    defaultHakyllReaderOptions
    defaultHakyllWriterOptions
    graphViz
```

Putting it all together

```
{-# LANGUAGE OverloadedStrings #-}
import Hakyll
import Text.Pandoc
import Text.Pandoc.Walk ( walk )

import System.Process ( readProcess )
import System.IO.Unsafe ( unsafePerformIO )

main :: IO ()
main = hakyll $ do
    match "index.markdown" $ do
        route $ setExtension "html"
        compile $ pandocPostCompiler 
            >>= loadAndApplyTemplate "template.html" defaultContext

    match "template.html" $ compile templateCompiler

pandocPostCompiler :: Compiler (Item String)
pandocPostCompiler = pandocCompilerWithTransform
    defaultHakyllReaderOptions
    defaultHakyllWriterOptions
    graphViz

graphViz :: Pandoc -> Pandoc
graphViz = walk codeBlock

codeBlock :: Block -> Block
codeBlock cb@(CodeBlock (id, classes, namevals) contents) = 
    case lookup "lang" namevals of
        Just f -> RawBlock (Format "html") $ svg contents
        nothing -> cb
codeBlock x = x

svg :: String -> String
svg contents = unsafePerformIO $ readProcess "dot" ["-Tsvg"] contents
```

This code transforms a markdown document into html and converts all codeblocks with a `lang` tag into a svg version of the given graph. At this point, I don't use the value of `lang`. It is possible to implement a different behaviour for other tags or different values.

See the [result][8] or check out the [code][9], if you like it.
                    
[1]: https://jaspervdj.be/hakyll/
[2]: http://pandoc.org/
[3]: http://hackage.haskell.org/package/pandoc-types-1.17.0.5/docs/Text-Pandoc-Definition.html
[4]: http://pandoc.org/scripting.html
[5]: https://hackage.haskell.org/package/hakyll-4.9.5.1/docs/Hakyll-Web-Pandoc.html#g:2
[6]: https://hackage.haskell.org/package/pandoc-types-1.19/docs/Text-Pandoc-Walk.html
[7]: http://hackage.haskell.org/package/base-4.9.1.0/docs/System-IO-Unsafe.html#v:unsafePerformIO
[8]: /example/pandoc/dotlang/index.html
[9]: https://github.com/enter-haken/hakyll-dot-demo