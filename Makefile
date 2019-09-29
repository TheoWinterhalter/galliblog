# .PHONY:

blog: gen
	./_build/default/src/galliblog.exe

gen:
	dune build @src/all --profile release

clean:
	dune clean && \
	rm -rf website
