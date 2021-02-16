#lang racket
(require rackunit-abbrevs)

#| Environments and Interpreters |# 


;; Inverting the adage that a data type is just a simple programming
;; language, we take the position that a programming language is,
;; semantically, just a complex data type; evaluation of a program is
;; just another operation in the data type.

;; -- Mitch Wand
 
#| Assignment Guidelines |#

;; Recall that in recent lectures, we've learned how to write an
;; interpreter that takes a Racket expression and returns the
;; expression's value. We have also learned to make this interpreter
;; representation independent with respect to environments, and we
;; have written two different representations of the helpers
;; extend-env, apply-env, and empty-env.

;; In the first part of this assignment you will implement the three
;; interpreters I presented in lecture.

;; For the 2nd and 3rd interpreters you must also define two sets of
;; environment helpers: one that uses functional (higher-order)
;; representation of environments, and one that uses data-structural
;; representation of environments. 

;; Your data structure representations should be the tagged list
;; representation demonstrated in class.

;; You must name your interpreters and helpers for each of the first
;; three problems respectively by the following naming
;; conventions. These below names may differ sligtly from the names I
;; used in lecture.

#| 
(define value-of ...)
 
(define value-of-fn ...)
(define empty-env-fn ...)
(define extend-env-fn ...)
(define apply-env-fn ...)
 
(define value-of-ds ...)
(define empty-env-ds ...)
(define extend-env-ds ...)
(define apply-env-ds ...)
|# 

;; Your first three interpreters must all handle the following forms:
;; numbers, booleans, variables, lambda-abstraction, application,
;; zero?, sub1, *, if, and let.

;; In the second part you will implement a fourth interpreter, this
;; time an interpreter for a new language.

;; For this assignment your solutions must be compositional or you
;; will lose credit.  E.g. although we could rewrite the expression
;; (let ([x e]) body) as ((lambda (x) body) e), you must not use
;; lambda in this way for your interpreter's line for let
;; expressions. Instead, you must implement let in its own right.

#| Interpreters and Environments |#

#|

1. value-of 

|# 

(check-true* equal?
  [(value-of '#f (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #f]
  [(value-of '#t (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #t]
  [(value-of '3 (lambda (y) (error 'value-of "unbound variable ~a" y)))
   3]
  [(value-of '(sub1 4) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   3]
  [(value-of '(zero? 3) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #f]
  [(value-of '(zero? 0) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #t]
  [(value-of '(zero? (sub1 1)) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #t]
  [(value-of '(* 3 4) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   12]
  [(value-of '(if #t 30 25) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   30]
  [(value-of '(if #f 30 25) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   25]
  [(value-of '(if #f #f #t) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #t]
  [(value-of '(if (zero? 5) 0 1) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   1]
  [(value-of '(if (zero? 0) #f #t) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   #f]
  [(value-of '((lambda (x) 5) 6) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   5]
  [(value-of '((lambda (x) x) 6) (lambda (y) (error 'value-of "unbound variable ~a" y)))
   6]
  [(value-of
     '((lambda (z) (* z 3)) 2)
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   6]
  [(value-of '((lambda (y) ((lambda (x) y) 6)) 5)
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   5]
  [(value-of '(((lambda (y) (lambda (x) y)) 5) 6) 
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   5]
  [(value-of 
     '(let ((x 5)) 6) 
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   6]
  [(value-of 
     '(let ((x 5)) x) 
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   5]
  [(value-of
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   60]
  [(value-of
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   30]
  [(value-of
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   25]
  [(value-of 
     '(let ((f (lambda (f)
                 (lambda (n)
                   (if (zero? n) 1 ((f f) (sub1 n)))))))
        ((f f) 5))
   (lambda (y) (error 'value-of "unbound variable ~a" y)))
   1]
  [(value-of 
     '(let ((! (lambda (x) (* x x))))
        (let ((! (lambda (n)
                   (if (zero? n) 1 (* n (! (sub1 n)))))))
          (! 5)))
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   80]   
  [(value-of
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (lambda (y) (error 'value-of "unbound variable ~a" y)))
   120])


#| 

2. value-of-fn 

|# 

(check-true* equal?
  [(value-of-fn '#f (empty-env-fn))
   #f]
  [(value-of-fn '#t (empty-env-fn))
   #t]
  [(value-of-fn '3 (empty-env-fn))
   3]
  [(value-of-fn '(sub1 4) (empty-env-fn))
   3]
  [(value-of-fn '(zero? 3) (empty-env-fn))
   #f]
  [(value-of-fn '(zero? 0) (empty-env-fn))
   #t]
  [(value-of-fn '(zero? (sub1 1)) (empty-env-fn))
   #t]
  [(value-of-fn '(* 3 4) (empty-env-fn))
   12]
  [(value-of-fn '(if #t 30 25) (empty-env-fn))
   30]
  [(value-of-fn '(if #f 30 25) (empty-env-fn))
   25]
  [(value-of-fn '(if #f #f #t) (empty-env-fn))
   #t]
  [(value-of-fn '(if (zero? 5) 0 1) (empty-env-fn))
   1]
  [(value-of-fn '(if (zero? 0) #f #t) (empty-env-fn))
   #f]
  [(value-of-fn '((lambda (x) 5) 6) (empty-env-fn))
   5]
  [(value-of-fn '((lambda (x) x) 6) (empty-env-fn))
   6]
  [(value-of-fn
     '((lambda (z) (* z 3)) 2)
     (empty-env-fn))
   6]
  [(value-of-fn '((lambda (y) ((lambda (x) y) 6)) 5)
     (empty-env-fn))
   5]
  [(value-of-fn '(((lambda (y) (lambda (x) y)) 5) 6) 
     (empty-env-fn))
   5]
  [(value-of-fn 
     '(let ((x 5)) 6) 
     (empty-env-fn))
   6]
  [(value-of-fn 
     '(let ((x 5)) x) 
     (empty-env-fn))
   5]
  [(value-of-fn
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (empty-env-fn))
   60]
  [(value-of-fn
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (empty-env-fn))
   30]
  [(value-of-fn
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (empty-env-fn))
   25]
  [(value-of-fn 
     '(let ((f (lambda (f)
                 (lambda (n)
                   (if (zero? n) 1 ((f f) (sub1 n)))))))
        ((f f) 5))
   (empty-env-fn))
   1]
  [(value-of-fn 
     '(let ((! (lambda (x) (* x x))))
        (let ((! (lambda (n)
                   (if (zero? n) 1 (* n (! (sub1 n)))))))
          (! 5)))
     (empty-env-fn))
   80]   
  [(value-of-fn
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (empty-env-fn))
   120])

#| 

3. value-of-ds

|# 

(check-true* equal?
  [(value-of-ds '#f (empty-env-ds))
   #f]
  [(value-of-ds '#t (empty-env-ds))
   #t]
  [(value-of-ds '3 (empty-env-ds))
   3]
  [(value-of-ds '(sub1 4) (empty-env-ds))
   3]
  [(value-of-ds '(zero? 3) (empty-env-ds))
   #f]
  [(value-of-ds '(zero? 0) (empty-env-ds))
   #t]
  [(value-of-ds '(zero? (sub1 1)) (empty-env-ds))
   #t]
  [(value-of-ds '(* 3 4) (empty-env-ds))
   12]
  [(value-of-ds '(if #t 30 25) (empty-env-ds))
   30]
  [(value-of-ds '(if #f 30 25) (empty-env-ds))
   25]
  [(value-of-ds '(if #f #f #t) (empty-env-ds))
   #t]
  [(value-of-ds '(if (zero? 5) 0 1) (empty-env-ds))
   1]
  [(value-of-ds '(if (zero? 0) #f #t) (empty-env-ds))
   #f]
  [(value-of-ds '((lambda (x) 5) 6) (empty-env-ds))
   5]
  [(value-of-ds '((lambda (x) x) 6) (empty-env-ds))
   6]
  [(value-of-ds
     '((lambda (z) (* z 3)) 2)
     (empty-env-ds))
   6]
  [(value-of-ds '((lambda (y) ((lambda (x) y) 6)) 5)
     (empty-env-ds))
   5]
  [(value-of-ds '(((lambda (y) (lambda (x) y)) 5) 6) 
     (empty-env-ds))
   5]
  [(value-of-ds 
     '(let ((x 5)) 6) 
     (empty-env-ds))
   6]
  [(value-of-ds 
     '(let ((x 5)) x) 
     (empty-env-ds))
   5]
  [(value-of-ds
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (empty-env-ds))
   60]
  [(value-of-ds
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (empty-env-ds))
   30]
  [(value-of-ds
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (empty-env-ds))
   25]
  [(value-of-ds 
     '(let ((f (lambda (f)
                 (lambda (n)
                   (if (zero? n) 1 ((f f) (sub1 n)))))))
        ((f f) 5))
   (empty-env-ds))
   1]
  [(value-of-ds 
     '(let ((! (lambda (x) (* x x))))
        (let ((! (lambda (n)
                   (if (zero? n) 1 (* n (! (sub1 n)))))))
          (! 5)))
     (empty-env-ds))
   80]   
  [(value-of-ds
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (empty-env-ds))
   120])

#| A New Syntax |#

#| 

4. Implement an interpreter fo-eulav. Let the below examples guide
you. I only require you to implement those forms I use in those
examples.

|# 

(check-true* equal?
  [(fo-eulav '(5 (x (x) adbmal)) (lambda (y) (error 'fo-eulav "unbound variable ~s" y)))
   5] ;; Ppa
  [(fo-eulav '(((x 1bus) (x) adbmal) ((5 f) (f) adbmal)) (lambda (y) (error 'fo-eulav "unbound variable ~s" y)))
   4] ;; Stnemugra sa Snoitcnuf 
  [(fo-eulav
     '(5  
       (((((((n 1bus) (f f)) n *) 1 (n ?orez) fi)
                                         (n) adbmal)
                                           (f) adbmal)
        ((((((n 1bus) (f f)) n *) 1 (n ?orez) fi)
                                        (n) adbmal)
                                          (f) adbmal))) 
     (lambda (y) (error 'fo-eulav "unbound variable ~s" y)))
   120]) ;; Tcaf

#| Brainteasers - 5400 Only |# 

;; Consider the following interpreter for a deBruijnized version of
;; the lambda-calculus (i.e. lambda-calculus expressions using lexical
;; addresses addresses instead of variables). Notice this interpreter
;; is representation-independent with respect to environments. There
;; are a few other slight variations in the syntax of the
;; language. These are of no particular consequence.

(define (value-of-lex exp env)
  (match exp
    [`(const ,expr) expr]
    [`(mult ,x1 ,x2) (* (value-of-lex x1 env) (value-of-lex x2 env))]
    [`(zero ,x) (zero? (value-of-lex x env))]
    [`(sub1 ,body) (sub1 (value-of-lex body env))]
    [`(if ,t ,c ,a) (if (value-of-lex t env) (value-of-lex c env) (value-of-lex a env))]
    [`(var ,num) (apply-env-lex env num)]
    [`(lambda ,body) (lambda (a) (value-of-lex body (extend-env-lex a env)))]
    [`(,rator ,rand) ((value-of-lex rator env) (value-of-lex rand env))]))
 
(define (empty-env-lex)
  '())

;; From the following call one can see we're using a data-structure
;; representation of environments.

;; > (value-of-lex '((lambda (var 0)) (const 5)) (empty-env-lex))
;; 5

#| 

5. Without using lambda or the implicit lambda in an "MIT-define",
define apply-env-lex and extend-env-lex. A correct solution is very
short.  

|#

#|

6. Go back and extend your interpreter value-of to support set! and
begin2, where begin2 is a variant of Racket's begin that takes exactly
two arguments, and set! mutates variables.

|# 

(check-true* equal? 
  [(value-of
     '(* (begin2 1 1) 3)
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   3]
  [(value-of
     '((lambda (a)
         ((lambda (p)
            (begin2
              (p a)
              a))
          (lambda (x) (set! x 4))))
       3)
      (lambda (y) (error 'value-of "unbound variable ~s" y)))
   3]
  [(value-of
    '((lambda (f)
        ((lambda (g)
           ((lambda (z) (begin2
                         (g z)
                         z))
            55))
         (lambda (y) (f y)))) (lambda (x) (set! x 44)))
    (lambda (y) (error 'value-of "unbound variable ~s" y)))
   55]
  [(value-of
     '((lambda (x)
         (begin2 (set! x 5) x))
       6)
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   5]
  [(value-of 
     '(let ((a 3)) 
         (begin2 (begin2 a (set! a 4)) a))
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   4]
  [(value-of 
     '((lambda (x)
         (begin2
           ((lambda (y)
              (begin2
                (set! x 0)
                98))
            99)
           x))
       97)
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   0]
  [(value-of 
     '((lambda (y)
         (let ((x (begin2
                    (set! y 7)
                    8)))
           (begin2
             (set! y 3)
               ((lambda (z) y)
                x))))
       4)
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   3]
  [(value-of 
     '(let ((a 5))
        (let ((y (begin2 (set! a (sub1 a)) 6)))
          (begin2
            (* y y)
            a)))
     (lambda (y) (error 'value-of "unbound variable ~s" y)))
   4])

#| Just Dessert |# 

;; The lambda calculus can be used to define a representation of
;; natural numbers, called Church numerals, and arithmetic over
;; them. For instance, c5 is the definition of the Church numeral for
;; 5. This is often described as "representing a number by its
;; fold". What they mean by this is: think of any given number not a
;; piece of data, but in terms of "the interface it implements." What
;; does a number *do* for you? It tells you how many times to iterate
;; some behavior. 

#| 

> (define c0 (lambda (s) (lambda (z) z)))
> (define c5 (lambda (s) (lambda (z) (s (s (s (s (s z))))))))
> ((c5 add1) 0)
5
> ((c0 add1) 0)
0

|# 

;; The following is a definition for Church plus, which performs
;; addition over Church numerals.

(define c+
  (lambda (m) 
    (lambda (n) 
      (lambda (s)
        (lambda (z)
          ((m s) ((n s) z)))))))

#| 
> (let ((c10 ((c+ c5) c5)))
    ((c10 add1) 0))
10

|# 

;; One way to understand the definition of c+ is that it, when
;; provided two Church numerals, returns a function that, when
;; provided a meaning for add1 and a meaning for zero, uses provides
;; to m the meaning for add1 and, instead of the meaning for zero,
;; provides it the meaning for its second argument. m is the sort of
;; thing that will count up m times, so the resulting function is the
;; meaning of m + n.

#| 

7. Your task, however, is to implement csub1, Church predecessor. Your
implementation should pass the following tests. In the second case,
the Church predecessor of Church zero is zero, as we haven't a notion
of negative numbers. This was a difficult problem, but it's fun, so
don't Google it. If you think it might help though, consider taking a
[trip to the
dentist](http://link.springer.com/chapter/10.1007%2FBFb0062850).

|#

(check-true* equal? 
  [(((csub1 c5) add1) 0) 4]
  [(((csub1 c0) add1) 0) 0])
  [((((c+ (csub1 (csub1 c5))) (csub1 c5)) add1) 0) 9]


