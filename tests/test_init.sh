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

test_envie_sourcing_works() {
    . "$envie_bin"
}

test_envie_is_function_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t envie) == "function" ]'
}

test_envie_help() {
    env -i "$envie_bin" help | grep 'Your virtual environments wrangler'
}

test_mkenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t mkenv) == "function" ] '\
                   '&& [ $(type -t mkenv2) == "function" ] '\
                   '&& [ $(type -t mkenv3) == "function" ]'
}

test_rmenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t rmenv) == "function" ]'
}

test_lsenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t lsenv) == "function" ]'
}

test_findenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t findenv) == "function" ]'
}

test_chenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t chenv) == "function" ]'
}

test_cdenv_present_after_sourcing() {
    env -i bash -c '. '"$envie_bin"' && [ $(type -t cdenv) == "function" ]'
}


unittest_main
