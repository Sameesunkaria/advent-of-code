include "assert";

def product: reduce .[] as $num (1; $num * .);
def parse: ./"\n" | { id: .[0][5:-1] | tonumber, image: .[1:] | map(./"") };
# [top, bottom, left, right] 🤦‍♂️ why did i order it this way?!
def straight_edges: [.[0], (.[-1] | reverse), (transpose | (.[0] | reverse), .[-1])];
# [top, bottom, left, right, -top, -bottom, -left, -right]
def edges: straight_edges | . + map(reverse);

def find_adj($images): 
  . as $img | .image | straight_edges | map(
    . as $e | $images | map(
      select(.id != $img.id) | . as $other_img 
      | .image | edges | index([$e]) | select(. != null) 
      | $other_img + {edge: .}
    ) | first
  )
;

def correct($n):
  if   $n == 0 then reverse                       # xflip
  elif $n == 1 then map(reverse)                  # yflip
  elif $n == 2 then reverse | transpose | reverse # rotate clockwise + xflip
  elif $n == 3 then transpose                     # rotate anti-clockwise + xflip
  elif $n == 4 then reverse | map(reverse)        # xflip + yflip
  elif $n == 5 then .                             # normal
  elif $n == 6 then transpose | reverse           # rotate anti-clockwise
  elif $n == 7 then reverse | transpose           # rotate clockwise
  else . end
;

def place_adj_images($pos):
  . as $adj_imgs
  | .[0] |= if not then . else . as $img 
    | .image |= correct([0, 1, 2, 3, 4, 5, 6, 7][$img.edge])
    | .pos |= [$pos[0]-1, $pos[1]]
  end
  | .[1] |= if not then . else . as $img 
    | .image |= correct([1, 0, 3, 2, 5, 4, 7, 6][$img.edge])
    | .pos |= [$pos[0]+1, $pos[1]]
  end
  | .[2] |= if not then . else . as $img 
    | .image |= correct([2, 3, 1, 0, 7, 6, 4, 5][$img.edge])
    | .pos |= [$pos[0], $pos[1]-1]
  end
  | .[3] |= if not then . else . as $img 
    | .image |= correct([3, 2, 0, 1, 6, 7, 5, 4][$img.edge])
    | .pos |= [$pos[0], $pos[1]+1]
  end
;

def place_all_blocks($img_blk_dim):
  (first + { pos: [0,0] }) as $first_img
  | [.[1:], [$first_img], [$first_img]] | until(
    first | length == 0; . as $inp
    | .[1] | map(. as $img | find_adj($inp[0]) | place_adj_images($img.pos))
    | flatten(1) | map(select(. != null)) | unique_by(.id)
    | ($inp[2] + .) as $placed_images
    | ($placed_images | map(.id)) as $placed_ids
    | [($inp[0] | map(select([.id] | inside($placed_ids) | not))) ,. , $placed_images]
  )
  | last | map({id, image, pos})
  | sort_by(.pos[0] * $img_blk_dim + .pos[1])
;

def construct_image($img_blk_dim; $block_dim):
  [_nwise($img_blk_dim)] | map(
    reduce .[] as $block ([range($block_dim-2) | []]; 
      to_entries | map(.value + $block.image[.key+1][1:-1])
    )
  ) | add
;

def monster_query($padding):
                    "#." + ([range($padding) | "."] | add) +
  "#....##....##....###" + ([range($padding) | "."] | add) +
  ".#..#..#..#..#..#"
;

def water_roughness($img_blk_dim; $block_dim):
  (flatten | map(select(. == "#")) | length) as $pound_count
  | [correct(range(8)) | add | add]
  | 20 as $monster_width
  | ($img_blk_dim * ($block_dim - 2) - $monster_width) as $padding
  | map([recurse(.[match(monster_query($padding)).offset+$monster_width:])] | length-1)
  | $pound_count - max * 15
;

./"\n\n" | .[:-1] | map(parse)
| (length | sqrt) as $img_blk_dim
| (first.image | length) as $block_dim
| place_all_blocks($img_blk_dim)
| [
  ([first, .[$img_blk_dim-1], .[-$img_blk_dim], last] | map(.id) | product),
  (construct_image($img_blk_dim; $block_dim) | water_roughness($img_blk_dim; $block_dim))
]
| assert([15003787688423, 1705])
