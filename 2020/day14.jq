include "assert";

def decimal: reduce (.[] | tonumber) as $digit (0; . * 2 + $digit);
def binary: if . == 0 then [] else (. / 2 | floor | binary) + [(. % 2 | tostring)] end;
def lpad($len): if length == $len then . else (["0"] + .) | lpad($len) end;
def replacing($index; $value): .[0:$index] + [$value] + .[$index+1:];

def parse: 
  def parse_mem: 
    match("mem\\[([0-9]+)\\] = ([0-9]+)").captures 
    | { addr: .[0].string, value: (.[1].string | tonumber) }
  ;

  split("mask = ")[1:] | map(split("\n") 
  | { mask: .[0] | split(""), mems: (.[1:] | map(parse_mem)) })
;

def apply_mask_to_value: 
  def apply_mask($mask): 
    lpad($mask | length) | to_entries
    | map(if $mask[.key] == "X" then .value else $mask[.key] end)
  ;

  .mask as $mask | .mems 
  | map({ (.addr): .value | binary | apply_mask($mask) | decimal })
;

def apply_mask_to_addr:
  def combinations_for_index($i): 
    if .[$i] == "X" then [replacing($i; "0"), replacing($i; "1")] 
    else [.] end
  ;

  def all_bin_combinations: reduce range(0; length) as $i ([.]; map(combinations_for_index($i)[]));

  def all_addrs_with_mask($mask):
    tonumber | binary | lpad($mask | length) | to_entries
    | map(if $mask[.key] == "0" then .value else $mask[.key] end)
    | all_bin_combinations | map(decimal | tostring)
  ;

  .mask as $mask | .mems 
  | map(.value as $val | .addr | all_addrs_with_mask($mask)[] | {(.): $val})
;

def final_mem_sum: map(add) | [add[]] | add;

.[:-1] | parse 
| [
  (map(apply_mask_to_value) | final_mem_sum),
  (map(apply_mask_to_addr) | final_mem_sum)
]
| assert([12610010960049, 3608464522781])
