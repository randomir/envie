#!/bin/bash
# Simple bash unit tests: discovery and runner with assertions.
#
# Usage. Source this file from the end of your tests file:
#   . unittest.inc && main
#
# Your tests file should contain unit tests as shell functions named `test_...`.
# Tests will be run in the order they are defined in the file, testing the exit
# code for success (asserting exit code is zero).


assert() {
    local fn="$1" out
    echo -n "${fn}..."
    out=$(eval "$fn" 2>&1)
    if (( $? )); then
        echo "FAILED!"
        echo "$out"
        return 1
    else
        echo "OK"
        return 0
    fi
}

main() {
    local testfile="$0" tests
    if [ ! -r "$testfile" ]; then
        echo "Invalid testfile: $testfile"
        return 1
    fi
    tests=$(grep -Po "^test_\w+" "$testfile")
    if (( $? )); then
        echo "Tests discovery failed."
        return 2
    fi

    local cnt=$(wc -l <<<"$tests")
    echo "Running $cnt tests:"

    for test in $tests; do
        assert "$test"
    done
}
