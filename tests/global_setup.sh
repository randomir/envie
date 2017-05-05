#!/usr/bin/env bash

function _dump_test_config() {
    # NB: $HOME == $polygon_dir
    cat <<-END
		_ENVIE_CONFIG_DIR="$HOME/.config/envie"
		_ENVIE_USE_DB="1"
		_ENVIE_DB_PATH="$HOME/.config/envie/locate.db"
		_ENVIE_INDEX_ROOT="$HOME"
		_ENVIE_CRON_INDEX="0"
		_ENVIE_LS_INDEX="1"
		_ENVIE_FIND_LIMIT_SEC="0.4"
		_ENVIE_LOCATE_LIMIT_SEC="4"
	END
}

setup() {
	echo "Running global setup script."

    [ -d "$polygon_dir" ] && [[ "$polygon_dir" =~ ^/tmp/ ]] || return 255

    tests_dir=$(dirname "$0")
    envie_bin=$(readlink -f "$tests_dir/../scripts/envie")

    cd "$polygon_dir"
    echo "(using envie from $envie_bin)"
    echo "(using polygon dir: $polygon_dir)"

    # create few envs
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

        mkdir -p trusty-tahr
        "$envie_bin" create "trusty-tahr/dev"
        "$envie_bin" create "trusty-tahr/prod"

        mkdir -p zesty-zapus
        "$envie_bin" create "zesty-zapus/dev"
        "$envie_bin" create "zesty-zapus/prod"
    )
    if (( $? )); then
        echo "FAILED)"
        echo "$create_output"
        return 1
    else
        echo "DONE)"
    fi

    # fake envierc for testing
    echo -n "(creating test envierc..."
    export HOME="$polygon_dir"
    config_dir="$polygon_dir/.config/envie"
    mkdir -p "$config_dir"
    _dump_test_config >"$config_dir/envierc"
    if (
        set -ex
        . "$envie_bin"
        [ "$_ENVIE_CONFIG_PATH" == "$config_dir/envierc" ] && (( _ENVIE_USE_DB ))

        echo "Envie internal vars:"
        _envie_dump_config
        echo "_ENVIE_TOOL_PATH=$_ENVIE_TOOL_PATH"
        echo "_ENVIE_SOURCE=$_ENVIE_SOURCE"
        echo "_ENVIE_GLOBAL_PYTHON=$_ENVIE_GLOBAL_PYTHON"
    ); then
        echo "DONE)"
    else
        echo "FAILED)"
        return 1
    fi
}

setup
