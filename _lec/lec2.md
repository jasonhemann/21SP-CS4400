---
title: Naturally Recursive Functions
date: 2020-01-24
---
# All the Racket you need to know x2

## Again, it's important to write this *style* of programs

### `length`


### `count8`

```lisp
(define count8
  (λ (ls)
    (cond
      ((null? ls) 0)
      ((eqv? (car ls) 8) (add1 (count8 (cdr ls))))
      (else (count8 (cdr ls))))))
```

### `count8*`

```lisp
(define count8*
  (λ (ls)
    (cond
      ((null? ls) 0)
      ;; this is our test for listitude 
      ;; we have a list, and it's car is a list
      ((pair? (car ls)) (+ (count8* (car ls)) (count8* (cdr ls))))
      ((eqv? (car ls) 8) (add1 (count8* (cdr ls))))
      (else (count8* (cdr ls))))))
```

```lisp
(count8* '(4 (8 (5 (((8)) 7))) (3 8)))
3
```

# Arithmetic examples.


## `plus`

## `times`

## `expt` 

## Generalizing 


