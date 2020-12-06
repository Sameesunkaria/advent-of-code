include "assert";

def answers: [split("")[] | select(. != "\n")];
def any_answered: answers | unique | length ;
def answered_by($n): answers | group_by(.) | map(select(length == $n));
def all_answered: answered_by(split("\n") | length) | length;

.[:-1] | split("\n\n")
| [
  (map(any_answered) | add),
  (map(all_answered) | add)
]
| assert([6903, 3493])
