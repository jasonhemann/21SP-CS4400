---
title: Class intro; Racket 101
date: 2020-01-20
---

# Orientation
  
  - Instructor
  - Course 
  - Technical and Administrative 

# Introduction to Jason

  About Your Instructor: 
   - Jason Hemann
   - Doctorate in Computer Science, Indiana University
   - Concentration in Logic
   - Philosophy undergraduate
   - Dance and run and talk software and how it helps people
   - More at [recent news article!](https://twitter.com/KhouryCollege/status/1351680876254539776)

# What is this class about, and why? 

   - Why? from 10,000 ft. 
   - Where do we start, and where are we going? 
   - Show you some amazing stuff.
   - Give you opportunities to do some pretty awesome stuff
   - "Learn by doing"
   - Implementations and applications

# Technical and Administrative 

## Are you with us? 
   - Are you enrolled? 
   - Can you see yourself in Canvas (Combined section)?
   - Can you see yourself in Piazza? 

## I'm not going to go through administrativa. You should! 

  - Course Website
   - Full Course Schedule
   - Syllabus
   - Resources
   - (Optional) Textbooks and notes
   - Office hours 
  - Piazza 
  - Plan
   
## Delta from previous years/semesters
   - "Choose your own" v. "#langs" v. Haskell v. "#lang racket"
   - late work
   - breadth vs. depth 
   - continuations, control flow
   - laptops

# How to succeed in this class

 1. Come to class
 1. Take _vigorous_ notes. 
 1. No laptops
 1. Do not re-write when I re-write. 
    1. Instead, write down deltas-program xformations
 1. Revisit these notes to "replay" the events of lecture
    1. Use this replay to help you decipher and cement concepts in your head
	1. Working through in this level of detail will force you to grapple

# If you have not already ...

## Download and (re-)install DrRacket

Go to `https://download.racket-lang.org/`, and you can download and
install Racket and the DrRacket IDE for your platform. If you have
used DrRacket in a previous course, you should upgrade to the latest
version.

We will go ahead and install a handful of additional plugins. There
are for right now a couple of different tweaks and toggles we can hit.

Via the package manager (on OSX `File>Package manager`) , install
`faster-minikanren`.

We will use these at the appropriate time. 


# All the Racket you need to know

## Important to write *these* style of programs

 -- As or more important than it is that you write them

## We'll do several examples.

## We will go over them together and then take a break with each other. 

#### `y-after-x` 

```
;; y-after-x takes a list and returns a list
;; Add a y after every x in a list

;; (y-after-x '())
;; '()
;; (y-after-x '(x))
;; '(x y)
;; (y-after-x '(x x))
;; '(x y x y)
;; (y-after-x '(a b y c y))
;; '(a b y c y)

#|
(y-after-x '(y b x)) => '(y b x y)
(y-after-x   '(b x)) =>   '(b x y)
|#

;; L = () OR cons x L OR cons non-x L

(define (y-after-x ls)
  (cond ;; "conditional" i.e. "if-then-else"
    ((empty? ls) '())
    ((equal? (car ls) 'x)
     (cons 'x (cons 'y (y-after-x (cdr ls)))))
    ((not (equal? (car ls) 'x))
     (cons (car ls)
           (y-after-x (cdr ls))))))
```

#### `zip` 

(EDIT: We did not get to the next two. Maybe try them on your own and
	then look at our solutions)

```
;; zip : takes a List and List and returns a List
;; Returns a list of pairs of the constituent elements of the first and second list. 
;; If the lists are of different lengths, drop the remainder of the longer list.
;; > (zip '(a b c) '(e f g))
;; '((a . e) (b . f) (c . g))
;; > (zip '(a) '(e f g))
;; '((a . e))
;; > (zip '(a bx c) '(e f))
;; '((a . e) (bx . f))
;; > (zip '(a b) '())
;; '()

(define (zip ls1 ls2)
  (cond 
    ((empty? ls1) '())
	((empty? ls2) '())
	(else (cons (cons (car ls1) (car ls2)) (zip (cdr ls1) (cdr ls2))))))
```

For this one, I really thought about it as though I was walking over
one piece of data: the two lists (at once) this is why I made my
sub-problem changing both lists at once. What's decreasing is their
total length. So I need two base cases, because both of the lists are
shrinking.

#### `map` 

This is another one to which we did not get. It is also more than we
will need to write miniKanren programs; it is the sort of thing we
might use when we write a miniKanren. `map` is a function that takes a
*function* as an argument. This is an example of what makes functional
programming really cool. If you want a more run-of-the-mill example,
consider this: in your calculus class ~integral~ was a mathematical
function that took another mathematical function as an argument, and
it produced yet *another* function as the value. Whoooa! ᕕ( ᐛ )ᕗ

```
;; map takes a one-argument function and a list and produces a list
;; map runs the function f on every element of the list in turn, and produces a list of the results.

;; > (map add1 '(2 3 4 5))
;; '(3 4 5 6)
;; > (map symbol? '(cat dog #f 2 3 4))
;; '(#t #t #f #f #f #f)
;; > (map y-after-x '(() (x) (x x) (a b y c y)))
;; '(() (x y) (x y x y) (a b y c y))

(define (map f ls)
  (cond
    ((empty? ls) '())
	(else (cons (f (car ls)) (map f (cdr ls))))))
```

## We'll do several examples.

### `length`


### `count8`

```
(define count8
  (λ (ls)
    (cond
      ((null? ls) 0)
      ((eqv? (car ls) 8) (add1 (count8 (cdr ls))))
      (else (count8 (cdr ls))))))
```

```
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

```
(count8* '(4 (8 (5 (((8)) 7))) (3 8)))
3
```

### `rember8` 

```
;; (cons (car (cons α β)) (cdr (cons α β)))
;; =
;; (cons α β)

;; '(4  8 5 8 7 3 8) => '(4  5 7 3) 
;;    '(8 5 8 7 3 8) =>    '(5 7 3)

(define rember8
  (λ (ls)
    (cond
      ((null? ls) '())
      ((eqv? (car ls) 8) (rember8 (cdr ls)))
      (else (cons (car ls) (rember8 (cdr ls)))))))
```

### `rember8*`

```
(define rember8*
  (λ (ls)
    (cond
      ((null? ls) '())
      ((pair? (car ls)) (cons (rember8* (car ls)) (rember8* (cdr ls))))
      ((eqv? (car ls) 8) (rember8* (cdr ls)))
      (else (cons (car ls) (rember8* (cdr ls)))))))

(rember8* '(4 (8 (5 (((8)) 7))) (3 8)))
```

### Arithmetic examples, if we get there. 
