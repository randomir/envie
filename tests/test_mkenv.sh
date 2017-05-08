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


test_mkenv_help() {
    mkenv -h | grep 'Create Python (2/3) virtual environment'
}

test_mkenv_defaults() (
    mkenv
    local name="env"
    [ -e "$name/bin/python" ] && [ "$VIRTUAL_ENV" == "$(abspath "$name")" ]
)

test_mkenv_custom_envname() (
    mkenv pythonenv
    local name="pythonenv"
    [ -e "$name/bin/python" ] && [ "$VIRTUAL_ENV" == "$(abspath "$name")" ]
)

test_mkenv2() (
    command -v python2 >/dev/null 2>&1 || return 0
    mkenv2 py2env1
    [ -e "./py2env1/bin/python" ] && "./py2env1/bin/python" -V 2>&1 | grep "^Python 2"
    mkenv -2 py2env2
    [ -e "./py2env2/bin/python" ] && "./py2env2/bin/python" -V 2>&1 | grep "^Python 2"
)

test_mkenv3() (
    command -v python3 >/dev/null 2>&1 || return 0
    mkenv3 py3env1
    [ -e "./py3env1/bin/python" ] && "./py3env1/bin/python" -V 2>&1 | grep "^Python 3";
    mkenv3 py3env2
    [ -e "./py3env2/bin/python" ] && "./py3env2/bin/python" -V 2>&1 | grep "^Python 3";
)

test_mkenv_custom_python_exec() (
    mkenv -e python pycustom
    [ -e "./pycustom/bin/python" ]
)

test_mkenv_install_requirements() (
    echo -e "plucky\njsonplus" >requirements.txt
    mkenv -r requirements.txt withreqs
    [ -e "./withreqs/bin/python" ]
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_mkenv_install_package() (
    mkenv -p "plucky>=0.3.5" withpkg
    [ -e "./withpkg/bin/python" ]
    [ "$(pip freeze | grep plucky -c)" -eq 1 ]
)

test_mkenv_install_requirements_autodetect() (
    echo -e "plucky\njsonplus" >requirements.txt
    mkenv -a withautoreqs
    [ "$(pip freeze | grep "plucky\|jsonplus" -c)" -eq 2 ]
)

test_mkenv_throwaway_with_removal() (
    mkenv -t
    [ "$VIRTUAL_ENV" ]
    rmenv -f
    [ ! "$VIRTUAL_ENV" ]
)

test_mkenv_error_existing_envname() (
    mkenv || [ $? -eq 1 ]
)

test_mkenv_error_nonexisting_python_exec() (
    mkenv -e nonexisting_python noenv || [ $? -eq 2 ]
)

test_mkenv_error_invalid_python_exec() (
    mkenv -e bash noenv || [ $? -eq 3 ]
)

test_mkenv_error_invalid_virtualenv_opt() (
    mkenv noenv -- --invalid-virtualenv-option || [ $? -eq 4 ]
)

test_mkenv_error_pip_install_fail() (
    mkenv -p nonexisting_pip_package noenv || [ $? -eq 5 ]
)


unittest_main
