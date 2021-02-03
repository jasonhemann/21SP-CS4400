---
title: value-of an interpreter for lambda-calculus expressions
date: 2021-02-08
---

# Questions

-   Homework coming due soon. Yeah?
-   Great questions! Keep up the good and awesomeness!
-   Debugging help.

# Review

-   `match`
-   our three lines

# The interpreter

This is today\'s big idea. One of the questions we can ask about these
`lambda`-calculus expressions is: what is the *value*? And its the same
pattern as writing any other program over `lambda`-calculus expressions.

We will add some forms beyond just our 3 lines, but we don\'t *have* to.
And you could add more if you wanted, too!

# Universality of the `lambda` calculus

-   `cons`, `car`, `cdr`
-   Booleans, `if`

## Church numerals

The lambda calculus can be used to define a representation of natural
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
