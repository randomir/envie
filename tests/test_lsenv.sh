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

test_lsenv_help() (
    lsenv -h | grep 'Find and list all virtualenvs under DIR.'
)


# test list using find

test_lsenv_find_empty_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsenv -f)
    [ -z "$list" ]
)

test_lsenv_find_empty_from_path() (
    local list=$(lsenv -f "$polygon_dir/project_a/src")
    [ -z "$list" ]
)

test_lsenv_find_single_py3_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsenv -f)
    [ "$list" == "./env_a" ]
)

test_lsenv_find_single_py2_from_path() (
    local list=$(lsenv -f "$polygon_dir/project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsenv_find_multiple() (
    cd "$polygon_dir/project_c"
    local list=$(lsenv -f | sort)
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

test_lsenv_find_multiple_avoid_some() (
    cd "$polygon_dir/project_c"
    local list=$(lsenv -f . ./sub_a | sort)
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

test_lsenv_find_multiple_levels() (
    cd "$polygon_dir"
    local list=$(lsenv -f | sort)
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


# test list using locate

test_lsenv_locate_empty_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsenv -l)
    [ -z "$list" ]
)

test_lsenv_locate_empty_from_path() (
    local list=$(lsenv -l "$polygon_dir/project_a/src")
    [ -z "$list" ]
)

test_lsenv_locate_single_py3_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsenv -l)
    [ "$list" == "./env_a" ]
)

test_lsenv_locate_single_py2_from_path() (
    local list=$(lsenv -l "$polygon_dir/project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsenv_locate_multiple() (
    cd "$polygon_dir/project_c"
    local list=$(lsenv -l | sort)
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

test_lsenv_locate_multiple_levels() (
    cd "$polygon_dir"
    local list=$(lsenv -l | sort)
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


# test list using find vs. locate rate

test_lsenv_race_empty_from_cwd() (
    cd "$polygon_dir/project_a/src"
    local list=$(lsenv)
    [ -z "$list" ]
)

test_lsenv_race_empty_from_path() (
    local list=$(lsenv "$polygon_dir/project_a/src")
    [ -z "$list" ]
)

test_lsenv_race_single_py3_from_cwd() (
    cd "$polygon_dir/project_a"
    local list=$(lsenv)
    [ "$list" == "./env_a" ]
)

test_lsenv_race_single_py2_from_path() (
    local list=$(lsenv "$polygon_dir/project_b")
    [ "$list" == "$polygon_dir/project_b/env_b" ]
)

test_lsenv_race_multiple() (
    cd "$polygon_dir/project_c"
    local list=$(lsenv | sort)
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

test_lsenv_race_multiple_avoid_some() (
    cd "$polygon_dir/project_c"
    local list=$(lsenv . ./sub_a | sort)
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

test_lsenv_race_multiple_levels() (
    cd "$polygon_dir"
    local list=$(lsenv | sort)
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
