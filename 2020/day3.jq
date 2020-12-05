include "assert";

def product: reduce .[] as $num (1; $num * .);
def is_tree: (.key % (.value | length)) as $index | .value[$index:$index+1] == "#";
def rows_for_down_slope($step): [to_entries[] | select(.key % $step == 0) | .value];
def trees_hit($side_step): 
  [to_entries[] | (.key *= $side_step) | select(is_tree)] 
  | length
;

def trees_hit_on_path($down; $side): rows_for_down_slope($down) | trees_hit($side);
def trees_hit_on_all_paths_result:
[
  (trees_hit_on_path(1; 1)),
  (trees_hit_on_path(1; 3)),
  (trees_hit_on_path(1; 5)),
  (trees_hit_on_path(1; 7)),
  (trees_hit_on_path(2; 1))
] | product
;

split("\n")[:-1]
| [
  (trees_hit_on_path(1; 3)),
  (trees_hit_on_all_paths_result)
]
| assert([228, 6818112000])
