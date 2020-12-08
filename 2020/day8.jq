include "assert";

def parse: 
  [to_entries[] | .key as $index | .value | split(" ") 
  | { inst: (.[0]), val: (.[1] | tonumber), index: $index }]
;

def execute_inst($state):
  .[$state.inst]
  | if   .inst == "acc" then { acc: ($state.acc + .val), inst: ($state.inst + 1) }
    elif .inst == "jmp" then { acc: ($state.acc),        inst: ($state.inst + .val) }
    else                     { acc: ($state.acc),        inst: ($state.inst + 1) } end
  | .visited = $state.visited + [$state.inst]
;

def did_finish_exec($prog): .inst == ($prog | length);
def run($state): 
  . as $prog | execute_inst($state) | . as $new_state
  | if (.visited | length) == (.visited | unique | length) 
    then if did_finish_exec($prog) then . else $prog | run($new_state) end
    else $state end
;

def run: run({ acc: 0, inst: 0, visited: [] });
def select_repairable_inst($prog): $prog[.] | select(.inst != "acc") | .index;
def inst_to_repair: . as $prog | run | .visited | map(select_repairable_inst($prog));
def attempt_repair($inst):
  .[$inst].inst 
  |= if  . == "jmp" then "nop" 
    elif . == "nop" then "jmp"
    else . end
;

def repair($indices):
  . as $prog | attempt_repair($indices[0]) | . as $fixed_prog | run
  | if did_finish_exec($prog) then $fixed_prog else $prog | repair($indices[1:]) end
;

split("\n")[:-1] | parse 
| [
  (run | .acc),
  (repair(inst_to_repair) | run | .acc)
] 
| assert([1501, 509])
