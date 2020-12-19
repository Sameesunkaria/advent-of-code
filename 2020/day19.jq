include "assert";

def parse_rules:
  map( 
    ./":" | (.[0] | tonumber) as $index 
    | .[1][1:] | ./" | " | map(./" " | map(try tonumber // .[1:-1]))
    | if first | first | type == "string" then first | first else . end
    | { index: $index, values: . }
  ) | reduce .[] as $rule ([]; .[$rule.index] = $rule.values)
;

def match($rindex; $rules):
  . as $match_string 
  | if $rules[$rindex] | type == "string" then
    if .[:1] == $rules[$rindex] then [.[1:]] else [.] end
  else 
    $rules[$rindex] | map(
      reduce .[] as $sub_rulei ([$match_string];
        map(length as $len | match($sub_rulei; $rules)[] | select(length < $len))
      )
    ) | flatten
  end
;

def fix_rules: .[8] = [[42], [42,8]] | .[11] = [[42,31], [42,11,31]];
def matches($rulei; $rules): map(match($rulei; $rules) | select(index(""))) | length;

.[:-1]/"\n\n" | map(./"\n") | (.[0] | parse_rules) as $rules | .[1] 
| [
  (matches(0; $rules)),
  (matches(0; $rules | fix_rules))
]
| assert([239, 405])
