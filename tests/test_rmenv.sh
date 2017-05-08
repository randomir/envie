#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")
    sandbox_dir=$(abspath "$(mktemp -d)")
    cd "$sandbox_dir"
    . "$envie_bin"
    echo "(envie sourced from $envie_bin)"
    echo "(created sandbox dir: $sandbox_dir)"
}

teardown() {
    rm -rf "$sandbox_dir"
    echo "(removed sandbox dir: $sandbox_dir)"
}

virtualenv_exists() {
    [ -e "$1/bin/activate_this.py" ] && [ -x "$1/bin/python" ]
}


test_rmenv_help() {
    rmenv -h | grep 'Remove (delete) the base directory'
}

test_rmenv_error_outside_of_env() (
    # rmenv should fail with 1, but to test it, we have to suppress 'exit on err'
    VIRTUAL_ENV="" rmenv || [ $? -eq 1 ]
)

test_rmenv_error_invalid_virtualenv() (
    VIRTUAL_ENV=$(mktemp -u)
    rmenv || [ $? -eq 1 ]
)

test_rmenv_error_user_interactive_abort() (
    mkenv abort
    echo n | rmenv || [ $? -eq 2 ]
)

test_rmenv_user_interactive() (
    # make a temporary env, ensure it exists
    mkenv shorty
    virtualenv_exists shorty
    
    # interactively destroy it
    echo y | rmenv
    ! virtualenv_exists shorty
)

test_rmenv_forced() (
    # make a temporary env, ensure it exists
    mkenv another
    virtualenv_exists another

    # interactively destroy it
    rmenv -f
    ! virtualenv_exists another
)


unittest_main