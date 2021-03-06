---
created_at:  "2018-02-19"
---

# Alternative content management system approach

In the last months, I had to manage a bigger Wordpress instance with many plugins installed.
It is a kind of mess.
Plugins affecting each other.
Different look and feel.
Different UX.
Plugins which must not be plugins, solving caching issues for example.
The site [CMS Garden][cms_garden] shows several approaches.

I would like to think of a CMS like an application platform, let's call it `rasmus`, where there plugins can be understood as a separate application.
Accepting the challenge, I start something new.

At first, let's start small and build a scaffold for the application platform.
You can imagine this like a fast food restaurant.

```{lang=dot}
digraph {
    rankdir=LR;

    node [fontname="helvetica"];
    graph [fontname="helvetica"];
    edge [fontname="helvetica"];

    subgraph cluster_0 {
        style=filled;
        color=lightgrey;
        node [style="filled,rounded",color=white,shape=box];
        label="internet";
        
        client1 -> web;
        client2 -> web;
        client3 -> web;
    }
 
    subgraph cluster_1 {
        style=filled;
        color=lightgrey;
        node [style="filled,rounded",color=white,shape=box];
        label="counter";

        subgraph cluster_2 {
           style=filled;
           color=white;
           node [style="filled,rounded",color=lightgrey,shape=box];
           transfer -> user;
           user -> role;
           label="core";
        }

        subgraph cluster_3 {
           style=filled;
           color=white;
           node [style="filled,rounded",color=lightgrey,shape=box];
           transfer -> content;
           label="cms";
        }

        subgraph cluster_4 {
           style=filled;
           color=white;
           node [style="filled,rounded",color=lightgrey,shape=box];
           transfer -> lms;
           label="lms";
        }

        subgraph cluster_5 {
           style=filled;
           color=white;
           node [style="filled,rounded",color=lightgrey,shape=box];
           transfer -> forum;
           label="forum";
        }

        web -> transfer;
    }

    subgraph cluster_6 {
        style=filled;
        color=lightgrey;
        node [style="filled,rounded",color=white,shape=box];
        label="behind the counter";
        labelloc="b";

        content -> bl;
        lms -> bl;
        forum -> bl;
    }
 
    transfer [ label = "transfer\ntable"];
    content [ label = "content\nrelations"];
    user [ label = "user\nmanagement"];
    role [ label = "role\nmanagement"];

    lms [ label = "lms\nmanagement"];
    forum [ label = "forum\nmanagement"];

    web [ label = "web\nbackend" ];
    bl [ label = "database backend"];
    client1 [ label = "web client" ];
    client2 [ label = "web client" ];
    client3 [ label = "web client" ];
}
```

You put your request at the `counter` and behind the `counter` the magic happens. 
The worker behind the `counter` must not know how a burger is made, and how many fries must be in a fryer.
He sees the current orders on a screen, and put the meals together, when the separate parts are ready.
When the order is ready, the customer can be served.

<!--more-->

# Architectural overview

As you can see the database take a place in the middle. 

As mentioned in the [database architecture series][dbArchitecturePart3] the `web backend` can put a request in the database `transfer` table. 
This is the only table, which can be accessed by the `web backend`. 
After a request is processed, the result is put back into the `transfer` entity.
The database sends a [notification][notify] to the `web backend`, which can pull the response from the database.
This represents a very thin interface to database.
This approach leads to less security issues, because more database related functions are hidden from the `web backend`.

# The database

Every application's heart is it's database.
`rasmus` is no exception.
An `rasmus` application has it's own schema within the database.
The schemes look as following.

## The core

The different `rasmus` applications share a `core`.
Here you can find functions, used across all applications, like user and role management.

First start with a simple user / role management approach.

    CREATE TABLE user_account(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        first_name VARCHAR(254),
        last_name VARCHAR(254),
        email_address VARCHAR(254),
        password VARCHAR(254),
        login VARCHAR(254),
        signature VARCHAR(254)
    );

For the time being, we store the `password` with the user. 
This field can be moved later on, when different authorization methods will be introduced.

Starting with a simple role definition,
    
    CREATE TYPE role_level AS ENUM ('admin','user','guest');
    
    CREATE TABLE role(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(254) NOT NULL,
        description VARCHAR(254),
        role_level role_level NOT NULL DEFAULT 'guest'
    );

`user`s can have several roles.
    
    CREATE TABLE user_in_role(
        id_user_account UUID NOT NULL REFERENCES user_account(id),
        id_role UUID NOT NULL REFERENCES role(id),
        PRIMARY KEY(id_user_account, id_role)
    );

Every part of an `rasmus` application can be associated with a `privilege`
    
    CREATE TABLE privilege(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(80),
        description VARCHAR(254)
    );
    
Each `privilege` can be assigned to a `role`.

    CREATE TABLE role_privilege(
        id_role UUID NOT NULL REFERENCES role(id),
        id_privilege UUID NOT NULL REFERENCES privilege(id),
        PRIMARY KEY (id_role, id_privilege)
    );

These are the minimal relations for user and role management storage.

## transfer

The `transfer` relation is located in the `core` schema.
It uses the following state definitions.

    CREATE TYPE transfer_status as ENUM (
        'pending',
        'processing',
        'succeeded',
        'succeeded_with_warning',
        'error'
    );

This is not carved into stone. 
It will fit the first requirements to a stateful exchange between the `web backend` and the database.

The `transfer` relation itself looks like

    CREATE TABLE transfer(
    	id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        status transfer_status NOT NULL DEFAULT 'pending',
        request JSONB NOT NULL,
        result JSONB
    );

Per default, every request is a `pending` request.
A `transfer` entity must have at least a request body.

At this point conventions have to be made.
A request must contain

* a `schema` field 
* the name of the `entity`
* the actual `payload`
* and the `action` to perform.

After a request is inserted into `transfer`,

    CREATE FUNCTION transfer_trigger() RETURNS TRIGGER AS $$
    BEGIN 
        PERFORM pg_notify(NEW.request->>'schema',NEW.id); 
        RETURN NEW;
    END
    $$ LANGUAGE plpgsql;
    
    CREATE TRIGGER transfer_before_trigger BEFORE INSERT ON transfer
        FOR EACH ROW EXECUTE PROCEDURE transfer_trigger();

a notification is send to the `database backend`.
Pattern matching is used to find the right addressee for the request.
A closer look has to be made, to decide, which operation must be done inside the database, to prevent multiple round trips.

```{lang=dot}
digraph {
    rankdir=LR;

    node [fontname="helvetica",style="filled,rounded",color=lightgrey,shape=box];
    graph [fontname="helvetica"];
    edge [fontname="helvetica"];

    style=filled;
    color=lightgrey;

    web -> database -> bl;
    bl -> database -> web;

    database [ label = "database"];
    web [ label = "web\nbackend" ];
    bl [ label = "database\nbackend"];
}
```

As said before, the business logic is completely separated from the `web backend`.

## cms

A cms starts with an `article`.

    CREATE TABLE article(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        id_author UUID NOT NULL REFERENCES core.user_account(id),
        title VARCHAR(254),
        raw text,
        html text,
        is_visible boolean NOT NULL DEFAULT FALSE,
        is_draft boolean NOT NULL DEFAULT TRUE
    );

The `author` lives in the `core` namespace, and can be used inside the `cms` schema.
The `raw` text is markdown based, the `html` is the generated result.
A new `article` is per default invisible and in draft mode.


Before uploading `attachment`s to the database, the `file_type` has to be set.

    CREATE TYPE file_type AS ENUM (
        'binary',
        'jpeg',
        'png',
        'mp3',
        'mp4',
        'mkv'
    );
    
    CREATE TABLE attachment(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        raw bytea NOT NULL,
        file_type file_type NOT NULL DEFAULT 'binary'
    );

As for now, the binary content is stored within the database.

Every `article` can have multiple attachments. 

    CREATE TABLE article_attachment(
        id_article UUID NOT NULL REFERENCES article(id),
        id_attachment UUID NOT NULL REFERENCES attachment(id),
        PRIMARY KEY(id_article, id_attachment)
    );

The `attachment`s can be addressed within the `article`s markdown content.

The `cms` provides a tree of `category`s.

    CREATE TABLE category(
        id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
        name VARCHAR(254) NOT NULL,
        description VARCHAR(512),
        icon VARCHAR(1), -- font awesome
        is_active BOOLEAN NOT NULL DEFAULT false,
        is_visible BOOLEAN NOT NULL DEFAULT false,
        LNUM INTEGER NOT NULL,
        RNUM INTEGER NOT NULL
    );

The tree is described as a [nested set][nested_set]. 

An `article` can be assigned to multiple `categories`.

    CREATE TABLE article_in_category(
        id_article UUID NOT NULL REFERENCES article(id),
        id_category UUID NOT NULL REFERENCES category(id),
        PRIMARY KEY(id_article, id_category)
    );

# backend

Having set up the database, it comes for choosing the technology for the backend. 
There are several possibilities choosing the 'right' backend technology.

This will be covered with the next article.

Fell free to browse through the [sources][sources].

[cms_garden]: http://www.cms-garden.org/ 
[dbArchitecturePart3]: /blog/databasearchitectureparttree.html
[notify]: https://www.postgresql.org/docs/current/static/sql-notify.html
[nested_set]: https://en.wikipedia.org/wiki/Nested_set_model
[sources]: https://github.com/enter-haken/rasmus
