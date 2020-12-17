include "assert";

def next_state_for_adj($adj_cubes):
  if . == "." then if $adj_cubes | map(select(. == "#")) | length == 3 then "#" else "." end
  else if [$adj_cubes | map(select(. == "#")) | length] | inside([2,3]) then "#" else "." end
  end
;

def cube_in_3d($state): if any(. < 0) then "." else $state[.[0]][.[1]][.[2]] // "." end;

def adj_cubes_3d($state): 
  . as $index | [-2,-1,0] | [combinations(3)] - [[-1,-1,-1]]
  | map([., $index] | transpose | map(add) | cube_in_3d($state))
;

def next_state_3d: . as $old_state 
  | [
    [range(0;length+2)], 
    [range(0;first | length+2)], 
    [range(0;first | first | length+2)]
  ] | reduce combinations as $i (
    []; .[$i[0]][$i[1]][$i[2]] = (
      [$i, [-1,-1,-1]] | transpose | map(add)
      | cube_in_3d($old_state) | next_state_for_adj($i | adj_cubes_3d($old_state))
    )
  )
;

def cube_in_4d($state): if any(. < 0) then "." else $state[.[0]][.[1]][.[2]][.[3]] // "." end;

def adj_cubes_4d($state): 
  . as $index | [-2,-1,0] | [combinations(4)] - [[-1,-1,-1,-1]]
  | map([., $index] | transpose | map(add) | cube_in_4d($state))
;

def next_state_4d: . as $old_state 
  | [
    [range(0;length+2)], 
    [range(0;first | length+2)], 
    [range(0;first | first | length+2)],
    [range(0;first | first | first | length+2)]
  ] | reduce combinations as $i (
    []; .[$i[0]][$i[1]][$i[2]][$i[3]] = (
      [$i, [-1,-1,-1,-1]] | transpose | map(add)
      | cube_in_4d($old_state) | next_state_for_adj($i | adj_cubes_4d($old_state))
    )
  )
;

# 3D energy source config takes a few seconds to complete,
# while the 4D energy source config takes a few minutes.
.[:-1]/"\n" | map(./"")
| [
  (reduce range(0;6) as $_ ([.]; next_state_3d)),
  (reduce range(0;6) as $_ ([[.]]; next_state_4d))
] | map(flatten | map(select(. == "#")) | length)
| assert([348, 2236])
