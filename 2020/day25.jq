 include "assert";
 
 . as $pub_keys 
| [1, 0] | until([first] | inside($pub_keys); first = first * 7 % 20201227 | last += 1)
| last as $loop_size 
| ($pub_keys - [first] | first) as $other_pub_key
| reduce range($loop_size) as $_ (1; . * $other_pub_key % 20201227)
| assert(17032383)
