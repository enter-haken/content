---
created_at:  "2020-06-20"
---

# letter

I recently had to write a letter to a government agency.
With no office suite installed, I took a look to my installed packages and found [pandoc][1].
With pandoc you can transform documents, with a variety of input and output formats.
It is the question, if I can use this package to create a letter.

<!--more-->

The easiest invocation of `pandoc` can look like

```
$ pandoc document.md -o document.pdf
```

The pandoc processor detects the output format by it's extension.
Without any additional parameter, it uses a standard template.

![letter][2]

You can create `Latex` templates and place them at `~/.pandoc/templates`.
You can use your templates with an aditional parameter.

```
$ pandoc document.md -o document.pdf --template="letter"
```

How does a letter template look like?

```
\documentclass[
    foldmarks=true,      % print foldmarks
    foldmarks=BTm,       % show foldmarks top, middle, bottom
    fromalign=right,     % letter head on the right
    fromphone,           % show phone number
    fromemail,           % show email
    fromlogo,            % show logo in letter head
    version=last,        % latest version of KOMA letter
    paper=a4,
    pagesize,
    firstfoot=false,
    pagenumber=false
]{scrlttr2}

\usepackage[ngerman]{babel}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}

\usepackage{parskip}

\usepackage{graphics}

\usepackage{booktabs}
\usepackage{longtable}

\usepackage[right]{eurosym}

\makeatletter
    \setlength{\@tempskipa}{-1.2cm}%
    \@addtoplength{toaddrheight}{\@tempskipa}
\makeatother

\setlength{\oddsidemargin}{\useplength{toaddrhpos}}
\addtolength{\oddsidemargin}{-1in}
\setlength{\textwidth}{\useplength{firstheadwidth}}

\begin{document}
    \setkomavar{fromname}{$author$}
    \renewcommand*{\raggedsignature}{\raggedright}
    \setkomavar{fromaddress}{
        $for(return-address)$
            $return-address$$sep$\\
        $endfor$
    }
    \setkomavar{fromphone}{$phone$}
    \setkomavar{fromemail}{$email$}
    \setkomavar{signature}{$author$}

    \setkomavar{date}{$date$}
    \setkomavar{place}{$place$}

    \setkomavar{subject}{$subject$}

    \begin{letter}[enlargefirstpage=true]{%
        $for(address)$
            $address$$sep$\\
        $endfor$
    }

        \opening{$opening$}

        $body$

        \enlargethispage{5cm}

        \closing{$closing$}

        \ps $postskriptum$

        $if(encludes)$
            \setkomavar*{enclseparator}{Anlage}
            \encl{$encludes$}
        $endif$
    \end{letter}
\end{document}
```

This looks like a `Latex` file with some placeholders starting with a dollar sign.
This are variables, which are defined within the markdown docoument.

```
---
autor: Jan Frederik Hake
phone: +49 12345 
email: jan_hake@gmx.de 
date: 20.06.2020
place: Dortmund
subject: Lorem 
return-address:
  - 123 Random Street 
  - 12345 German Town 
address:
  - John Doe 
  - 123 Fake Street
  - 54321 German Vilage 
opening: Dear Sir or Madam, 
closing: With kind regards 
---

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
```

The metadata is described as  `yaml`. 

![letter][3]

This looks good. You can hardwire your address into the template, so you don't have to repeat your own address data.


For the ease of use I create a folder for every document with a simple `Makefile` like

```
default: all 

build:
  pandoc document.md -o document.pdf --template="letter" --verbose

run:
  evince document.pdf

all: build run
```

You don't need a full blown office suite, if you just want to write a letter.


[1]: https://pandoc.org/
[2]: /images/letter01.png
[3]: /images/letter02.png
