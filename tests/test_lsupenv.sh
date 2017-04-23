#!/bin/bash

setup() {
    [ -d "$polygon_dir" ] && [[ "$polygon_dir" =~ ^/tmp/ ]] || return 255

    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")

    cd "$polygon_dir"
    echo "(using envie from $envie_bin)"
    echo "(using polygon dir: $polygon_dir)"

    export HOME="$polygon_dir"
    . "$envie_bin"
}

test_lsupenv_help() (
    lsupenv -h | grep 'Find and list all virtualenvs below DIR, or above if none found below.'
)


# test 'lsupenv' using find

test_lsupenv_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$(lsupenv --find)
    [ "$list" == "." ]
)

test_lsupenv_inside_env_root_from_abspath() (
    local list=$(lsupenv --find "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_inside_env_root_from_relpath() (
    local list=$(lsupenv --find "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$(lsupenv --find)
    [ "$list" == ".." ]
)

test_lsupenv_inside_env_bin_from_abspath() (
    local list=$(lsupenv --find "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_inside_env_bin_from_relpath() (
    local list=$(lsupenv --find "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv --find)
    [ "$list" == "./env_a" ]
)

test_lsupenv_single_level_down_from_abspath() (
    local list=$(lsupenv --find "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_single_level_down_from_relpath() (
    local list=$(lsupenv --find "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsupenv --find)
    [ "$list" == "../env_a" ]
)

test_lsupenv_single_level_up_from_abspath() (
    local list=$(lsupenv --find "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_single_level_up_from_relpath() (
    local list=$(lsupenv --find "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_normalize_abspath() (
    local list=$(lsupenv --find "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsupenv_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv --find "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_lsupenv_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(lsupenv --find ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'lsupenv' using locate

test_lsupenv_locate_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$(lsupenv --locate)
    echo $list
    [ "$list" == "." ]
)

test_lsupenv_locate_inside_env_root_from_abspath() (
    local list=$(lsupenv --locate "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_locate_inside_env_root_from_relpath() (
    local list=$(lsupenv --locate "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_locate_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$(lsupenv --locate)
    [ "$list" == ".." ]
)

test_lsupenv_locate_inside_env_bin_from_abspath() (
    local list=$(lsupenv --locate "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_locate_inside_env_bin_from_relpath() (
    local list=$(lsupenv --locate "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_locate_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv --locate)
    [ "$list" == "./env_a" ]
)

test_lsupenv_locate_single_level_down_from_abspath() (
    local list=$(lsupenv --locate "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_locate_single_level_down_from_relpath() (
    local list=$(lsupenv --locate "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_locate_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsupenv --locate)
    [ "$list" == "../env_a" ]
)

test_lsupenv_locate_single_level_up_from_abspath() (
    local list=$(lsupenv --locate "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_locate_single_level_up_from_relpath() (
    local list=$(lsupenv --locate "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_locate_normalize_abspath() (
    local list=$(lsupenv --locate "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsupenv_locate_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv --locate "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_lsupenv_locate_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(lsupenv --locate ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'lsupenv' using find vs. locate rate (the default)

test_lsupenv_race_inside_env_root_from_cwd() (
    cd "$polygon_dir/project_a/env_a"
    local list=$(lsupenv)
    echo $list
    [ "$list" == "." ]
)

test_lsupenv_race_inside_env_root_from_abspath() (
    local list=$(lsupenv "$polygon_dir/project_a/env_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_race_inside_env_root_from_relpath() (
    local list=$(lsupenv "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_race_inside_env_bin_from_cwd() (
    cd "$polygon_dir/project_a/env_a/bin"
    local list=$(lsupenv)
    [ "$list" == ".." ]
)

test_lsupenv_race_inside_env_bin_from_abspath() (
    local list=$(lsupenv "$polygon_dir/project_a/env_a/bin")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_race_inside_env_bin_from_relpath() (
    local list=$(lsupenv "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_race_single_level_down_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv)
    [ "$list" == "./env_a" ]
)

test_lsupenv_race_single_level_down_from_abspath() (
    local list=$(lsupenv "$polygon_dir/project_a")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_race_single_level_down_from_relpath() (
    local list=$(lsupenv "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_race_single_level_up_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsupenv)
    [ "$list" == "../env_a" ]
)

test_lsupenv_race_single_level_up_from_abspath() (
    local list=$(lsupenv "$polygon_dir/project_a/src")
    [ "$list" == "$polygon_dir/project_a/env_a" ]
)

test_lsupenv_race_single_level_up_from_relpath() (
    local list=$(lsupenv "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_lsupenv_race_normalize_abspath() (
    local list=$(lsupenv "$polygon_dir/project_a/../project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsupenv_race_normalize_relpath() (
    cd "$polygon_dir/project_a"
    local list=$(lsupenv "../project_b/env_b/local/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_lsupenv_race_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(lsupenv ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		./project_a/env_a
		./project_b/env_b
		./project_c/sub_a/env_ca1
		./project_c/sub_a/env_ca2
		./project_c/sub_a/env_ca3
		./project_c/sub_b/env_cb
		./project_c/sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


. $(dirname "$0")/unittest.inc && main