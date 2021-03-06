#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")
    sandbox_dir=$(abspath "$(mktemp -d)")
    echo "(using envie from $envie_bin)"
    echo "(created sandbox dir: $sandbox_dir)"
}

teardown() {
    rm -rf "$sandbox_dir"
    echo "(removed sandbox dir: $sandbox_dir)"
}

test_envie_create_help() {
    "$envie_bin" create -h | grep 'Create Python (2/3) virtual environment'
}

test_envie_create_defaults() (
    cd "$sandbox_dir"
    "$envie_bin" create
    [ -x "./env/bin/python" ]
)

test_envie_create_custom_envname() (
    cd "$sandbox_dir"
    "$envie_bin" create pythonenv
    [ -x "./pythonenv/bin/python" ]
)

test_envie_create_2() (
    command -v python2 >/dev/null 2>&1 || return 0
    cd "$sandbox_dir"
    "$envie_bin" create -2 py2env
    [ -x ./py2env/bin/python ]
    ./py2env/bin/python -V 2>&1 | grep "^Python 2"
)

test_envie_create_3() (
    command -v python3 >/dev/null 2>&1 || return 0
    cd "$sandbox_dir"
    "$envie_bin" create -3 py3env
    [ -x ./py3env/bin/python ]
    ./py3env/bin/python -V 2>&1 | grep "^Python 3"
)

test_envie_create_custom_python_exec() (
    cd "$sandbox_dir"
    "$envie_bin" create -e python pycustom
    [ -x ./pycustom/bin/python ]
)

test_envie_create_install_requirements() (
    cd "$sandbox_dir"
    echo -e "plucky\njsonplus" >requirements.txt
    "$envie_bin" create -r requirements.txt withreqs
    [ -x ./withreqs/bin/python ]
    . ./withreqs/bin/activate
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_envie_create_install_package() (
    cd "$sandbox_dir"
    "$envie_bin" create -p "plucky>=0.3.5" withpkg
    [ -x ./withpkg/bin/python ]
    . ./withpkg/bin/activate
    [ "$(pip freeze | grep plucky -c)" -eq 1 ]
)

test_envie_create_install_requirements_autodetect() (
    cd "$sandbox_dir"
    echo -e "plucky\njsonplus" >requirements.txt
    "$envie_bin" create -a withautoreqs
    . ./withautoreqs/bin/activate
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_envie_create_error_existing_envname() (
    cd "$sandbox_dir"
    # create should fail with 1, but to test it, we have to suppress 'exit on err'
    "$envie_bin" create || [ $? -eq 1 ]
)

test_envie_create_error_nonexisting_python_exec() (
    cd "$sandbox_dir"
    "$envie_bin" create -e nonexisting_python noenv || [ $? -eq 2 ]
)

test_envie_create_error_invalid_python_exec() (
    cd "$sandbox_dir"
    "$envie_bin" create -e bash noenv || [ $? -eq 3 ]
)

test_envie_create_error_invalid_virtualenv_opt() (
    cd "$sandbox_dir"
    "$envie_bin" create noenv -- --invalid-virtualenv-option || [ $? -eq 4 ]
)

test_envie_create_error_pip_install_fail() (
    cd "$sandbox_dir"
    "$envie_bin" create -p nonexisting_pip_package noenv || [ $? -eq 5 ]
)


unittest_main
