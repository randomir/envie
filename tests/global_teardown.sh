#!/usr/bin/env bash

teardown() {
    echo -e "\nRunning global teardown script."

    [ -f "$polygon_dir/envie-test-polygon" ] || return 255

    rm -rf "$polygon_dir"
    echo "(removed polygon dir: $polygon_dir)"
}

teardown
