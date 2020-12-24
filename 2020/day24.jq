include "assert";

def parse: 
  ["se", "sw", "ne", "nw"] as $diags
  | reduce $diags[] as $diag (.; gsub($diag; " \($diag) "))
  | split(" ") | map(
    select(length > 0) 
    | . as $sub | if $diags | index($sub) then . else split("") end
  ) | flatten
;

def move($dir):
  if   $dir == "e" then .[1] += 1
  elif $dir == "w" then .[1] -= 1
  elif $dir == "ne" then .[0] += 1
  elif $dir == "nw" then .[0] += 1 | .[1] -= 1
  elif $dir == "se" then .[0] -= 1 | .[1] += 1
  elif $dir == "sw" then .[0] -= 1
  else . end
;

def move_to_final: reduce .[] as $dir ([0,0]; move($dir));
def adj_hex: 
  . as $i | [[0,1],[0,-1],[1,0],[-1,0],[1,-1],[-1,1]] 
  | map([., $i] | transpose | map(add))
;

def new_state($prev_gen): 
  (adj_hex | map(select($prev_gen[tostring])) | length) as $adj_black
  | if $prev_gen[tostring] then if $adj_black == 0 or $adj_black > 2 then null else . end
  else if $adj_black == 2 then . else null end
  end
;

def next_gen: 
  . as $prev_gen | map(adj_hex) | flatten(1) | unique
  | reduce .[] as $i ({}; . + ($i | new_state($prev_gen) | select(.) | {(tostring): .}) // .)
;

def at_generation($gen): reduce range($gen) as $_ (.; next_gen);

.[:-1]/"\n" | map(parse | move_to_final) | group_by(.) 
| map(select(length | . % 2 == 1) | first | {(tostring): .}) | add
| [
  (length),
  (at_generation(100) | length)
]
| assert([346, 3802])
