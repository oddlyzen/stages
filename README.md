Stages
------

A gem for creating data pipelines out of tiny, reusable objects

Initial code stolen shamelessly from http://pragdave.blogs.pragprog.com/pragdave/2008/01/pipelines-using.html

Announcement blog post is at http://blog.igodigital.com/blog/on-recommendations/the-stages-gem

Usage
-----

You knit your stages together with '|'.  The leftmost pipeline stage will contain a generator, which usually is an infinite loop.  

Example
-------

Image you wanted to output every even number divisible by 3.  First you would need a class that would output even numbers.  Then you would want to select the ones that are divisible by 3.  A simple implementation using stages would like this

```ruby
pipeline = Evens.new | Select.new{ |x| x % 3 == 0}
loop { puts pipeline.run }
```

We have included some general purpose stages, map and select, which can accomplish many pipeline operations:

```ruby
pipeline = Evens.new | Map.new{ |x| x * 3} | Select.new{ |x| x % 7 == 0}
3.times{ pipeline.run } #[0, 42, 84]}
```

Writing New Stages
------------------

If you are writing a stage that needs to process an element, you probably want to subclass Stage and implement handle_value.

If you are writing a generator, you probably want to subclass Stage and implement process

Stern Warnings
--------------

Returning nil from handle_value kills a pipeline.  We may change this behavior in the future, but for now, it makes life easy.


