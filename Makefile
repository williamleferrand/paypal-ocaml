#
# paypal-ocaml 0.2
#

all:
	ocamlbuild src/paypal.cmo

clean:
	ocamlbuild -clean
	find . | grep '~' | xargs rm -rf 

install:
	ocamlfind install paypal META _build/src/paypal.cm*

remove:
	ocamlfind remove paypal