include "assert";

def score: [.a, .b] | flatten | reverse | to_entries | map((.key+1) * .value) | add;
def round_won($winner): 
  if $winner == .a 
  then .a = .a[1:] + [.a[0], .b[0]] | .b = .b[1:]
  else .b = .b[1:] + [.b[0], .a[0]] | .a = .a[1:]
  end
;

def combat:
  {a: first, b: last} | until(
    [.a, .b] | any(length == 0); 
    if .a[0] > .b[0] then round_won(.a) else round_won(.b) end
  )
;

def recursive_combat:
  {a: first, b: last, played: {}} | until(
    ([.a, .b] | any(length == 0)) or (.played[[.a, .b] | tostring]); 
    .played[[.a, .b] | tostring] = true
    | if [.a, .b] | all(first < length) then
      if [.a, .b] | map(.[1:first+1]) | recursive_combat.a | length > 0 
      then round_won(.a) else round_won(.b) end
    elif .a[0] > .b[0] then round_won(.a) else round_won(.b) end
  ) | if [.a, .b] | all(length > 0) then {a, b:[]} else . end
;

.[:-1]/"\n\n" | map(./"\n" | .[1:] | map(tonumber))
| [
  (combat | score),
  (recursive_combat | score)
]
| assert([30197, 34031])
