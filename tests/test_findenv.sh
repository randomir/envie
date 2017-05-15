#!/usr/bin/env bash

. $(dirname "$0")/unittest.inc

setup() {
    [ -f "$sandbox_dir/envie-test-sandbox" ] || return 255

    tests_dir=$(dirname "$0")
    envie_bin=$(abspath "$tests_dir/../scripts/envie")

    # normalize, in case it contains symlinks (OS X temp dirs do)
    sandbox_dir=$(abspath "$sandbox_dir")

    cd "$sandbox_dir"
    echo "(using envie from $envie_bin)"
    echo "(using sandbox dir: $sandbox_dir)"

    export HOME="$sandbox_dir"
    . "$envie_bin"
}

test_findenv_help() (
    findenv -h | grep 'Find and list all virtualenvs below DIR, or above if none found below.'
)


# test 'findenv' using find

test_findenv_inside_env_root_from_cwd() (
    cd "$sandbox_dir/project_a/env_a"
    local list=$(findenv --find)
    [ "$list" == "." ]
)

test_findenv_inside_env_root_from_abspath() (
    local list=$(findenv --find "$sandbox_dir/project_a/env_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_inside_env_root_from_relpath() (
    local list=$(findenv --find "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_inside_env_bin_from_cwd() (
    cd "$sandbox_dir/project_a/env_a/bin"
    local list=$(findenv --find)
    [ "$list" == ".." ]
)

test_findenv_inside_env_bin_from_abspath() (
    local list=$(findenv --find "$sandbox_dir/project_a/env_a/bin")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_inside_env_bin_from_relpath() (
    local list=$(findenv --find "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_single_level_down_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv --find)
    [ "$list" == "env_a" ]
)

test_findenv_single_level_down_from_abspath() (
    local list=$(findenv --find "$sandbox_dir/project_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_single_level_down_from_relpath() (
    local list=$(findenv --find "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_single_level_up_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$(findenv --find)
    [ "$list" == "../env_a" ]
)

test_findenv_single_level_up_from_abspath() (
    local list=$(findenv --find "$sandbox_dir/project_a/src")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_single_level_up_from_relpath() (
    local list=$(findenv --find "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_normalize_abspath() (
    local list=$(findenv --find "$sandbox_dir/project_a/../project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_findenv_normalize_relpath() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv --find "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_findenv_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(findenv --find ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		project_a/env_a
		project_b/env_b
		project_c/sub_a/env_ca1
		project_c/sub_a/env_ca2
		project_c/sub_a/env_ca3
		project_c/sub_b/env_cb
		project_c/sub_c/env_cc
		trusty-tahr/dev
		trusty-tahr/prod
		zesty-zapus/dev
		zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'findenv' using locate

test_findenv_locate_inside_env_root_from_cwd() (
    cd "$sandbox_dir/project_a/env_a"
    local list=$(findenv --locate)
    echo $list
    [ "$list" == "." ]
)

test_findenv_locate_inside_env_root_from_abspath() (
    local list=$(findenv --locate "$sandbox_dir/project_a/env_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_locate_inside_env_root_from_relpath() (
    local list=$(findenv --locate "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_locate_inside_env_bin_from_cwd() (
    cd "$sandbox_dir/project_a/env_a/bin"
    local list=$(findenv --locate)
    [ "$list" == ".." ]
)

test_findenv_locate_inside_env_bin_from_abspath() (
    local list=$(findenv --locate "$sandbox_dir/project_a/env_a/bin")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_locate_inside_env_bin_from_relpath() (
    local list=$(findenv --locate "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_locate_single_level_down_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv --locate)
    [ "$list" == "env_a" ]
)

test_findenv_locate_single_level_down_from_abspath() (
    local list=$(findenv --locate "$sandbox_dir/project_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_locate_single_level_down_from_relpath() (
    local list=$(findenv --locate "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_locate_single_level_up_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$(findenv --locate)
    [ "$list" == "../env_a" ]
)

test_findenv_locate_single_level_up_from_abspath() (
    local list=$(findenv --locate "$sandbox_dir/project_a/src")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_locate_single_level_up_from_relpath() (
    local list=$(findenv --locate "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_locate_normalize_abspath() (
    local list=$(findenv --locate "$sandbox_dir/project_a/../project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_findenv_locate_normalize_relpath() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv --locate "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_findenv_locate_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(findenv --locate ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		project_a/env_a
		project_b/env_b
		project_c/sub_a/env_ca1
		project_c/sub_a/env_ca2
		project_c/sub_a/env_ca3
		project_c/sub_b/env_cb
		project_c/sub_c/env_cc
		trusty-tahr/dev
		trusty-tahr/prod
		zesty-zapus/dev
		zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# test 'findenv' using find vs. locate rate (the default)

test_findenv_race_inside_env_root_from_cwd() (
    cd "$sandbox_dir/project_a/env_a"
    local list=$(findenv)
    echo $list
    [ "$list" == "." ]
)

test_findenv_race_inside_env_root_from_abspath() (
    local list=$(findenv "$sandbox_dir/project_a/env_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_race_inside_env_root_from_relpath() (
    local list=$(findenv "project_a/env_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_race_inside_env_bin_from_cwd() (
    cd "$sandbox_dir/project_a/env_a/bin"
    local list=$(findenv)
    [ "$list" == ".." ]
)

test_findenv_race_inside_env_bin_from_abspath() (
    local list=$(findenv "$sandbox_dir/project_a/env_a/bin")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_race_inside_env_bin_from_relpath() (
    local list=$(findenv "./project_a/env_a/bin")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_race_single_level_down_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv)
    [ "$list" == "env_a" ]
)

test_findenv_race_single_level_down_from_abspath() (
    local list=$(findenv "$sandbox_dir/project_a")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_race_single_level_down_from_relpath() (
    local list=$(findenv "project_a")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_race_single_level_up_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$(findenv)
    [ "$list" == "../env_a" ]
)

test_findenv_race_single_level_up_from_abspath() (
    local list=$(findenv "$sandbox_dir/project_a/src")
    [ "$list" == "$sandbox_dir/project_a/env_a" ]
)

test_findenv_race_single_level_up_from_relpath() (
    local list=$(findenv "project_a/src")
    [ "$list" == "project_a/env_a" ]
)


test_findenv_race_normalize_abspath() (
    local list=$(findenv "$sandbox_dir/project_a/../project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_findenv_race_normalize_relpath() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)


test_findenv_race_multiple_envs_multiple_level_up_from_relpath() (
    local list=$(findenv ".config/envie" | sort)
    local expected
    expected=$(cat <<-END
		project_a/env_a
		project_b/env_b
		project_c/sub_a/env_ca1
		project_c/sub_a/env_ca2
		project_c/sub_a/env_ca3
		project_c/sub_b/env_cb
		project_c/sub_c/env_cc
		trusty-tahr/dev
		trusty-tahr/prod
		zesty-zapus/dev
		zesty-zapus/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


# misc

test_findenv_relpath_find_f() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv -f "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)

test_findenv_relpath_locate_l() (
    cd "$sandbox_dir/project_a"
    local list=$(findenv -l "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)

test_envie_find_sourced_relpath_race() (
    cd "$sandbox_dir/project_a"
    local list=$(envie find "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)

test_envie_find_sourced_relpath_find_f() (
    cd "$sandbox_dir/project_a"
    local list=$(envie find -f "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)

test_envie_find_sourced_relpath_locate_l() (
    cd "$sandbox_dir/project_a"
    local list=$(envie find -l "../project_b/env_b/bin/")
    [ "$list" == "../project_b/env_b" ]
)


unittest_main
