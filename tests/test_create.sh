#!/bin/bash

setup() {
    envie_bin=$(which envie)
    polygon_dir=$(mktemp)
    echo "(using envie from $envie_bin)"
    echo "(created polygon dir: $polygon_dir)"
}

teardown() {
    rm -rf "$polygon_dir"
    echo "(removed polygon dir: $polygon_dir)"
}

test_envie_create_help() {
    env -i "$envie_bin" create -h | grep 'Create Python (2/3) virtual environment'
}

test_envie_create() {
    local dir=$(mktemp -u)
    env -i "$envie_bin" create "$dir"
    test -e "$dir/bin/python"
    local code=$?
    rm -rf "$dir"
    return $code
}

test_envie_create_2() {
    command -v python2 >/dev/null 2>&1 || return 0
    local dir=$(mktemp -u)
    env -i "$envie_bin" create -2 "$dir"
    test -e "$dir/bin/python" && "$dir/bin/python" -V 2>&1 | grep "^Python 2"
    local code=$?
    rm -rf "$dir"
    return $code
}

test_envie_create_3() {
    command -v python3 >/dev/null 2>&1 || return 0
    local dir=$(mktemp -u)
    env -i "$envie_bin" create -3 "$dir"
    test -e "$dir/bin/python" && "$dir/bin/python" -V 2>&1 | grep "^Python 3";
    local code=$?
    rm -rf "$dir"
    return $code
}


. $(dirname "$0")/unittest.inc && main
