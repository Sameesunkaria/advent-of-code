include "assert";

def binary: split("") | map(if . == "B" or . == "R" then 1 else 0 end);
def decimal: reduce .[] as $digit (0; . * 2 + $digit);
def missing: sort | [ range(.[0]; .[-1]+1) ] - .;

split("\n")[:-1] | map(binary | decimal)
| [
  (max),
  (missing | first)
]
| assert([933, 711])
