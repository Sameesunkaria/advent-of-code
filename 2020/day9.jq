include "assert";

def groups($s; $i): if $i + $s <= length then [.[$i:$i+$s]] + groups($s; $i+1) else [] end;
def groups($s): groups($s;0);

def isvalid: .[25] as $num | .[0:25] | [combinations(2)| add] | contains([$num]);

def find_range($num; $starti; $endi): 
  (.[$starti:$endi] | add) as $sum
  | if $sum == $num then .[$starti:$endi] | sort
  elif $sum > $num then find_range($num; $starti+1; $endi)
  else find_range($num; $starti; $endi+1) end
;

(groups(26) | map(select(isvalid | not)[-1])[-1]) as $num
| [
  ($num),
  (find_range($num;0;2) | .[0] + .[-1])
]
| assert([50047984, 5407707])
