title: "Test of a first article"
authors: "Théo Winterhalter", "no one else"
date: 29/09/2019
----------------------------------------
Welcome on Galliblog the Gallinette blog. I use the amazing [omd]
markdown parser, and bits of parsing that I did myself.
This is very much work in progress as of yet, but thanks to the power of
[omd] you can already write pretty cool articles, simply.

If you want to write markdown, this [cheatsheet] can be useful.
Be careful that [omd] doesn't implement github flavoured markdown though.
For instance, there is no strikethrough. But if there is a huge demand I can
try to add it in.

## Testing some code

Inline code like `let x := 1 in x` doesn't have any language affected to it,
_unless_ the `default language` is set in the header.
(Note that it will set all inline codes and all block codes where the language
is not specified.)

```
default language: coq
```

```coq
Lemma foo : forall n : nat, n = n.
Proof.
  intro n. reflexivity.
Qed.
```

```ocaml
let rec foo n =
  if n < 1 then 0 else foo (n - 1)
```

## Jscoq

To use [jscoq], you need to specify which version you want to load in the
header.
```
jscoq: v0.9.3
```
For the moment `v0.9.3` is the only option (not even an option at this point).

## What's next

- Syntax highlighting.
- Making the whole blog engine.
- `jscoq`!
- Some css.
- Table of contents (since [omd] seem to provide it).
- Collect references to put at the end?
- Update date
- Tags
- Search (when it becomes necessary)
- Generating the whole galinette website
- Deal with possible `index.md`.

[jscoq]: https://github.com/ejgallego/jscoq
[omd]: https://github.com/ocaml/omd
[cheatsheet]: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
