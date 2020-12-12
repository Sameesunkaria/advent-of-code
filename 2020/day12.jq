include "assert";

def parse: { act: .[0:1], val: .[1:] | tonumber };
def abs: if . < 0 then -1 * . else . end;
def distance: (.x | abs) + (.y | abs);
def rotate($val; $mul): reduce range(0; $val/90) as $_ (.; {x: ($mul*.y), y: (-1*$mul*.x)});

def execute1($inst): 
  if   $inst.act == "N" then .y += $inst.val
  elif $inst.act == "S" then .y -= $inst.val
  elif $inst.act == "E" then .x += $inst.val
  elif $inst.act == "W" then .x -= $inst.val
  elif $inst.act == "F" then .x += ($inst.val * .dir.x) | .y += ($inst.val * .dir.y)
  elif $inst.act == "R" then .dir = (.dir | rotate($inst.val; 1))
  elif $inst.act == "L" then .dir = (.dir | rotate($inst.val; -1))
  else . end
;

def execute2($inst): 
  if   $inst.act == "N" then .wpt.y += $inst.val
  elif $inst.act == "S" then .wpt.y -= $inst.val
  elif $inst.act == "E" then .wpt.x += $inst.val
  elif $inst.act == "W" then .wpt.x -= $inst.val
  elif $inst.act == "F" then .ship.x += ($inst.val * .wpt.x) | .ship.y += ($inst.val * .wpt.y)
  elif $inst.act == "R" then .wpt = (.wpt | rotate($inst.val; 1))
  elif $inst.act == "L" then .wpt = (.wpt | rotate($inst.val; -1))
  else . end
;

def navigate1: reduce .[] as $inst ({x: 0, y: 0, dir: {x: 1, y: 0}}; execute1($inst));
def navigate2: reduce .[] as $inst ({ship: {x: 0, y: 0}, wpt: {x: 10, y: 1}}; execute2($inst));

split("\n")[:-1] | map(parse) 
| [
  (navigate1 | distance),
  (navigate2 | .ship | distance)
]
| assert([2057, 71504])
