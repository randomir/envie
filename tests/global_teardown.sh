#!/bin/bash

teardown() {
    echo "Running global teardown script."

    [ -d "$polygon_dir" ] && [[ "$polygon_dir" =~ ^/tmp/ ]] || return 255

    rm -rf "$polygon_dir"
    echo "(removed polygon dir: $polygon_dir)"
}

teardown
