#!/usr/bin/env bash

teardown() {
    echo -e "\nRunning global teardown script."

    [ -f "$sandbox_dir/envie-test-sandbox" ] || return 255

    rm -rf "$sandbox_dir"
    echo "(removed sandbox dir: $sandbox_dir)"
}

teardown
