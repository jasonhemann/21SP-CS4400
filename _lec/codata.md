

# Data v. Codata

## Ordinary Data

When you define a datatype, you list out how to construct those
values:

```
List a = Nil | Cons a * List a
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
codata (lazy) stream a = 
```



## Acks. 

 In constructing these notes I referred to:
 
 - http://blog.ielliott.io/lambdas-are-codatatypes/
 
