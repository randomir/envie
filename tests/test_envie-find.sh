#!/bin/bash

setup() {
    [ -d "$polygon_dir" ] && [[ "$polygon_dir" =~ ^/tmp/ ]] || return 255

    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")

    cd "$polygon_dir"
    echo "(using envie from $envie_bin)"
    echo "(using polygon dir: $polygon_dir)"

    export HOME="$polygon_dir"
}

test_envie_find_help() (
    "$envie_bin" find -h | grep 'Find and list all virtualenvs below DIR, or above if none found below.'
)


# test 'envie find' using find

test_envie_find_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$("$envie_bin" find --find)
    [ "$list" == "." ]
)

test_envie_find_inside_env_root_from_abspath() (
    local list=$("$envie_bin" find --find "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_inside_env_root_from_relpath() (
    local list=$("$envie_bin" find --find "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$("$envie_bin" find --find)
    [ "$list" == ".." ]
)

test_envie_find_inside_env_bin_from_abspath() (
    local list=$("$envie_bin" find --find "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_inside_env_bin_from_relpath() (
    local list=$("$envie_bin" find --find "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find --find)
    [ "$list" == "./env_a" ]
)

test_envie_find_single_level_down_from_abspath() (
    local list=$("$envie_bin" find --find "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_single_level_down_from_relpath() (
    local list=$("$envie_bin" find --find "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$("$envie_bin" find --find)
    [ "$list" == "../env_a" ]
)

test_envie_find_single_level_up_from_abspath() (
    local list=$("$envie_bin" find --find "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_single_level_up_from_relpath() (
    local list=$("$envie_bin" find --find "project_a/src")
    [ "$list" == "project_a/env_a" ]
)

. $(dirname "$0")/unittest.inc && main