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
