#!/bin/bash
# VirtualEnv shell helpers: easier create, remove, list/find and activate.
# Written by Radomir Stevanovic, Feb 2015.

function mkenv() {
    mkdir -p "$1"
    cd "$1"
    virtualenv .
    . bin/activate
    cd -
}

function rmenv() {
    local envpath
    envpath="$VIRTUAL_ENV"
    deactivate
    rm -rf "$envpath"
}

function _deactivate() {
    [ "$VIRTUAL_ENV" ] && deactivate
}

function _activate() {
    _deactivate
    source "$1/bin/activate"
}

function lsenv() {
    # note: files with newline in name not handled properly
    find . -path '*/bin/python' -exec dirname '{}' \; 2>/dev/null | xargs -d'\n' -n1 -r dirname
}

function cdenv() {
    local OLDIFS envlist env len=0

    envlist=$(lsenv)
    [ "$envlist" ] && len=$(wc -l <<< "$envlist")
    if [ "$len" = 1 ]; then
        _activate "$envlist"
    elif [ "$len" = 0 ]; then
        echo "No environments. Try going up."
    else
        OLDIFS="$IFS"
        IFS=$'\n'
        select env in $envlist; do
            if [ "$env" ]; then
                _activate "$env"
                break
            fi
        done
        IFS="$OLDIFS"
    fi
}
