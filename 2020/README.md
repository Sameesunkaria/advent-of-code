# Advent of Code 2020

For AoC 2020, I will be solving the challenges using [jq](https://stedolan.github.io/jq/manual/). jq is a command-line tool and a functional programming language for processing json.

The output of the jq code is generally an array with two elements corrosponding to the answers for part 1 and 2 of the AoC challenge. Each file also asserts on the correct answers for the input files in this repository.

To run, make sure you are in this directory and use the following command:

#### Day 1
```
jq -sf day1.jq input1.txt
```

#### Day 2
```
jq -Rsf day2.jq input2.txt
```
