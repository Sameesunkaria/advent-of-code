include "assert";

def index_factors: [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [-1, 1], [1, -1], [-1, -1]];
def is_seat: . != ".";
def is_occupied: . == "#";
def seat_from_offset($y; $x): [$y+.[0], $x+.[1]];
def seat_at_index($seats): $seats[.[0]][.[1]];
def valid_index($seats): map(. >= 0) | all and .[0] < ($seats | length) and .[1] < ($seats[0] | length);

def adj_seat_in_dir($y; $x; $seats): 
  seat_from_offset($y; $x) 
  | select(valid_index($seats)) 
  | seat_at_index($seats)
;

def vis_seat_in_dir($y; $x; $seats; $mul): 
  . as $dir | map(. * $mul) | seat_from_offset($y; $x)
  | if valid_index($seats)
    then seat_at_index($seats)
      | if is_seat then . else $dir | vis_seat_in_dir($y; $x; $seats; $mul+1) end
    else "."
    end
;

def adj_seats($y; $x): . as $seats | index_factors | map(adj_seat_in_dir($y; $x; $seats)); 
def visible_seats($y; $x): . as $seats | index_factors | map(vis_seat_in_dir($y; $x; $seats; 1));

def new_state_for_seat($adj; $max_occ): 
  if is_seat | not then "."
  elif is_occupied then if $adj | map(select(is_occupied)) | length >= $max_occ then "L" else "#" end
  else if $adj | map(is_occupied) | any then "L" else "#" end
  end
;

def max_occ: if . == "vis" then 5 else 4 end;
def find_seats($kind; $y; $x): 
  if $kind == "vis" then visible_seats($y; $x) 
  else adj_seats($y; $x) end
;

def next_state($kind): 
  . as $seats | to_entries 
  | map(.key as $y | .value | to_entries 
    | map(.key as $x | .value 
      | new_state_for_seat($seats | find_seats($kind; $y; $x); $kind | max_occ)
    )
  )
;

def final_state($kind): next_state($kind) as $ns | if . == $ns then . else $ns | final_state($kind) end;
def count_occupied: map(map(select(is_occupied)) | length) | add;

# Takes a few minutes to complete. I wasn't able to spot any 
# obvious reason for the slow performance. 
split("\n")[:-1] | map(split("")) 
| [
  (final_state("adj") | count_occupied),
  (final_state("vis") | count_occupied)
]
| assert([2238, 2013])
