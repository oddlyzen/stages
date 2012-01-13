Stages
------

A gem for creating data pipelines out of tiny, reusable objects

Initial code stolen shamelessly from http://pragdave.blogs.pragprog.com/pragdave/2008/01/pipelines-using.html

Usage
-----

You knit your stages together with '|'.  The leftmost pipeline stage will be contain a generator, which usually is an infinite loop.  For ean example, look at evens.rb in our sample stages collection.  If you wanted to output, for example, every even number divisible by 3, you might do:

```ruby
pipeline = Evens.new | MultiplesOf.new(3)
loop { puts pipeline.run }
```

We have included some general purpose stages, map and select, which can accomplish many pipeline operations:

```ruby
pipeline = Evens.new | Map.new{ |x| x * 3} | Select.new{ |x| x % 7 == 0}
(0..2).map{ |x| pipeline.run } #[0, 42, 84]}
```

Writing New Stages
------------------

If you are writing a stage that needs to process an element, you probably want to subclass Stage and implement handle_value.

If you are writing a generator, you probably want to subclass Stage and implement process

Stern Warnings
--------------

Returning nil from handle_value kills a pipeline.  We may change this behavior in the future, but for now, it makes life easy.


