include "assert";

def filter_words: ["contain", "bag", "bags", "bag,", "bags,", "bag.", "bags.", "no", "other"];
def in_arr($arr): . as $e | $arr | index($e) | if . == null then false else true end;
def arr_contains($e): . as $arr | $e | in_arr($arr); 

def clean_input: [split(" ")[] | select(in_arr(filter_words) | not)];
def inner_bags: { color: (.[1:3] | join(" ")), quantity: (.[0] | tonumber) };
def parse_inner: [_nwise(3) | if length == 3 then inner_bags else empty end];
def parse: { color: (.[0:2] | join(" ")), contains: (.[2:] | parse_inner) };

def bag_has_color($color): select(.contains | map(.color) | arr_contains($color));
def find_all_bags($color): 
  . as $all_colors | map(bag_has_color($color) | .color)
  | if length == 0 then []
    else . + ([.[] as $c | $all_colors | find_all_bags($c)] | flatten) | unique end
;

def find_inner($color): 
  . as $all_colors 
  | .[] | select(.color == $color).contains
  | if length == 0 then 0
    else [.[] | (.quantity) + (.quantity) * (.color as $c | $all_colors | find_inner($c))] | add 
    end
;

split("\n")[:-1] | map(clean_input | parse) 
| [
  (find_all_bags("shiny gold") | length),
  (find_inner("shiny gold"))
]
| assert([124, 34862])
