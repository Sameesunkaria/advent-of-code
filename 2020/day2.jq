include "assert";

def parse:
  match("([0-9]+)-([0-9]+) ([a-zA-Z]): ([a-zA-Z]+)").captures
  | {
    num1: (.[0].string | tonumber),
    num2: (.[1].string | tonumber),
    char: (.[2].string),
    password: (.[3].string)
  }
;

def check:
  . as $inp
  | [.password | match($inp.char; "g")] | length
  | . >= $inp.num1 and . <= $inp.num2
;

def check2:
  . as $inp | [
    .password | match($inp.char; "g") | .offset + 1
    | select(. == $inp.num1 or . == $inp.num2)
  ] | length == 1
;

[split("\n")[] | parse] 
| [ 
  (map(select(check)) | length), 
  (map(select(check2)) | length)
]
| assert([422, 451])