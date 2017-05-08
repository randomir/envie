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
}

test_envie_list_help() (
    "$envie_bin" list -h | grep 'Find and list all virtualenvs under DIR.'
)


# test list using find

test_envie_list_find_empty_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$("$envie_bin" list --find)
    [ -z "$list" ]
)

test_envie_list_find_empty_from_path() (
    local list=$("$envie_bin" list --find "$sandbox_dir/project_a/src")
    [ -z "$list" ]
)

test_envie_list_find_single_py3_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$("$envie_bin" list --find)
    [ "$list" == "./env_a" ]
)

test_envie_list_find_single_py2_from_path() (
    local list=$("$envie_bin" list --find "$sandbox_dir/project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_envie_list_find_multiple() (
    cd "$sandbox_dir/project_c"
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

test_envie_list_find_multiple_avoid_some() (
    cd "$sandbox_dir/project_c"
    local list=$("$envie_bin" list --find . ./sub_a | sort)
    local expected
    expected=$(cat <<-END
		./sub_b/env_cb
		./sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

test_envie_list_find_multiple_levels() (
    cd "$sandbox_dir"
    local list=$("$envie_bin" list --find | sort)
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


# test list using locate

test_envie_list_locate_empty_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$("$envie_bin" list --locate)
    [ -z "$list" ]
)

test_envie_list_locate_empty_from_path() (
    local list=$("$envie_bin" list --locate "$sandbox_dir/project_a/src")
    [ -z "$list" ]
)

test_envie_list_locate_single_py3_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$("$envie_bin" list --locate)
    [ "$list" == "./env_a" ]
)

test_envie_list_locate_single_py2_from_path() (
    local list=$("$envie_bin" list --locate "$sandbox_dir/project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_envie_list_locate_multiple() (
    cd "$sandbox_dir/project_c"
    local list=$("$envie_bin" list --locate | sort)
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

test_envie_list_locate_multiple_levels() (
    cd "$sandbox_dir"
    local list=$("$envie_bin" list --locate | sort)
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


# test list using find vs. locate rate

test_envie_list_race_empty_from_cwd() (
    cd "$sandbox_dir/project_a/src"
    local list=$("$envie_bin" list)
    [ -z "$list" ]
)

test_envie_list_race_empty_from_path() (
    local list=$("$envie_bin" list "$sandbox_dir/project_a/src")
    [ -z "$list" ]
)

test_envie_list_race_single_py3_from_cwd() (
    cd "$sandbox_dir/project_a"
    local list=$("$envie_bin" list)
    [ "$list" == "./env_a" ]
)

test_envie_list_race_single_py2_from_path() (
    local list=$("$envie_bin" list "$sandbox_dir/project_b")
    [ "$list" == "$sandbox_dir/project_b/env_b" ]
)

test_envie_list_race_multiple() (
    cd "$sandbox_dir/project_c"
    local list=$("$envie_bin" list | sort)
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

test_envie_list_race_multiple_avoid_some() (
    cd "$sandbox_dir/project_c"
    local list=$("$envie_bin" list . ./sub_a | sort)
    local expected
    expected=$(cat <<-END
		./sub_b/env_cb
		./sub_c/env_cc
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

test_envie_list_race_multiple_levels() (
    cd "$sandbox_dir"
    local list=$("$envie_bin" list | sort)
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


# test filtering

test_envie_list_filter_firstlevel() (
    cd "$sandbox_dir"
    local list=$("$envie_bin" list trusty | sort)
    local expected
    expected=$(cat <<-END
		./trusty-tahr/dev
		./trusty-tahr/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

test_envie_list_filter_secondlevel() (
    cd "$sandbox_dir"
    local list=$("$envie_bin" list dev | sort)
    local expected
    expected=$(cat <<-END
		./trusty-tahr/dev
		./zesty-zapus/dev
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

test_envie_list_filter_firstlevel_from_path() (
    local list=$("$envie_bin" list "$sandbox_dir" trusty | sort)
    local expected
    expected=$(cat <<-END
		$sandbox_dir/trusty-tahr/dev
		$sandbox_dir/trusty-tahr/prod
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)

test_envie_list_filter_secondlevel_from_path_with_sep() (
    local list=$("$envie_bin" list "$sandbox_dir" -- dev | sort)
    local expected
    expected=$(cat <<-END
		$sandbox_dir/trusty-tahr/dev
		$sandbox_dir/zesty-zapus/dev
	END
    )
    echo "$list"
    echo "$expected"
    [ "$list" == "$expected" ]
)


unittest_main
