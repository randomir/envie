#!/bin/bash

test_envie_create_help() {
    local bin=$(which envie)
    env -i "$bin" create -h | grep 'Create Python (2/3) virtual environment'
}

test_envie_create() {
    local dir=$(mktemp -u)
    env -i "$(which envie)" create "$dir"
    test -e "$dir/bin/python"
    local code=$?
    rm -rf "$dir"
    return $code
}

test_envie_create_2() {
    command -v python2 >/dev/null 2>&1 || return 0
    local dir=$(mktemp -u)
    env -i "$(which envie)" create -2 "$dir"
    test -e "$dir/bin/python" && "$dir/bin/python" -V 2>&1 | grep "^Python 2"
    local code=$?
    rm -rf "$dir"
    return $code
}

test_envie_create_3() {
    command -v python3 >/dev/null 2>&1 || return 0
    local dir=$(mktemp -u)
    env -i "$(which envie)" create -3 "$dir"
    test -e "$dir/bin/python" && "$dir/bin/python" -V 2>&1 | grep "^Python 3";
    local code=$?
    rm -rf "$dir"
    return $code
}


. unittest.inc && main
