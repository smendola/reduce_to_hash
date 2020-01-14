# Array#reduce_to_hash
This gem adds method #reduce_to_hash to Array. This method is used to extract out an 'index' of sorts from an array of objects or hashes.
For each element in the array, this method will apply a mapping function to produce a key/value pair representing that element in
a resulting hash.

In the most general case, the mapping function is given as a Ruby block, and is expected to return a hash
containing a single entry (e.g. name=>value). That entry gets merged into the result hash.

As a special case, if the desired mapping is something like:

```ruby
do |el|
  el.prop1 => el.prop2
end
```

instead of the block above, you can use `:prop1 => :prop2`

e.g.
```TODO```

As a further specialized case, if what you want is `:prop1 => :itself`
you can further abbreviate that to simply `:prop1`
e.g.
```TODO```


