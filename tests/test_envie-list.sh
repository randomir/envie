#!/bin/bash

setup() {
    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")
    polygon_dir=$(mktemp -d)
    cd "$polygon_dir"
    echo "(envie sourced from $envie_bin)"
    echo "(created polygon dir: $polygon_dir)"
    echo -n "(creating test environments in polygon dir..."
    local create_output
    create_output=$(
        set -e
        exec 2>&1

        mkdir -p project_a
        "$envie_bin" create -3 "./project_a/env_a"
        mkdir project_a/src
        
        mkdir -p project_b
        "$envie_bin" create -2 "./project_b/env_b"

        mkdir -p project_c/sub_a
        "$envie_bin" create "./project_c/sub_a/env_ca1"
        "$envie_bin" create -3 "./project_c/sub_a/env_ca2"
        "$envie_bin" create -3 "./project_c/sub_a/env_ca3"
        mkdir -p project_c/sub_a/{src_1,src_2}

        mkdir -p project_c/sub_b
        "$envie_bin" create "./project_c/sub_b/env_cb"
        mkdir -p project_c/sub_b/{src_1,src_2}

        mkdir -p project_c/sub_c
        "$envie_bin" create "./project_c/sub_c/env_cc"
    )
    if (( $? )); then
        echo "FAILED)"
        echo "$create_output"
        return 1
    else
        echo "DONE)"
    fi
}

teardown() {
    rm -rf "$polygon_dir"
    echo "(removed polygon dir: $polygon_dir)"
}

test_envie_list_help() (
    "$envie_bin" list -h | grep 'Find and list all virtualenvs under DIR.'
)

test_envie_list_find_empty_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$("$envie_bin" list --find)
    [ -z "$list" ]
)

test_envie_list_find_empty_from_path() (
    local list=$("$envie_bin" list --find "$polygon_dir/project_a/src")
    [ -z "$list" ]
)

test_envie_list_find_single_py3_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" list --find)
    [ "$list" == "./env_a" ]
)

test_envie_list_find_single_py2_from_path() (
    local list=$("$envie_bin" list --find "$polygon_dir/project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_envie_list_find_multiple() (
    cd "$polygon_dir/project_c"
    local list=$("$envie_bin" list --find | sort)
    local expected
    expected=$(cat <<-END
		./sub_a/env_ca1
		./sub_a/env_ca2
		./sub_a/env_ca3
		./sub_b/env_cb
		./sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

. $(dirname "$0")/unittest.inc && main
