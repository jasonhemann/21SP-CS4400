---
author: Jason Hemann
title: More staging, return of the continuations.
date: 2021-04-14
---

# From last time: staging. 

Sometimes we can expect a best way to describe the inputs. An order in
which it always makes sense. Then we can manually /stage/ that
program, rather taking in all of these parameters, we can separate it
out into multiple functions. This is nothing more than taking a
function `h`, and separating it out into a composition of two
different functions `g ∘ f` so that `g` never refers to or calls,
directly or indirectly, `f`. 

If we can more finely slice our input, then we can do even *more* AOT,
and leave even *less* to do at run-time.

# Quiz!! 

To what value(s) do the following expressions evaluate? How? 

```
(let/cc k0 
  ((let/cc k1 
     (k0 (sub1 (let/cc k2 
                 (k1 k2)))))
   1))
```

```
(let/cc k0 
  ((let/cc k1 
     (k0 (sub1 (let/cc k2 
                 (k1 k2)))))
   (k0 1)))
```

```
(let/cc k0 
  ((let/cc k1 
     (k1 (sub1 (let/cc k2 
                 (k1 k2)))))
   1))
```

## We could CPS the interpreter, and stage *that*.


## But we could do *more* still! Why `let/cc`!? 

[An argument against `call/cc`
(`let/cc`)](http://okmij.org/ftp/continuations/against-callcc.html)

`(reset (add1 (add1 (shift k (reset (add1 (shift k2 (k (k2 5)))))))))`






