# CPPTypeChecker

A type checker for a subset of C++ written in Haskell.

Set up and written by Samuel Balco following Chapter 4 of [Implementing Programming Languages](http://www.grammaticalframework.org/ipl-book/) by Aarne Ranta and the corresponding [Assignment 2](http://www.grammaticalframework.org/ipl-book/assignments/assignment2/assignment2.html).

To compile run `stack build` and to test run `stack test`.

To run typechecking on a specific file, run `stack exec CPPTypeChecker-exe <file_path>.cc`.

The files produced by bnfc are in src:

	AbsCpp.hs
	ErrM.hs
	LexCpp.hs
	ParCpp.hs
	PrintCpp.hs

The template for the typechecker is in `TypeChecker.hs`. This where you will find the code that you need to complete.

To know which cases you need to add, look at the grammar as well as at the algebraic data type for abstract syntax trees defined in `AbsCpp.hs`.

The error monad that is used to modify the type `Type` of CPP-types is defined in `ErrM.hs`.

## Haskell Tips

I keep an updating [list with Haskell tips](https://hackmd.io/nVQP-fp-TEWUbp9kecaLTQ).

To look up the type of built-in functions, search the functions at hoogle, see for example [foldM at hoogle](https://hoogle.haskell.org/?hoogle=foldM). Don't forget to click on the little plus sign for a description of how `foldM` works.

### Further Sources/Helpful links for Haskell

(Thanks to Austin Bohannon and Sam Kagan)

#### Base language
* https://wiki.haskell.org/
 * https://wiki.haskell.org/Fold
 * https://wiki.haskell.org/Keywords
 * https://wiki.haskell.org/Monad
 * https://wiki.haskell.org/Anonymous_function
* https://stackoverflow.com/questions/2468332/string-formatting-in-haskell
* https://wiki.haskell.org/How_to_work_on_lists
* https://stackoverflow.com/questions/7564103/haskell-iterate-over-a-list
* https://zvon.org/other/haskell/Outputprelude/zip_f.html

#### Packages
* https://hoogle.haskell.org
* https://hackage.haskell.org/
 * https://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Monad.html
 * https://hackage.haskell.org/package/base-4.12.0.0/docs/Text-Printf.html
 * https://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:map
 * https://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Tuple.html
* https://stackoverflow.com/questions/5844347/accessing-a-specific-element-in-a-tuple
* https://en.wikibooks.org/wiki/Haskell/Lists_and_tuples


