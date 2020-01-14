# Array#reduce_to_hash
This gem adds method `#reduce_to_hash` to `Array`. This method is used to extract out an 'index' of sorts from an array of objects or hashes. 

For each element in the array, this method will apply a mapping function to produce a key/value pair representing that element in
a resulting hash.

## Arbitrary transformations using blocks
In the most general case, the mapping function is given as a block; this block is invoked on each
successive element of the array, and each time it is expected to return a hash containing a single entry 
(a single name=>value). That entry gets merged into the result hash.

### Example:
```ruby
User.all.to_a.reduce_to_hash { |u| { u.email => "#{u.first_name} #{u.last_name}" } }
```

It is also possible for the mapping function to generate computed keys; they don't have to be keys extracted directly from the array elements.

### Example
```
2.5.1 :007 > awesome_print (1..10).to_a.reduce_to_hash { |n| { n**n => n } }
{
              1 => 1,
              4 => 2,
             27 => 3,
            256 => 4,
           3125 => 5,
          46656 => 6,
         823543 => 7,
       16777216 => 8,
      387420489 => 9,
    10000000000 => 10
}
```

If the mapping function (block) returns nil, then that element is simply skipped. This is akin to combining
a `.select` and `.reduce`.

### Example
```ruby
User.all.to_a.reduce_to_hash do |u| 
  { u.email => "#{u.first_name} #{u.last_name}" } unless u.demo_account
end
```

## :key_prop => :value_prop
As a special case, if the desired mapping is something like:

```ruby
do |el|
  el.prop1 => el.prop2
end
```

instead of the block above, you can use `:prop1 => :prop2`

### Example:
```ruby
User.all.to_a.reduce_to_hash :id => :email
```

It's also possible to use this form on arrays of hashes, where in the symbols will be handled
as hash lookups rather than method calls.


## :key_prop
As an even more specialized case, but one that is in fact fairly common, if what you want is `:prop1 => :itself`
you can further abbreviate that to simply `:prop1`

### Example:
```ruby
User.all.to_a.reduce_to_hash :email
```


