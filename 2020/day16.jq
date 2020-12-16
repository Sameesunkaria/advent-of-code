include "assert";

def product: reduce .[] as $num (1; $num * .);
def parse_fields: 
  ./"\n" | map(
    match("([a-z ]+): (\\d+)-(\\d+) or (\\d+)-(\\d+)").captures
    | {
      name: .[0].string, 
      valid: .[1:] | map(.string | tonumber) | [_nwise(2) | range(first; last+1)]
    }
  )
;

def find_invalid: 
  (.[0] | map(.valid) | add) as $valid_nums 
  | .[2] | flatten | map(select([.] | inside($valid_nums) | not))
  | add
;

def discard_invalid:
  (.[0] | map(.valid) | add) as $valid_nums 
  | .[2] | map(select(inside($valid_nums)))
;

def find_fields:
  .[0] as $fields
  | .[2] | transpose | map(
    . as $values | $fields | map(select(.valid | contains($values)) | .name)
  )
  | to_entries | map({key, possible: .value}) | sort_by(.possible | length)
  | reduce .[] as $field (
    []; . + [($field.possible - map(.value)) | {key: $field.key, value: first}]
  ) | sort_by(.key) | map(.value)
;

def find_departures:
  .[2] = discard_invalid
  | [.[1], find_fields] 
  | transpose | map(select(last | contains("departure")) | first) 
  | product
;

.[:-1]/"\n\n" 
| .[0] |= parse_fields 
| .[1] |= ((./"\n")[1]/"," | map(tonumber))
| .[2] |= ((./"\n")[1:] | map(./"," | map(tonumber)))
| [
  (find_invalid),
  (find_departures)
]
| assert([21996, 650080463519])
