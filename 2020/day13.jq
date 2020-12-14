include "assert";
include "bigint";

def product: reduce .[1:][] as $num (.[0]; long_multiply($num; .));
def ladd: reduce .[1:][] as $num (.[0]; long_add($num; .));

def parse_bus: split(",") | [to_entries[] | select(.value | try tonumber)];
def parse: split("\n")[:-1] | .[0] |= tonumber | .[1] |= parse_bus;

def find_first_bus_result: 
  .[0] as $time 
  | .[1] | map(.value | tonumber | {bus: ., wait: (. - $time % .)})
  | sort_by(.wait)[0] | .bus * .wait
;

# Chinese remainder theorem using existence construction
# The result for this task requires greater precision than what is supported 
# by a 64-bit floating point number. A bigint library for jq written by 
# Peter Koppstein is used for all computations for part 2.
# https://github.com/joelpurra/jq-bigint
def find_golden_time:
  def extended_euclidean:
    if .r == "0" then . else 
      (long_divide(.oldr; .r)[0]) as $q 
      | { 
        oldr: .r, r: long_minus(.oldr; long_multiply($q; .r)), 
        olds: .s, s: long_minus(.olds; long_multiply($q; .s)),
        oldt: .t, t: long_minus(.oldt; long_multiply($q; .t)) 
      }
      | extended_euclidean
    end
  ;

  def bezout_coeff: 
    { oldr: .[0], r: .[1], olds: "1", s: "0", oldt: "0", t: "1" } 
    | extended_euclidean | [.olds, .oldt]
  ;

  def pos_remainder($mul): 
    long_divide(.; $mul)[1] 
    | if lessOrEqual("0"; .) then . else [$mul, .] | ladd end
  ;

  (map(.value) | product) as $product
  | map(
    ((-1 * .key) | tostring) as $off
    | (long_divide($product; .value)[0]) as $others_product
    | [.value, $others_product] | bezout_coeff[1] 
    | [., $others_product, $off] | product
  ) | ladd | pos_remainder($product)
;

parse 
| [
  (find_first_bus_result),
  (.[1] | find_golden_time)
] 
| assert([2305, "552612234243498"])
