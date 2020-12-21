include "assert";

def intersect($arr): unique + ($arr | unique) | group_by(.) | map(select(length == 2)[0]);
def ingrs_without_algn($items): map(.) | add | ($items | map(.ingr) | add) - . | length;
def ingr_with_algn_names:
  to_entries | [., []] | until(first | length == 0; last as $item_algn 
    | first | map(.value -= ($item_algn | map(.item))) | sort_by(.value | length) 
    | [.[1:], $item_algn + [{algn:first.key, item:(first.value | first)}]]
  ) | last | sort_by(.algn) | map(.item) | join(",")
;

.[:-1]/"\n" | map(gsub("[\\(\\),]";"") | split(" contains "))
| map({ingr:(first/" "), algn:(last/" ")}) | . as $items
| reduce .[] as $item ({}; .[$item.algn[]] |= (. // $item.ingr | intersect($item.ingr)))
| [
  (ingrs_without_algn($items)),
  (ingr_with_algn_names)
]
| assert([2061, "cdqvp,dglm,zhqjs,rbpg,xvtrfz,tgmzqjz,mfqgx,rffqhl"])
