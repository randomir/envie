#!/bin/bash
# Simple bash unit tests: discovery and runner with assertions.
#
# Usage. Source this file from the end of your tests file:
#   . unittest.inc && main
#
# Your tests file should contain unit tests as shell functions named `test_...`.
# Tests will be run in the order they are defined in the file, testing the exit
# code for success (asserting exit code is zero).


# Define ansi coloring sequences ONLY if output to terminal and it supports colors.
# NOTE: ncurses is required, but it gracefully fails-back to no-color if not present.
if [ -t 1 ] && [ -n "$(which tput)" ] && (( $(tput colors) >= 8 )); then
    ANSI_RESET=$(tput sgr0)
    ANSI_BOLD=$(tput bold)
    ANSI_DEFAULT=$(tput setaf 9)
    ANSI_BLACK=$(tput setaf 0)
    ANSI_RED=$(tput setaf 1)
    ANSI_GREEN=$(tput setaf 2)
fi


assert() {
    local fn="$1" out
    echo -n "- ${fn}..."
    out=$(eval "set -e; $fn" 2>&1)
    if (( $? )); then
        echo -e "${ANSI_RED}ERROR!${ANSI_RESET}"
        echo "$out"
        return 1
    else
        echo -e "${ANSI_GREEN}OK${ANSI_RESET}"
        return 0
    fi
}


main() {
    local testfile="$0" collection=$(basename "$0") tests
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
    echo -e "Running ${ANSI_BOLD}${cnt}${ANSI_RESET} tests from ${ANSI_BOLD}${collection}${ANSI_RESET}:"

    # setup
    if [ "$(type -t setup)" == "function" ] && ! setup; then
        echo -en "${ANSI_BOLD}${collection}${ANSI_RESET}: "
        echo -e "${ANSI_RED}${ANSI_BOLD}Setup failed. Skipping test suite.\n${ANSI_RESET}"
        return 3
    fi

    # run all tests
    local some_tests_failed=0
    for test in $tests; do
        ! assert "$test" && some_tests_failed=1
    done

    # teardown
    if [ "$(type -t teardown)" == "function" ] && ! teardown; then
        echo -en "${ANSI_BOLD}${collection}${ANSI_RESET}: "
        echo -e "${ANSI_RED}${ANSI_BOLD}Teardown failed.\n${ANSI_RESET}"
        return 4
    fi

    echo -en "${ANSI_BOLD}${collection}${ANSI_RESET}: "
    if (( some_tests_failed )); then
        echo -e "${ANSI_RED}${ANSI_BOLD}FAILED!\n${ANSI_RESET}"
        return 5
    else
        echo -e "${ANSI_GREEN}${ANSI_BOLD}OK.\n${ANSI_RESET}"
        return 0
    fi
}
