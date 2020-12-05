include "assert";

def parse:
  [ 
    match("([a-zA-Z]+):([a-zA-Z0-9#]+)"; "g") 
    | { (.captures[0].string): .captures[1].string }
  ] | add
;

def strict_test($re): . as $inp | match($re) | if .length == ($inp | length) then $inp else empty end;
def strict_match($re): . as $inp | match($re) | if .length == ($inp | length) then . else empty end;
def between($lower; $upper): select(. >= $lower and . <= $upper);

def check_height:
  strict_match("([0-9]+)(cm|in)") 
  | .captures[1].string as $unit 
  | .captures[0].string | tonumber
  | if $unit == "cm" then between(150; 193) else between(59; 76) end
;

def check: keys | contains(["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]);

def check2:
  [
    (.byr | try tonumber | between(1920; 2002)),
    (.iyr | try tonumber | between(2010; 2020)),
    (.eyr | try tonumber | between(2020; 2030)),
    (.hgt | check_height),
    (.hcl | strict_test("#[0-9a-f]{6}")),
    (.ecl | strict_test("(amb|blu|brn|gry|grn|hzl|oth)")),
    (.pid | strict_test("[0-9]{9}"))
  ] | length == 7
;

[split("\n\n")[] | select(length > 0) | parse] 
| [
  (map(select(check)) | length),
  (map(select(check) | select(check2)) | length)
]
| assert([219, 127])
