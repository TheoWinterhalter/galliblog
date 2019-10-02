# .PHONY:

blog: gen script
	./_build/default/src/galliblog.exe

gen:
	dune build @src/all --profile release

script:
	elm-make Main.elm --output website/elm.js

clean:
	dune clean && \
	rm -rf website

hardclean: clean
	rm -rf elm-stuff
