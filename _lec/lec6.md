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

## β, η

# Universality of the `lambda` calculus

-   `cons`, `car`, `cdr`
-   Booleans, `if`

## Church numerals

The λ calculus can be used to define a representation of natural
numbers, called Church numerals, and arithmetic over them. For instance,
`c5` is the definition of the Church numeral for 5.

```racket
> (define c0 (lambda (f) (lambda (x) x)))
> (define c5 (lambda (f) (lambda (x) (f (f (f (f (f x))))))))
> ((c5 add1) 0)
5
> ((c0 add1) 0)
0
```

The following is a definition for Church plus, which performs addition
over Church numerals.

```racket
> (define c+ (lambda (m) 
       (lambda (n) 
         (lambda (a) (lambda (b) ((m a) ((n a) b)))))))
> (let ((c10 ((c+ c5) c5)))
    ((c10 add1) 0))
10
```

One way to understand the definition of `c+` is that it, when provided
two Church numerals, returns a function that, when provided a meaning
for `add1` and a meaning for zero, uses provides to `m` the meaning for
`add1` and, instead of the meaning for zero, provides it the meaning for
its second argument. `m` is the sort of thing that will count up *m*
times, so the result is the meaning of *m* *+* *n*.

(For fun implement `csub1`, Church predecessor. The following tests
should pass.)

```racket
> (((csub1 c5) add1) 0)
4
> (((csub1 c0) add1) 0)
0
```

In the second case, the Church predecessor of Church zero is zero, as we
haven\'t a notion of negative numbers.

## `Ω`, `Y` and recursion


