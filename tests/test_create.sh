#!/bin/bash

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")
    polygon_dir=$(mktemp -d)
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

test_envie_create_defaults() (
    cd "$polygon_dir"
    env -i "$envie_bin" create
    test -e "./env/bin/python"
)

test_envie_create_custom_envname() (
    cd "$polygon_dir"
    env -i "$envie_bin" create pythonenv
    test -e "./pythonenv/bin/python"
)

test_envie_create_2() (
    command -v python2 >/dev/null 2>&1 || return 0
    cd "$polygon_dir"
    env -i "$envie_bin" create -2 py2env
    test -e "./py2env/bin/python" && "./py2env/bin/python" -V 2>&1 | grep "^Python 2"
)

test_envie_create_3() (
    command -v python3 >/dev/null 2>&1 || return 0
    cd "$polygon_dir"
    env -i "$envie_bin" create -3 py3env
    test -e "./py3env/bin/python" && "./py3env/bin/python" -V 2>&1 | grep "^Python 3";
)

. $(dirname "$0")/unittest.inc && main
