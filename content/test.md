title: "Test of a first article"
authors: "Théo Winterhalter", "Some Other"
date: 29/09/2019
----------------------------------------
This article is a test where I try everything I can do with my blog engine,
Galliblog!

This should be a new paragraph.
While this should not.

# This is a header (the big kind)

**bold**

**bold
on two lines**

**bold


on a lot of lines**
(So it's ok if I don't handle this)

*aaaa **bbbb* cccc**
Yay, they have to be nested!

  # Still a header

    # Not a header

1. Stuff on a list
Still in the same item.

No longer a list

2. We can resume with a 2 (probably just creates a new list though)
3. We can skip a line
3. If we repeat numbers it's ignored

3. Even if we do 2 newline

10. Numbers are completely ignored

Lalala

17. Now it's a new one.

1. Only the first number counts
  67. Sublist
  - Is it a sub sub list?
  68. Weird
    19. New
    1. One

- List wish -
* Can be continued with *

a. Wow
b. Letters aren't lists

```bash
echo "hello"
```

 ```C
printf("hello");
 ```
  ```ocaml
  print_string "hello"
  ```

   ```coq
   let x = 0 in x
   ```

    ```coq
    let x = 0 in x
    ```
    With 4 spaces we are in a quotation, deal with that first!

    ddz

Stuff

     Still a quote (with a leading space)
    Ok

    Can skip a line


    Even two




    Even more

I can also use *emphasis* and **bold** fonts. Also ~~strikethrough~~.
They can even be ***~~combined~~***.

## Header
Not a header

    1. stuff
    1. not a list

1. list
  2. subst list
    3. sub sub list


1. Stuff
   Still on the list
Still also

## Things I stole from [adam-p on github](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links)

[I'm an inline-style link](https://www.google.com)

[I'm an inline-style link with title](https://www.google.com "Google's Homepage")

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[I'm a relative reference to a repository file](../blob/master/LICENSE)

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself].

URLs and URLs in angle brackets will automatically get turned into links.
http://www.example.com or <http://www.example.com> and sometimes
example.com (but not on Github, for example).

Some text to show that the reference links can follow later.
Note that references need a line before them!

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com

# Things to do

We should handle lists, images, tables, maybe even videos, syntax highlighting,
and jscoq.
All of it would be great!
