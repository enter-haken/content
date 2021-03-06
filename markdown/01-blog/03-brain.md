---
created_at:  "2020-05-11"
---

# brain

When you develop software, you also have to look up things frequently.
This can be a Google search, or a confluence / jira lookup, read a blog post or a news article.
During your look up you connect informations.

The more information is linked, the better you can remember it.
This is how our brain is working. 

If you have a similar problem a few months later, you repeat your look up.
Maybe you can remember some steps, but not all of them. 

This is where [brain][1] and [memories][2] comes into play.

<!--more-->

I start with an example to demonstrate this.

If I  want do lookup `hex.pm` in my `memories`, I get a result with 

![hexpm](/images/hex.pm.png)

I can see there is a connection to `phoenix`, so I can lookup `phoenix` as well.

![phoenix](/images/phoenix.png)

Ok, there is a connection to `gdscript`. 

![gdscript](/images/gdscript.png)

Now you have left the elixir space, and have entered the game engine space.
This is helping, when you want to think outside the box.

Every time you lookup something, you get a more or less dense overview about a topic. 

If you are searching for example for `package`,

![package](/images/package.png)

the result will contain more matches, but you can narrow it down more easily.
As you can see there are islands of memories, which are not connected til now.

If you want to make a connection you have to start a research again.

# how does this works

The basis for this are [adjacency lists][3].
In my prototype, I use markdown documents like

    ```
    id: bfb53060-3b64-11ea-855e-872de3eb04d1
    title: elixir
    links:
      - 1c4ddc26-3b6c-11ea-8a1f-d3bd2d7b8f9d
      - 7425e5ec-3b6c-11ea-ab66-339bddb9d6ee
      - 1fbb1e40-3b6d-11ea-a667-77559ebd764b
    tags:
      - elixir
    ```

    BEAM based functional language.

The first comment section is used for `metadata`.

The `id` is uniq for every memory, so it can be referenced within other memories.
You can reference other memories via `links`.
You can also use `tags`, if you only want to find tagged `memories`.

A search will find all memories, containing a `search string`, and their next links.
My first experiences with this `full text search` looks promissing.

You can [configure][4] multiple paths for your `memories`, so you can have **own memories** and for example **company memories** which are only used for work.

So you can merge multiple sets of `memories` into one big `memory`.

Currently the markdown documents are created with a texteditor. 
I am playing arount with ideas, to build a propper frontend for `brain`

If you like to know more about this, you can take a look at the sources for [brain][1] and [memories][2].

[1]: https://github.com/enter-haken/brain
[2]: https://github.com/enter-haken/memories
[3]: https://en.wikipedia.org/wiki/Adjacency_list
[4]: https://github.com/enter-haken/brain/blob/master/config/config.exs
