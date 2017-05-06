#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    [ -f "$polygon_dir/envie-test-polygon" ] || return 255

    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")

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


test_envie_find_normalize_abspath() (
    local list=$("$envie_bin" find --find "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_envie_find_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find --find "../project_b/env_b/local/bin/" 2>&1)
    echo "$list"
    [ "$list" == "../project_b/env_b" ]
)


test_envie_find_multiple_envs_multiple_level_up_from_relpath() (
    local list=$("$envie_bin" find --find ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
		./trusty-tahr/dev
		./trusty-tahr/prod
		./zesty-zapus/dev
		./zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'envie find' using locate

test_envie_find_locate_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$("$envie_bin" find --locate)
    echo $list
    [ "$list" == "." ]
)

test_envie_find_locate_inside_env_root_from_abspath() (
    local list=$("$envie_bin" find --locate "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_locate_inside_env_root_from_relpath() (
    local list=$("$envie_bin" find --locate "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_locate_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$("$envie_bin" find --locate)
    [ "$list" == ".." ]
)

test_envie_find_locate_inside_env_bin_from_abspath() (
    local list=$("$envie_bin" find --locate "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_locate_inside_env_bin_from_relpath() (
    local list=$("$envie_bin" find --locate "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_locate_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find --locate)
    [ "$list" == "./env_a" ]
)

test_envie_find_locate_single_level_down_from_abspath() (
    local list=$("$envie_bin" find --locate "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_locate_single_level_down_from_relpath() (
    local list=$("$envie_bin" find --locate "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_locate_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$("$envie_bin" find --locate)
    [ "$list" == "../env_a" ]
)

test_envie_find_locate_single_level_up_from_abspath() (
    local list=$("$envie_bin" find --locate "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_locate_single_level_up_from_relpath() (
    local list=$("$envie_bin" find --locate "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_locate_normalize_abspath() (
    local list=$("$envie_bin" find --locate "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_envie_find_locate_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find --locate "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_envie_find_locate_multiple_envs_multiple_level_up_from_relpath() (
    local list=$("$envie_bin" find --locate ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
		./trusty-tahr/dev
		./trusty-tahr/prod
		./zesty-zapus/dev
		./zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'envie find' using find vs. locate rate (the default)

test_envie_find_race_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$("$envie_bin" find)
    echo $list
    [ "$list" == "." ]
)

test_envie_find_race_inside_env_root_from_abspath() (
    local list=$("$envie_bin" find "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_race_inside_env_root_from_relpath() (
    local list=$("$envie_bin" find "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_race_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$("$envie_bin" find)
    [ "$list" == ".." ]
)

test_envie_find_race_inside_env_bin_from_abspath() (
    local list=$("$envie_bin" find "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_race_inside_env_bin_from_relpath() (
    local list=$("$envie_bin" find "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_race_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find)
    [ "$list" == "./env_a" ]
)

test_envie_find_race_single_level_down_from_abspath() (
    local list=$("$envie_bin" find "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_race_single_level_down_from_relpath() (
    local list=$("$envie_bin" find "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_race_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$("$envie_bin" find)
    [ "$list" == "../env_a" ]
)

test_envie_find_race_single_level_up_from_abspath() (
    local list=$("$envie_bin" find "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_envie_find_race_single_level_up_from_relpath() (
    local list=$("$envie_bin" find "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_envie_find_race_normalize_abspath() (
    local list=$("$envie_bin" find "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_envie_find_race_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_envie_find_race_multiple_envs_multiple_level_up_from_relpath() (
    local list=$("$envie_bin" find ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
		./trusty-tahr/dev
		./trusty-tahr/prod
		./zesty-zapus/dev
		./zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# misc

test_envie_find_relpath_find_f() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find -f "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)

test_envie_find_relpath_locate_l() (
    cd "$polygon_dir/project_a"
    local list=$("$envie_bin" find -l "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


unittest_main
