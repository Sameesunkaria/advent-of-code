include "assert";

def db2: if . % 1000 == 0 then debug else . end;
def initial_state: reduce to_entries[] as $i ([]; .[$i.value + 1] = $i.key);
def index_for_max_value: 
  . as $arr | reduce range(0;length) as $i (
    [0,.[0]]; 
    if $arr[$i] >= .[1] then [$i, $arr[$i]] else . end
  ) | .[0]
;

def play($turns):
  initial_state as $init
  | reduce range(length; $turns) as $turn (
    $init;
    (if .[0] == null then 1 else .[0] + 1 end) as $num_spoken
    | if .[$num_spoken] != null then
      .[0] = $turn - .[$num_spoken]
      | .[$num_spoken] = $turn
    else
      .[0] = null
      | .[$num_spoken] = $turn
    end
  ) | index_for_max_value - 1
;

# This may take a few minutes to execute.
[1,2,16,19,18,0]
| [
  play(2020),
  play(30000000)
]
| assert([536, 24065124])
