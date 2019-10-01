title: "Test of a first article"
authors: "Théo Winterhalter", "Some Other"
date: 29/09/2019
----------------------------------------
Welcome on Galliblog the Gallinette blog. I use the amazing [omd]
markdown parser, and bits of parsing that I did myself.
This is very much work in progress as of yet, but thanks to the power of
[omd] you can already write pretty cool articles, simply.

[omd]: https://github.com/ocaml/omd

## Testing some code

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

## What's next

- Syntax highlighting
- Making the whole blog engine
- `jscoq`!
- Some css
- Handle default language for inline and such
