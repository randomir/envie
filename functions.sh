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

function _dirdirname() {
    echo $(dirname "$(dirname "$1")")
}

function lsenv() {
    export -f _dirdirname
    find . -path '*/bin/python' -exec bash -c '_dirdirname "{}"' \; 2>/dev/null
}

function cdenv() {
    local OLDIFS envlist env len

    OLDIFS="$IFS"
    IFS=$'\n'
    envlist=$(lsenv)
    len=$(wc -l <<< "$envlist")
    if [ "$len" = 1 ]
    then
        _activate "$envlist"
    else
        select env in $envlist
        do
            if [ "$env" ]
            then
                _activate "$env"
                break
            fi
        done
    fi
    IFS="$OLDIFS"
}
