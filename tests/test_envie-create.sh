#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")
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

test_envie_create_custom_python_exec() (
    cd "$polygon_dir"
    env -i "$envie_bin" create -e python pycustom
    test -e "./pycustom/bin/python"
)

test_envie_create_install_requirements() (
    cd "$polygon_dir"
    echo -e "plucky\njsonplus" >requirements.txt
    env -i "$envie_bin" create -r requirements.txt withreqs
    test -e "./withreqs/bin/python"
    . "./withreqs/bin/activate"
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_envie_create_install_package() (
    cd "$polygon_dir"
    env -i "$envie_bin" create -p "plucky>=0.3.5" withpkg
    test -e "./withpkg/bin/python"
    . "./withpkg/bin/activate"
    [ "$(pip freeze | grep plucky -c)" -eq 1 ]
)

test_envie_create_install_requirements_autodetect() (
    cd "$polygon_dir"
    echo -e "plucky\njsonplus" >requirements.txt
    env -i "$envie_bin" create -a withautoreqs
    . "./withautoreqs/bin/activate"
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_envie_create_error_existing_envname() (
    cd "$polygon_dir"
    env -i "$envie_bin" create
    [ $? -eq 1 ]
)

test_envie_create_error_nonexisting_python_exec() (
    cd "$polygon_dir"
    env -i "$envie_bin" create -e nonexisting_python noenv
    [ $? -eq 2 ]
)

test_envie_create_error_invalid_python_exec() (
    cd "$polygon_dir"
    env -i "$envie_bin" create -e bash noenv
    [ $? -eq 3 ]
)

test_envie_create_error_invalid_virtualenv_opt() (
    cd "$polygon_dir"
    env -i "$envie_bin" create noenv -- --invalid-virtualenv-option
    [ $? -eq 4 ]
)

test_envie_create_error_pip_install_fail() (
    cd "$polygon_dir"
    env -i "$envie_bin" create -p nonexisting_pip_package noenv
    [ $? -eq 5 ]
)


unittest_main
