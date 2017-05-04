#!/usr/bin/env bash

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")
    polygon_dir=$(mktemp -d)
    cd "$polygon_dir"
    . "$envie_bin"
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


test_rmenv_help() {
    rmenv -h | grep 'Remove (delete) the base directory'
}

test_rmenv_error_outside_of_env() (
    _deactivate
    rmenv
    [ $? -eq 1 ]
)

test_rmenv_error_invalid_virtualenv() (
    VIRTUAL_ENV=$(mktemp -u)
    rmenv
    [ $? -eq 1 ]
)

test_rmenv_error_user_interactive_abort() (
    mkenv abort
    echo n | rmenv
    [ $? -eq 2 ]
)

test_rmenv_user_interactive() (
    # make a temporary env, ensure it exists
    mkenv shorty
    virtualenv_exists shorty
    
    # interactively destroy it
    echo y | rmenv
    [ $? -eq 0 ]
    ! virtualenv_exists shorty
)

test_rmenv_forced() (
    # make a temporary env, ensure it exists
    mkenv another
    virtualenv_exists another

    # interactively destroy it
    rmenv -f
    [ $? -eq 0 ]
    ! virtualenv_exists another
)

. $(dirname "$0")/unittest.inc && main