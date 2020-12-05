include "assert";

def product: reduce .[] as $num (1; $num * .);

# combinations(3) takes several seconds.
[
  ([combinations(2) | select(add == 2020)][0] | product),
  ([combinations(3) | select(add == 2020)][0] | product)
]
| assert([1010299, 42140160])
