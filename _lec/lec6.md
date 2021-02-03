---
title: Universality of lambda calculus, alpha, beta, and eta.
date: 2020-02-08
---

# Questions 
  + Brief Homework questions 

# Review 

## *α-equivalence*

Remember, we said that, in a particular sense

```racket
    (lambda (x)
      (lambda (y)
	x))
```

  and 

```racket
    (lambda (p)
      (lambda (q)
	p))
```
  
  "the same", but different from the program:
  
```racket
    (lambda (z)
      (lambda (w)
	w))
```
  
  We called that sense *α-equivalence*.
  
  
  
