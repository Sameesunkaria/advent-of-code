# Advent of Code 2020

For AoC 2020, I will be solving the challenges using [jq](https://stedolan.github.io/jq/manual/). jq is a command-line tool and a functional programming language for processing json.

The output of the jq code is generally an array with two elements corrosponding to the answers for part 1 and 2 of the AoC challenge. Each file also asserts on the correct answers for the input files in this repository.

To run, make sure you are in this directory and use the following command:

**Day 1**: `jq -sf day1.jq input1.txt`

**Day 2**: `jq -Rsf day2.jq input2.txt`

**Day 3**: `jq -Rsf day3.jq input3.txt`

**Day 4**: `jq -Rsf day4.jq input4.txt`

**Day 5**: `jq -Rsf day5.jq input5.txt`

**Day 6**: `jq -Rsf day6.jq input6.txt`

**Day 7**: `jq -Rsf day7.jq input7.txt`

**Day 8**: `jq -Rsf day8.jq input8.txt`

**Day 9**: `jq -sf day9.jq input9.txt`

**Day 10**: `jq -sf day10.jq input10.txt`

**Day 11**: `jq -Rsf day11.jq input11.txt`

**Day 12**: `jq -Rsf day12.jq input12.txt`

**Day 13**: `jq -Rsf day13.jq input13.txt`

>**Note:** The result for this task requires greater precision than what is supported by a 64-bit floating point number. A bigint library for jq (`bitint.jq`) written by Peter Koppstein is used for all computations for day 13's second task. You can find the library on [GitHub](https://github.com/joelpurra/jq-bigint).

**Day 14**: `jq -Rsf day14.jq input14.txt`

**Day 15**: `jq -nf day15.jq`
