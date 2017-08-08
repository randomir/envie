#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")
    sandbox_dir=$(abspath "$(mktemp -d)")
    cd "$sandbox_dir"
    echo "(envie sourced from $envie_bin)"
    echo "(created sandbox dir: $sandbox_dir)"
}

teardown() {
    rm -rf "$sandbox_dir"
    echo "(removed sandbox dir: $sandbox_dir)"
}

virtualenv_exists() {
    [ -e "$1/bin/activate" ] && [ -x "$1/bin/python" ]
}


test_envie_remove_help() {
    "$envie_bin" remove -h | grep 'Remove (delete) the base directory'
}

test_envie_remove_error_outside_of_env() {
    env -u VIRTUAL_ENV "$envie_bin" remove || [ $? -eq 1 ]
}

test_envie_remove_error_nonexisting_virtualenv() {
    env VIRTUAL_ENV="$(mktemp -u)" "$envie_bin" remove || [ $? -eq 1 ]
}

test_envie_remove_error_invalid_virtualenv() {
    local fakeenv=$(mktemp -p "$sandbox_dir")
    env VIRTUAL_ENV="$fakeenv" "$envie_bin" remove || [ $? -eq 1 ]
}


unittest_main
