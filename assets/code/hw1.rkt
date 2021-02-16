#lang racket
(require rackunit-abbrevs)

#| Recursion and Higher-order Functional Abstraction |# 

;; Recursion is the root of computation since it trades description
;; for time. 

;; -- Alan Perlis 
 
#| Assignment Guidelines |#


;; In addition to the standard Assignment Guidelines
;; (https://pages.github.ccs.neu.edu/jhemann/21SP-CS4400/hw/)

;; You should write your solutions without creating explict help
;; functions. You may, however re-use your solutions to prior
;; problems.

#| 

0. I've recently updated the course syllabus for this semester. Please
read through it carefully before beginning the rest of the assignment.

|# 


#| 

 1. Define and test a procedure countdown that takes a natural number
and returns a list of the natural numbers less than or equal to that
number, in descending order.

|#

(check-true* equal? 
  [(countdown 0) '(0)]
  [(countdown 5) '(5 4 3 2 1 0)])

#| 

2. Define and test a procedure insertR that takes two symbols and a
list and returns a new list with the second symbol inserted after each
occurrence of the first symbol. For this and later questions, these
functions need only hold over eqv?-comparable structures.

|#

(check-true* equal? 
  [(insertR 'a 't '()) '()]
  [(insertR 'x 'y '(x z z x y x)) '(x y z z x y y x y)])

#| 

3. Define and test a procedure remv that takes an atom and a list of
atoms and returns a list similar except its missing the first
occurrence (if any) of the input atom.

|# 

(check-true* equal? 
  [(remv 'x '(x y z x)) '(y z x)]
  [(remv 'y '(x y z y x)) '(x z y x)]
  [(remv 'z '(a b c)) '(a b c)])

#| 

4. Define and test a procedure list-index-ofv that takes an element
and a list containing that element and returns the (base 0) index of
that element in the list. List without that element are bad data.

|# 

(check-true* equal?
  [(list-index-ofv 'x '(x y z x x)) 0]
  [(list-index-ofv 'x '(y z x x)) 2])

#| 

5. Define and test a procedure filter that takes a predicate and a
list and returns a new list containing the elements that satisfy the
predicate. A predicate is a procedure that takes a single argument and
returns either #t or #f. The number? predicate, for example, returns
#t if its argument is a number and #f otherwise. The argument
satisfies the predicate, then, if the predicate returns #t for that
argument.

|# 

(check-true* equal?
 [(filter even? '(1 2 3 4 5 6)) '(2 4 6)])

#| 

6. Define and test a procedure zip that takes two lists and forms a
new list, each element of which is a pair formed by combining the
corresponding elements of the two input lists. If the two lists are of
uneven length, zip will drop the tail of the longer one.

|# 

(check-true* equal? 
 [(zip '(1 2 3) '(a b c)) '((1 . a) (2 . b) (3 . c))]
 [(zip '(1 2 3 4 g 6) '(a b c)) '((1 . a) (2 . b) (3 . c))]
 [(zip '(1 2 3) '(a b c d e f)) '((1 . a) (2 . b) (3 . c))])

#| 

7. Define and test a procedure map that takes a procedure p of one
argument and a list ls and returns a new list containing the results
of applying p to the elements of ls. Do not use Racket's built-in map
in your definition.

|# 

(check-true* equal? 
  [(map add1 '(1 2 3 4)) '(2 3 4 5)])

#| 

8. Define and test a procedure append that takes a list l and any
racket datum d, and returns a new racket datum with the elements of l
prepended. This should work for any racket datum d, but testing
against the data we have talked about in class is sufficient.

|# 

(check-true* equal? 
  [(append '(42 120) 't) '(42 120 . t)]
  [(append '(42 120) '(1 2 3)) '(42 120 1 2 3)]
  [(append '(a b c) '(cat dog)) '(a b c cat dog)])

#| 

9. Define and test a procedure reverse that takes a list l and returns
list with the elements of l in the opposite order

|# 

(check-true* equal? 
  [(reverse '(a 3 x)) '(x 3 a)])

#| 

10. Define and test a procedure fact that takes a natural number and
computes the factorial of that number. The factorial of a number is
computed by multiplying it by the factorial of its predecessor. The
factorial of 0 is defined to be 1 (https://oeis.org/A000142).

|# 

(check-true* equal? 
 [(fact 0) 1]
 [(fact 5) 120])

#|

11. Define and test a procedure fib that takes a natural number n as
input and computes the nth number, starting from zero, in the
Fibonacci sequence (0, 1, 1, 2, 3, 5, 8, 13, 21, …). Each number in
the sequence is computed by adding the two previous numbers.

|# 
(check-true* equal?
 [(fib 0) 0]
 [(fib 1) 1]
 [(fib 7) 13])

#| 

12. The expressions (a b) and (a . (b . ())) are equivalent. Using
this knowledge, write an expression equivalent to ((w x) y (z)) but
using as many dots as possible. Be sure to test your solution using
Racket's equal?  predicate. (You do not have to define a rewrite
procedure; just rewrite the given expression by hand and place it in
this comment.)


|# 

#| 

13. Define and test a procedure binary->natural that takes a flat list
of 0s and 1s representing an unsigned binary number in reverse bit
order and returns that number. For example:

|# 

(check-true* equal? 
  [(binary->natural '()) 0]
  [(binary->natural '(0 0 1)) 4]
  [(binary->natural '(0 0 1 1)) 12]
  [(binary->natural '(1 1 1 1)) 15]
  [(binary->natural '(1 0 1 0 1)) 21]
  [(binary->natural '(1 1 1 1 1 1 1 1 1 1 1 1 1)) 8191])

#| 

14. Define subtraction using natural recursion. Your subtraction
function, minus, need only take nonnegative inputs where the result
will be nonnegative.

|# 

(check-true* equal? 
 [(minus 5 3) 2]
 [(minus 100 50) 50])

#| 

15. Define division using natural recursion. Your division function,
div, need only work when the second number evenly divides the
first (that is, for the divisible abelian group that's a subgroup of
Nat). Divisions by zero is of course bad data.

|# 

(check-true* equal? 
  [(div 25 5) 5]
  [(div 36 6) 6])

#| 

16. Define a function append-map that, similar to map, takes both a
procedure p of one argument a list of inputs ls and applies p to each
of the elements of ls. Here, though, we mandate that the result of p
on each element of ls is a list, and we append together the
intermediate results. Do not use Racket's built-in append-map in your
definition.

|# 

(check-true* equal?
  [(append-map countdown (countdown 5)) '(5 4 3 2 1 0 4 3 2 1 0 3 2 1 0 2 1 0 1 0 0)])

#| 

17. Define a function set-difference that takes two flat sets (lists
with no duplicate elements) s1 and s2 and returns a list containing
all the elements in s1 that are not in s2.

|# 

(check-true* equal?
  [(set-difference '(1 2 3 4 5) '(2 4 6 8)) '(1 3 5)])

#| 

18. Define a function cons-every that takes an element x and a list l
and returns a list with x consed to the front of each element of l. 

|# 

(check-true* equal?
  [(cons-every 'y '()) '()]
  [(cons-every 'x '(a b c d)) '((x . a) (x . b) (x . c) (x . d))]
  [(cons-every '(a) '(d e f)) '(((a) . d) ((a) . e) ((a) . f))]
  [(cons-every 'a '((e))) '((a e))])

#| Brainteasers - 5400 Only |#

#| 

19. In mathematics, the power set of any set S, denoted P(S), is the
set of all subsets of S, including the empty set and S itself. The
procedure powerset takes a list and returns the power set of the
elements in the list. Implementations may different in the exact order
of their results' sublists.

|# 
(check-true* (λ args (apply equal? (map (compose sequence->multiset ((curry map) sequence->multiset)) args)))
  [(powerset '()) '(())]
  [(powerset '(3 2 1)) '((3 2 1) (3 2) (3 1) (3) (2 1) (2) (1) ())])

#| 

20. The cartesian-product is defined over a non-empty list of
sets (again, by our agreed upon convention, sets are lists that don't
have duplicates). The result is a list of tuples (i.e. a list of
lists). Each tuple has in the first position an element of the first
set, in the second position an element of the second set, etc. The
output list should contains all such combinations. The exact order of
your tuples may differ; this is acceptable.

|#

(check-true* (λ args (apply equal? (map sequence->multiset args))))
  [(cartesian-product '((5 4) (3 2 1))) '((5 3) (5 2) (5 1) (4 3) (4 2) (4 1))]
  [(cartesian-product '((1) (5 4) (3 2 1))) '((1 5 3) (1 5 2) (1 5 1) (1 4 3) (1 4 2) (1 4 1))])

#| 

21. Rewrite some of the natural-recursive programs from above instead
using foldr. That is, the bodies of your definitions should not refer
to themselves. The names should be as follows.

I recommend this (http://www.cs.nott.ac.uk/~pszgmh/fold.pdf) treatise
on fold operators. It contains answers to several of the above
sub-problems. It will also teach you about programming with
foldr. There are stunningly beautiful definitions of the last two
sub-problems. They're just mind-blowing. And to tease you further,
know that some (pretty clever, albeit) folk solved this almost 50
years ago, back when lexical scope wasn't a thing, higher-order
functions weren't commonplace like they are today, and many of the
common programming idioms and that we take for granted just weren't
around. Since I hate to pass up an excuse to show off something cool,
I gotta tell you about
[this](https://www.brics.dk/RS/07/14/BRICS-RS-07-14.pdf) derivation
and explanation of answers to the last couple of problems, but you
have to promise (1) you'll try it first on your own, and (2) that if
you peek at the answers, you'll read the whole thing. It's short,
moves quickly, and very high enlightenment/text ratio. That's my sales
pitch.

|# 

(check-true* equal? 
  [(insertR-fr 'a 't '()) '()]
  [(insertR-fr 'x 'y '(x z z x y x)) '(x y z z x y y x y)])

(check-true* equal?
 [(filter even? '(1 2 3 4 5 6)) '(2 4 6)])

(check-true* equal? 
  [(map-fr add1 '(1 2 3 4)) '(2 3 4 5)])

(check-true* equal? 
  [(append-fr '(42 120) 't) '(42 120 . t)]
  [(append-fr '(42 120) '(1 2 3)) '(42 120 1 2 3)]
  [(append-fr '(a b c) '(cat dog)) '(a b c cat dog)])

(check-true* equal? 
  [(reverse-fr '(a 3 x)) '(x 3 a)])

(check-true* equal? 
  [(binary->natural-fr '()) 0]
  [(binary->natural-fr '(0 0 1)) 4]
  [(binary->natural-fr '(0 0 1 1)) 12]
  [(binary->natural-fr '(1 1 1 1)) 15]
  [(binary->natural-fr '(1 0 1 0 1)) 21]
  [(binary->natural-fr '(1 1 1 1 1 1 1 1 1 1 1 1 1)) 8191])

(check-true* equal?
  [(append-map-fr countdown (countdown 5)) '(5 4 3 2 1 0 4 3 2 1 0 3 2 1 0 2 1 0 1 0 0)])

(check-true* equal?
  [(set-difference-fr '(1 2 3 4 5) '(2 4 6 8)) '(1 3 5)])

(check-true* (λ args (apply equal? (map (compose sequence->multiset ((curry map) sequence->multiset)) args)))
  [(powerset-fr '()) '(())]
  [(powerset-fr '(3 2 1)) '((3 2 1) (3 2) (3 1) (3) (2 1) (2) (1) ())])

(check-true* (λ args (apply equal? (map sequence->multiset args))))
  [(cartesian-product-fr '((5 4) (3 2 1))) '((5 3) (5 2) (5 1) (4 3) (4 2) (4 1))]
  [(cartesian-product-fr '((1) (5 4) (3 2 1))) '((1 5 3) (1 5 2) (1 5 1) (1 4 3) (1 4 2) (1 4 1))])

#| 

22. Consider the below function f. It is an open question in
mathematics, known as the Collatz Conjecture, as to whether, for every
positive integer n, the function power limit of f on n is 1. Your task
is to, complete the below definition of collatz. collatz should be a
function which will, when given a positive integer as an input,
operate in a manner similar to the straightforward recursive function
f.

Your completed answer should be very short. It must be no more than
one line long (and prettily-indented, so don't think about squeezing
something big on a single line), and must not use lambda. Your
collatz should compute the collatz of positive integers; for
non-positive integers, it should signal an error “Invalid value”.

|# 

(define (f n)
  (cond
    ((even? n) (/ n 2))
    ((odd? n) (add1 (* n 3)))))

(define collatz
  (letrec
    ((odd-case
      (lambda (recur)
        (lambda (x)
          (cond 
            ((odd? x) (collatz (add1 (* x 3)))) 
            (else (recur x))))))
     (even-case
      (lambda (recur)
        (lambda (x)
          (cond 
            ((even? x) (collatz (/ x 2))) 
            (else (recur x))))))
     (one-case
      (lambda (recur)
        (lambda (x)
          (cond
            ((zero? (sub1 x)) 1)
            (else (recur x))))))
     (base
      (lambda (x)
        (error 'error "Invalid value ~s~n" x))))
    ... ;; this should be a single line, without lambda
    ))

(check-true* equal? 
 [(collatz 12) 1]
 [(collatz 120) 1]
 [(collatz 9999) 1])

#| Just Dessert |# 

#| 

23. A quine is a program whose output is the listings (i.e. source
code) of the original program. In Racket, 5 and #t are both quines.

> 5
5
> #t
#t

We will call a quine in Racket that is neither a number nor a boolean
an interesting Racket quine. Below is an interesting Racket quine.

> ((lambda (x) (list x (list 'quote x)))
  '(lambda (x) (list x (list 'quote x))))
'((lambda (x) (list x (list 'quote x)))
   '(lambda (x) (list x (list 'quote x))))

Write your own interesting Racket quine, and define it as quine. The
following should then be true. Not every Racket list is a quine;
Racket's standard printing convention will prepend a quote to a
list. Make sure to use the above tests.

|# 

(check-true* equal?
 [quine (eval quine)]
 [quine (eval (eval quine))])

