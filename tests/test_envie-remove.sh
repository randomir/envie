#!/usr/bin/env bash

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")
    polygon_dir=$(mktemp -d)
    cd "$polygon_dir"
    echo "(envie sourced from $envie_bin)"
    echo "(created polygon dir: $polygon_dir)"
}

teardown() {
    rm -rf "$polygon_dir"
    echo "(removed polygon dir: $polygon_dir)"
}

virtualenv_exists() {
    [ -e "$1/bin/activate_this.py" ] && [ -x "$1/bin/python" ]
}


test_envie_remove_help() {
    env -i "$envie_bin" remove -h | grep 'Remove (delete) the base directory'
}

test_envie_remove_error_outside_of_env() {
    env -i "$envie_bin" remove
    [ $? -eq 1 ]
}

test_envie_remove_error_nonexisting_virtualenv() {
    env -i VIRTUAL_ENV="$(mktemp -u)" "$envie_bin" remove
    [ $? -eq 1 ]
}

test_envie_remove_error_invalid_virtualenv() {
    local fakeenv=$(mktemp -p "$polygon_dir")
    env -i VIRTUAL_ENV="$fakeenv" "$envie_bin" remove
    [ $? -eq 1 ]
}

. $(dirname "$0")/unittest.inc && main