include "assert";

def cycled($length): if . <= 0 then $length + . else . end;
def cup_sequence: [.,[1]] | until(first[last[-1]] == 1; last += [first[last[-1]]]) | last;
def result1: cup_sequence | .[1:] | map(tostring) | add | tonumber;
def result2: .[1] * .[.[1]];

def create_chain: 
  first as $start | [., .[1:] + [first]] | transpose
  | reduce .[] as $cup ([]; .[$cup[0]] = $cup[1]) | first = $start
;

def create_padded_chain($len):
  first as $start | last as $last | create_chain | .[$last] = length
  | . + [range(length+1; $len+2)] | last = $start
;

def predict($moves):
  (length - 1) as $length 
  | reduce range($moves) as $i (.; first as $current 
    | [.[first], .[.[first]], .[.[.[first]]]] as $cups_to_move
    | ([range(1;5) | $current - . | cycled($length)] | . - $cups_to_move | first) as $next
    | first = .[$cups_to_move | last] 
    | .[$current] = .[$cups_to_move | last] 
    | .[$cups_to_move | last] = .[$next]
    | .[$next] = ($cups_to_move | first)
  )
;

"123487596"/"" | map(tonumber)
| [
  (create_chain | predict(100) | result1),
  (create_padded_chain(1000000) | predict(10000000) | result2)
]
| assert([47598263, 248009574232])
