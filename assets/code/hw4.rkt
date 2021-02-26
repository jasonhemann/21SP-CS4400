#lang racket
(require rackunit-abbrevs)

#| RI Closures and Dynamic Scope |# 

;; On two occasions I have been asked [by members of
;; Parliament],--"Pray, Mr. Babbage, if you put into the machine wrong
;; figures, will the right answers come out?"

;; – Charles Babbage, 1864
 
#| Assignment Guidelines |#

;; To begin with, copy your correctly-implemented value-of-fn
;; interpreter and its three environment helpers (extend-env-fn,
;; apply-env-fn, empty-env-fn) over from last assignment. If you did
;; not get this correct last week, please see a TA and get help on
;; this before you go further.

;; In this file, rename that interpreter value-of, rename its
;; environment helpers extend-env, apply-env, and empty-env,
;; respectively.

;; Copy your correctly-implemented lex over from the second
;; assignment. If you do not yet have this correct please seek
;; guidance from a TA. This is a second chance at a whack at that
;; earlier problem.

;; The main goal of this assignment is to implement dynamic scope; we
;; are weighting that part of the assignment more heavily.

#| Regression Testing and Enhancing |# 

#| 

1. The following regression tests from your last assignment should
still work on your newly-renamed value-of and its associated
environment help functions.

|# 

(check-true* equal?
  [(apply-env (extend-env 'x 5 (empty-env)) 'x)
   5]
  [(apply-env (extend-env 'x 7 (extend-env 'x 5 (empty-env))) 'x)
   7]
  [(apply-env (extend-env 'x 7 (extend-env 'y 5 (empty-env))) 'y)
   5])

(check-true* equal?
  [(value-of
     '((lambda (x) (if (zero? x)
                       #t
                       #f))
       0)
     (empty-env))
   #t]   
  [(value-of 
     '((lambda (x) (if (zero? x) 
                       12 
                       47)) 
      0) 
    (empty-env))
   12]    
  [(value-of
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (empty-env))
   60]
  [(value-of
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (empty-env))
   30]
  [(value-of
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (empty-env))
   25]
  [(value-of
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (empty-env))
   120])

#| 

2. You previously implemented lex to handle variables, application,
and lambda-abstraction forms. Extend your previous definition of
lex so that it can handle not only those forms, but also numbers,
zero?, sub1, *, if, and let. This should be a
straightforward extension (let should be the only line that requires
any real effort), but it also serves as a chance to improve a
misbehaving lex from an earlier assignment. In order to disambiguate
numbers from lexical addresses, you should transform a number n into
(const n).

|# 

(check-true* equal? 
  [(lex '(lambda (x) x) '())
   '(lambda (var 0))]
  [(lex '(lambda (y) (lambda (x) y)) '())
   '(lambda (lambda (var 1)))]
  [(lex '(lambda (y) (lambda (x) (x y))) '())
   '(lambda (lambda ((var 0) (var 1))))]
  [(lex '(lambda (x) (lambda (x) (x x))) '())
   '(lambda (lambda ((var 0) (var 0))))]
  [(lex '(lambda (y) ((lambda (x) (x y)) (lambda (c) (lambda (d) (y c))))) '()) 
   '(lambda ((lambda ((var 0) (var 1))) (lambda (lambda ((var 2) (var 1))))))]
  [(lex '(lambda (a)
           (lambda (b)
             (lambda (c)
               (lambda (a)
                 (lambda (b)
                   (lambda (d)
                     (lambda (a)
                       (lambda (e)
                         (((((a b) c) d) e) a))))))))) '())
   '(lambda
      (lambda
        (lambda
          (lambda
            (lambda
              (lambda
                (lambda
                  (lambda
                    ((((((var 1) (var 3)) (var 5)) (var 2)) (var 0)) (var 1))))))))))]
  [(lex '(lambda (a)
           (lambda (b)
             (lambda (c)
               (lambda (w)
                 (lambda (x)
                   (lambda (y)
                     ((lambda (a)
                        (lambda (b)
                          (lambda (c)
                            (((((a b) c) w) x) y))))
                      (lambda (w)
                        (lambda (x)
                          (lambda (y)
                            (((((a b) c) w) x) y))))))))))) '())
   '(lambda 
      (lambda 
        (lambda 
          (lambda 
            (lambda 
              (lambda 
                ((lambda
                   (lambda
                     (lambda
                       ((((((var 2) (var 1)) (var 0)) (var 5)) (var 4)) (var 3)))))
                 (lambda
                   (lambda
                     (lambda
                       ((((((var 8) (var 7)) (var 6)) (var 2)) (var 1)) (var 0))))))))))))]
  [(lex '((lambda (x) x) 5)  '())
   '((lambda (var 0)) (const 5))]
  [(lex '(lambda (!)
           (lambda (n)
             (if (zero? n) 1 (* n (! (sub1 n))))))
         '())
   '(lambda
      (lambda
        (if (zero? (var 0))
            (const 1)
            (* (var 0) ((var 1) (sub1 (var 0)))))))]
  [(lex '(let ((! (lambda (!)
                    (lambda (n)
                      (if (zero? n) 1 (* n ((! !) (sub1 n))))))))
           ((! !) 5))
        '())
   '(let (lambda
           (lambda
             (if (zero? (var 0))
                 (const 1)
                 (* (var 0) (((var 1) (var 1)) (sub1 (var 0)))))))
      (((var 0) (var 0)) (const 5)))])


#| Representation Independence wrt Closures |# 

#| 

3. Create a version of your interpreter from the first part of this
assignment that is representation-independent with respect to closures
and uses a higher-order function representation. Name your two new
closure helpers apply-closure-fn and make-closure-fn.

|# 

(check-true* equal?
  [(value-of-fn '#f (empty-env))
   #f]
  [(value-of-fn '#t (empty-env))
   #t]
  [(value-of-fn '3 (empty-env))
   3]
  [(value-of-fn '(sub1 4) (empty-env))
   3]
  [(value-of-fn '(zero? 3) (empty-env))
   #f]
  [(value-of-fn '(zero? 0) (empty-env))
   #t]
  [(value-of-fn '(zero? (sub1 1)) (empty-env))
   #t]
  [(value-of-fn '(* 3 4) (empty-env))
   12]
  [(value-of-fn '(if #t 30 25) (empty-env))
   30]
  [(value-of-fn '(if #f 30 25) (empty-env))
   25]
  [(value-of-fn '(if #f #f #t) (empty-env))
   #t]
  [(value-of-fn '(if (zero? 5) 0 1) (empty-env))
   1]
  [(value-of-fn '(if (zero? 0) #f #t) (empty-env))
   #f]
  [(value-of-fn '((lambda (x) 5) 6) (empty-env))
   5]
  [(value-of-fn '((lambda (x) x) 6) (empty-env))
   6]
  [(value-of-fn
     '((lambda (z) (* z 3)) 2)
     (empty-env))
   6]
  [(value-of-fn '((lambda (y) ((lambda (x) y) 6)) 5)
     (empty-env))
   5]
  [(value-of-fn '(((lambda (y) (lambda (x) y)) 5) 6) 
     (empty-env))
   5]
  [(value-of-fn 
     '(let ((x 5)) 6) 
     (empty-env))
   6]
  [(value-of-fn 
     '(let ((x 5)) x) 
     (empty-env))
   5]
  [(value-of-fn
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (empty-env))
   60]
  [(value-of-fn
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (empty-env))
   30]
  [(value-of-fn
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (empty-env))
   25]
  [(value-of-fn 
     '(let ((f (lambda (f)
                 (lambda (n)
                   (if (zero? n) 1 ((f f) (sub1 n)))))))
        ((f f) 5))
   (empty-env))
   1]
  [(value-of-fn 
     '(let ((! (lambda (x) (* x x))))
        (let ((! (lambda (n)
                   (if (zero? n) 1 (* n (! (sub1 n)))))))
          (! 5)))
     (empty-env))
   80]   
  [(value-of-fn
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (empty-env))
   120])

#| 

4. Create a version of this interpreter that is
representation-independent with respect to closures and uses a data
structure representation. Name your two new closure helpers
apply-closure-ds and make-closure-ds.

Other than the cosmetic change of -fn to -ds, you shouldn't have to
change the implementations of valof. This is once again a good thing!

This is evidence we have a tight, well-defined interface for
closures. We've been able to, on the "behind the
interface"/implementation side of things, radically change how we're
implementing closures, and we haven't had to change the client
code. That's evidence we've done a good job designing our interface.


|#

(check-true* equal?
  [(value-of-ds '#f (empty-env))
   #f]
  [(value-of-ds '#t (empty-env))
   #t]
  [(value-of-ds '3 (empty-env))
   3]
  [(value-of-ds '(sub1 4) (empty-env))
   3]
  [(value-of-ds '(zero? 3) (empty-env))
   #f]
  [(value-of-ds '(zero? 0) (empty-env))
   #t]
  [(value-of-ds '(zero? (sub1 1)) (empty-env))
   #t]
  [(value-of-ds '(* 3 4) (empty-env))
   12]
  [(value-of-ds '(if #t 30 25) (empty-env))
   30]
  [(value-of-ds '(if #f 30 25) (empty-env))
   25]
  [(value-of-ds '(if #f #f #t) (empty-env))
   #t]
  [(value-of-ds '(if (zero? 5) 0 1) (empty-env))
   1]
  [(value-of-ds '(if (zero? 0) #f #t) (empty-env))
   #f]
  [(value-of-ds '((lambda (x) 5) 6) (empty-env))
   5]
  [(value-of-ds '((lambda (x) x) 6) (empty-env))
   6]
  [(value-of-ds
     '((lambda (z) (* z 3)) 2)
     (empty-env))
   6]
  [(value-of-ds '((lambda (y) ((lambda (x) y) 6)) 5)
     (empty-env))
   5]
  [(value-of-ds '(((lambda (y) (lambda (x) y)) 5) 6) 
     (empty-env))
   5]
  [(value-of-ds 
     '(let ((x 5)) 6) 
     (empty-env))
   6]
  [(value-of-ds 
     '(let ((x 5)) x) 
     (empty-env))
   5]
  [(value-of-ds
     '(let ([y (* 3 4)])
        ((lambda (x) (* x y)) (sub1 6)))
     (empty-env))
   60]
  [(value-of-ds
     '(let ([x (* 2 3)])
        (let ([y (sub1 x)])
          (* x y)))
     (empty-env))
   30]
  [(value-of-ds
     '(let ([x (* 2 3)])
        (let ([x (sub1 x)])
          (* x x)))
     (empty-env))
   25]
  [(value-of-ds 
     '(let ((f (lambda (f)
                 (lambda (n)
                   (if (zero? n) 1 ((f f) (sub1 n)))))))
        ((f f) 5))
   (empty-env))
   1]
  [(value-of-ds 
     '(let ((! (lambda (x) (* x x))))
        (let ((! (lambda (n)
                   (if (zero? n) 1 (* n (! (sub1 n)))))))
          (! 5)))
     (empty-env))
   80]   
  [(value-of-ds
     '(((lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n))))))
        (lambda (f)
          (lambda (n) (if (zero? n) 1 (* n ((f f) (sub1 n)))))))
       5)
     (empty-env))
   120])


#| Dynamic Scope |# 

#| 

The second part of this week's assignment is to create an
interpreter that uses dynamic scope.

So far, we have implemented our interpreters so that, if there are
variables that occur free in an a procedure, they take their values
from the environment in which the lambda expression is defined. We
accomplish this by creating a closure for each procedure we see,
and we save the environment in the closure. We call this technique
static binding of variables, or static scope. Lexical scope is a
kind of static scope.

Alternatively, we could implement our interpreters such that any
variables that occur free in the body of a procedure get their
values from the environment from which the procedure is called,
rather than from the environment in which the procedure is defined.

For example, consider what would happen if we were to evaluate the
following expression in an interpreter that used lexical scope:

(let ([x 2])
 (let ([f (lambda (e) x)])
   (let ([x 5])
     (f 0))))

Our lexical interpreter would add x to the environment with a
value of 2. For f, it would create a closure that contained the
binding of x to 2, and it would add f to the environment with
that closure as its value. Finally, the inner let would add x to
the environment with a value of 5. Then the call (f 0) would be
evaluated, but since it would use the value of x that was saved
in the closure (which was 2) rather than the value of x that was
current at the time f was called (which was 5), the entire
expression would evaluate to 2.

Under dynamic scope, we wouldn't save the value of x in the
closure for f. Instead, the application (f 0) would use the
value of x that was current in the environment at the time it was
called, so the entire expression would evaluate to 5.

|# 

#| 

4. Define value-of-dynamic, an interpreter that implements dynamic
scope. You can start with the dynamically-scoped interpreter we wrote
in class that used let and match. You should be able to share use
your environment helpers from a previous assignment, but you should
not implement an abstraction for closures in this
interpreter. Instead, the value of a lambda abstraction should be that
same lambda abstraction. In the same way the value of a number is that
same number. You'll find then, that when you go to evaluate an
application, there's only one environment in which you can evaluate
the body. This is a pretty simple change. To liven things up a
little (and also to allow us a more interesting test case), this
interpreter should also implement let, if, *, sub1, null?, zero?,
cons, car, cdr, and quote. When evaluating the expression (cons
1 (cons 2 '())) value-of-dynamic should return (1 2). Now quote is a
bit of a tricky beast. So here's the quote line for the interpreter.

[(quote ,v) v]

|# 

(check-true* equal?
  [(value-of-dynamic 
     '(let ([x 2])
        (let ([f (lambda (e) x)])
          (let ([x 5])
            (f 0))))
     (empty-env))
  5]
  [(value-of-dynamic
     '(let ([! (lambda (n)
                 (if (zero? n) 
                     1
                     (* n (! (sub1 n)))))])
        (! 5))
     (empty-env))
   120]
  [(value-of-dynamic
     '((lambda (!) (! 5))
         (lambda (n)
           (if (zero? n) 
               1
               (* n (! (sub1 n))))))
     (empty-env))
   120]
  [(value-of-dynamic
    '(let ([f (lambda (x) (cons x l))])
       (let ([cmap 
              (lambda (f)
                (lambda (l)               
                  (if (null? l) 
                      '()
                      (cons (f (car l)) ((cmap f) (cdr l))))))])
         ((cmap f) (cons 1 (cons 2 (cons 3 '())))))) 
    (empty-env))
   '((1 1 2 3) (2 2 3) (3 3))])

#| Brainteasers - 5400 Only |# 

#| 

5. We've discussed representation independence quite a bit. In solving
these problems we have duplicated significant amounts of code. Here we
will write a single curried function named ri-value-of-maker. That is,
we define an interpreter parameterized by the implementations of
environments and closures. letrec will improve your code. When given
those definitions, ri-value-of-maker returns an interpreter expecting
a single expression (Think---why does this interpreter only take in an
expression?) Include numbers, booleans, lambda-calculus expressions,
and your regular if, *, sub1, zero?, let, forms in your interpreter.

Your closure must now accept an additional arguments. So, you should
define new functions closure-fn-ri and apply-closure-fn-ri
closure-ds-ri and apply-closure-ds-ri to cleanly solve this
problem. 

|# 

(check-true* equal?
  [((value-of-ri empty-env-fn extend-env-fn apply-env-fn closure-fn-ri apply-closure-fn-ri)
    '((lambda (x) x) 5))
   5]
  [((value-of-ri empty-env-ds extend-env-ds apply-env-ds closure-ds-ri apply-closure-ds-ri)
    '((lambda (x) x) 5))
   5]
  [((value-of-ri empty-env-fn extend-env-fn apply-env-fn closure-ds-ri apply-closure-ds-ri)
    '((lambda (x) x) 5))
   5]
  [((value-of-ri empty-env-ds extend-env-ds apply-env-ds closure-fn-ri apply-closure-fn-ri)
    '((lambda (x) x) 5))
   5]) 

#| Just Dessert |#

#| 

6. In value–of-scopes, the values of our lambda expressions are
themselves transparent. The data are not buried behind #procedure or
some representation of a closure.

Another way to have transparent closures without changing the
program's semantics is to instead use direct substitution and treating
evaluation as a set of program rewrite rules

For example:


((lambda (x) (z x)) (lambda (y) y))

rewrites to

(z (lambda (y) y))

More formally, these grammars define our expressions and values

e ::= x (variables)
    | n (natural numbers 0, 1, ...)
    | b (booleans #t, #f)
    | (if e e e)
    | (zero? e)
    | (sub1 e)
    | (* e e)
    | (lambda (x) e)
    | (e e)

values
v ::= x
    | n
    | b
    | (lambda (x) v)

We define our main rewriting rule, beta-n, over this syntax.

((lambda (x) e1) e2) beta-n e1[e2/x]

This relation tells us that when we have an expression of the form:

((lambda (x) e1) e2)

We can rewrite it to the expression e1 where e2 has been substituted
for x. This substitution is not trivial, however, since it must not
change the scope of variables involved in the substitution. So, we
define e1[e2/x] as:

               x1[e/x1] = e
               x2[e/x1] = x2 if x1 is not x2
(lambda (x1) e1)[e2/x1] = (lambda (x1) e1)
(lambda (x1) e1)[e2/x2] = (lambda (x3) e1[x3/x1][e2/x2])
                          if x1 is not x2,
                             x2 is not x3,
                             x3 is not a free variable in (lambda (x1) e1)
                             and x3 is not a free variable in e2
          (e1 e2)[e3/x] = (e1[e3/x] e2[e3/x])
                 n[e/x] = n if n is a constant
    (if e1 e2 e3)[e4/x] = (if e1[e4/x] e2[e4/x] e3[e4/x])
       (zero? e1)[e2/x] = (zero? e1[e2/x])
                  and so on  ...

There are other rewriting rules for constants as well as for deciding
where in a nested expression to apply the next rewriting rule; we
include these in the provided starter code. 

If we rewrite a term until no more rewriting rules apply, we have
found a term's //normal form//, or we've encountered an error. This
process is called //normalization//. 

;; Example 1
   ((lambda (x) (+ x 3)) 5)
-> (+ 5 3)
-> 8 ;; normal form


;; Example 2
   ((lambda (x) (3 x)) 5)
-> (3 5) ;; error

You can use (gensym 'x) to get a new unique symbol. 

Complete the following definitions to implement normalization for
lambda. When you complete this problem you can reduce expressions in
this language to normal form. We make no use of an environment when
doing so. Also write tests for your code.

|#

(define (subst e^ x e)
  (match e
    [`,n #:when (number? n) n]
    [`,b #:when (boolean? b) b]
    [`(if ,e1 ,e2 ,e3)
     (let ([e1^ (subst e^ x e1)]
           [e2^ (subst e^ x e2)]
           [e3^ (subst e^ x e3)])
       `(if ,e1^ ,e2^ ,e3^))]
    [`(zero? ,e1)
     (let ([e1^ (subst e^ x e1)])
       `(zero? ,e1^))]
    [`(sub1 ,e1)
     (let ([e1^ (subst e^ x e1)])
       `(sub1 ,e1^))]
    [`(* ,e1 ,e2)
     (let ([e1^ (subst e^ x e1)]
           [e2^ (subst e^ x e2)])
       `(* ,e1^ ,e2^))]
    ;; Finish me!
    [`(,e1 ,e2)
     (let ([e1^ (subst e^ x e1)]
           [e2^ (subst e^ x e2)])
       `(,e1^ ,e2^))]))

(define (value? exp)
  (match exp
    [`,x #:when (symbol? x) #t]
    [`,n #:when (number? n) #t]
    [`,b #:when (boolean? b) #t]
    ;; Finish me!
    [else #f]))

(define (norm exp)
  (match exp
    [`,v #:when (value? v) v]
    [`(if #t ,conseq ,altern)
     (norm conseq)]
    [`(if #f ,conseq ,altern)
     (norm altern)]
    [`(if ,test ,conseq, altern)
     (let ([test^ (norm test)])
       (norm `(if ,test^ ,conseq ,altern)))]
    [`(zero? 0) #t]
    [`(zero? ,e)
     (let ([e^ (norm e)])
       (norm `(zero? ,e^)))]
    [`(sub1 ,n) #:when (number? n)
     (sub1 n)]
    [`(sub1 ,e)
     (let ([e^ (norm e)])
       (norm `(sub1 ,e^)))]
    [`(* ,n1 ,n2)
     #:when (and (number? n1) (number? n2))
     (* n1 n2)]
    [`(* ,n1 ,e)
     #:when (number? n1)
     (let ([e^ (norm e)])
       (norm `(* ,n1 ,e^)))]
    [`(* ,e1 ,e2)
     (let ([e1^ (norm e1)])
       (norm `(* ,e1^ e2)))]
    [`(lambda (,x) ,e)
     (let ([e^ (norm e)])
       (norm `(lambda (,x) ,e^)))]
    [`(,x ,v)
     #:when (and (symbol? x) (value? v))
     `(,x ,v)]
    [`(,x ,e)
     (guard (symbol? x))
     (let ([e^ (norm e)])
       (norm `(,x ,e^)))]
    [`((lambda (,x) ,e1) ,e2)
     ;; Finish me!
     ]
    [`(,e1 ,e2)
     (let ([e1^ (norm e1)])
       (norm `(,e1^ ,e2)))]
    [else (error 'norm "invalid expression ~s" x)]))
