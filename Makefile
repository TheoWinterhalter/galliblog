# .PHONY:

gen:
	dune build @src/all --profile release

clean:
	dune clean
