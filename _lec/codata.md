
# Data v. Codata

## Ordinary Data

When you define a datatype, you list out how to construct those
values:

```
List a = Nil | Cons a * List a
```

Or in ML

```
datatype 'a list   = Nil | Cons of 'a * 'a list
```

For non-recursive datatypes, pattern matching is a case-analysis of
the datatypes. To process *recursive* datatypes, we need recursive
functions: in the recursive positions of the DT, we recursively call
the function.

## Codata

We've set that up to discuss codata, by contrast.

"Co-", category-theorese for like the matching yin to yang. Think like
a "corresponding angle". Data just *are*. Inert, plain, sit there. 

Codata have a kind of potential energy. Codata are about capabilities. 

By contrast with a datatype, we define a codatatype by its
/destructors/.



```
(lazy) stream a = 
```

Or as written in ML

```
codatatype S = d1 is B1 & ... & dn is Bn 
```

A datatype consists of constructors. We destruct elements of a
datatype D with a pattern-matching statement. In that same mirror
(dual) POV, a codatatype consists of destructors, and we *construct*
elements of a codatatype in the dual of the pattern-matching,
copattern-matching. Copattern-matching *constructs* elements of a
codatatype from the choices of the *destructors*, the same way regular
pattern matching *destructs* elements from the choices of the
*constructors*. 

Copattern-matches construct an element from sub-components. Just
remember that.


B/c the data-producer promises to construct data solely by the constructors, we get: 
 - pattern matching (cases) 
 - structural recursion 
 
B/c the codata-consumer promises to analyze codata by the patterns
induced by the agreed constructors (destructors?), we get:
 - constructors
 - guarded co-recursion




Data can only be constructed using constructors, but can be deconstructed using recursive folds;
Codata can only be deconstructed using case analysis, but can be constructed using recursive unfolds.

Monads keep things inside. Comonads keep things outside.


That is, if the options tell us all the ways to
break apart an element of a codatatype, the merge statement says how
to make one. 

Let's take an easy comparison: 

```
datatype A + B = inl A | inr B 
```




## Acks. 

 In constructing these notes I referred to:
 
 - [http://blog.ielliott.io/lambdas-are-codatatypes/]
 - [Codatatypes in ML](https://core.ac.uk/download/pdf/82610759.pdf)
 - [Codata](https://web.archive.org/web/20051014222219id_/http://types2004.lri.fr/SLIDES/altenkirch.pdf)
