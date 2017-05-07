#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")
    echo "(using envie from $envie_bin)"
}


test_envie_bin_found() {
    [ -x "$envie_bin" ]
}

test_envie_help() {
    "$envie_bin" help | grep 'Your virtual environments wrangler'
}

test_envie_sourcing_works() {
    . "$envie_bin"
}

test_envie_functions_present_after_sourcing() (
    . "$envie_bin"
    [ "$(type -t envie)" == "function" ]
    [ "$(type -t mkenv)" == "function" ]
    [ "$(type -t mkenv2)" == "function" ]
    [ "$(type -t mkenv3)" == "function" ]
    [ "$(type -t rmenv)" == "function" ]
    [ "$(type -t lsenv)" == "function" ]
    [ "$(type -t findenv)" == "function" ]
    [ "$(type -t chenv)" == "function" ]
    [ "$(type -t cdenv)" == "function" ]
)


unittest_main
