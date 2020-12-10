include "assert";

def groups($s; $i): if $i + $s <= length then [.[$i:$i+$s]] + groups($s; $i+1) else [] end;
def groups($s): groups($s;0);
def product: reduce .[] as $num (1; $num * .);

def add_bounds: [0] + . + [.[-1] + 3];
def take_diff_3($arr): $arr[.] as $num | $arr[.+1:.+4] | map(select(. <= $num+3));
def find_next_options: . as $arr | [to_entries[] | .key | { num: $arr[.], opts: take_diff_3($arr) }];
def comb_count($opts): . as $prev_opts | $opts | map($prev_opts[tostring] // 1) | add;
def valid_comb_count($num_opts): .[$num_opts.num | tostring] = comb_count($num_opts.opts);
def total_combinations: reduce .[] as $num_opts ({}; valid_comb_count($num_opts));

def all_adapters_value: groups(2) | map(.[1] - .[0]) | group_by(.) | map(length) | product;
def adapter_combinations: find_next_options | reverse | total_combinations["0"];

sort | add_bounds
| [
  (all_adapters_value),
  (adapter_combinations)
]
| assert([2176, 18512297918464])
