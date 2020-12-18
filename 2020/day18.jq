include "assert";

def to_rpn($ops):
  reduce .[] as $token (
    {output:[], stack:[]};
    if $token| try tonumber // false then
      .output += [$token | tonumber]
    elif [$token] | inside($ops | keys) then
      until(
        (.stack | last == null) or $ops[.stack | last] < $ops[$token];
        .output += [.stack | last] | .stack = .stack[:-1]
      ) | .stack += [$token]
    elif $token == "(" then
      .stack += [$token]
    elif $token == ")" then 
      until(.stack | last == "("; .output += [.stack | last] | .stack = .stack[:-1])
      | .stack = .stack[:-1]
    else . end
  ) | .output + (.stack | reverse)
;

def eval: 
  reduce .[] as $token (
    []; if [$token] | inside(["+", "*"]) then 
      .[:-2] + [if $token == "+" then .[-2] + .[-1] else .[-2] * .[-1] end]
    else . + [$token]  end
  ) | first
;

./"\n" | .[:-1] | map(gsub("\\("; "( ") | gsub("\\)"; " )")/" ")
| [
  (map(to_rpn({"*": 1, "+": 1}) | eval) | add),
  (map(to_rpn({"*": 1, "+": 2}) | eval) | add)
]
| assert([50956598240016, 535809575344339])
