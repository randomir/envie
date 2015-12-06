#!/bin/bash
#
# VirtualEnv shell helpers: easier create, remove, list/find and activate.
# Written by Radomir Stevanovic, Feb 2015.

_SHENV_DEFAULT_ENVNAME=env
_SHENV_DEFAULT_PYTHON=python
_SHENV_CONFIG_DIR="$HOME/.config/shenv"
_SHENV_DB_PATH="$_SHENV_CONFIG_DIR/locate.db"
_SHENV_INDEX_ROOT="$HOME"
_SHENV_FIND_LIMIT=0.1  # in seconds

function fail() {
    echo "$@" >&2
}

# Creates a new environment in <path/to/env>, based on <python_exec>.
# Usage: mkenv [<path/to/env>] [<python_exec>]
function mkenv() {
    local envpath="${1:-$_SHENV_DEFAULT_ENVNAME}" output
    if [ -d "$envpath" ]; then
        fail "Directory '$envpath' already exists."
        return 1
    fi
    echo "Creating python environment in '$envpath'."

    local pyexe="${2:-$_SHENV_DEFAULT_PYTHON}" pypath
    if ! pypath=$(which "$pyexe"); then
        fail "Python executable '$pyexe' not found, failing-back to: '$_SHENV_DEFAULT_PYTHON'."
        pypath=$(which "$_SHENV_DEFAULT_PYTHON")
    fi
    local pyver=$("$pypath" --version 2>&1)
    if [[ ! $pyver =~ Python ]]; then
        fail "Unrecognized Python version/executable: '$pypath'."
        return 1
    fi
    echo "Using $pyver ($pypath)."

    mkdir -p "$envpath"
    cd "$envpath"
    output=$(virtualenv --no-site-packages -p "$pypath" -v . 2>&1)
    if [ $? -ne 0 ]; then
        echo -en "$output"
    fi
    . bin/activate
    cd - >/dev/null
}

# Destroys the active environment.
# Usage (while env active): rmenv
function rmenv() {
    local envpath="$VIRTUAL_ENV"
    if [ ! "$envpath" ]; then
        fail "Active environment not detected."
        return 1
    fi
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

# Lists all environments below the <start_dir>.
# Usage: lsenv [<start_dir> [<avoid_subdir>]]
function _lsenv_find() {
    local dir="${1:-.}" avoid="${2:-}"
    find "$dir" -path "$avoid" -prune -o \
        -name .git -o -name .hg -o -name .svn -prune -o -path '*/bin/activate_this.py' \
        -exec dirname '{}' \; 2>/dev/null | xargs -d'\n' -n1 -r dirname
}

# `lsenv` via `locate`
# Compatible with: lsenv [<start_dir> [<avoid_subdir>]]
function _lsenv_locate() {
    local dir="${1:-.}" avoid="${2:-}"
    local absdir=$(readlink -e "$dir")
    locate -d "$_SHENV_DB_PATH" "$absdir"'*/bin/activate_this.py' \
        | sed -e 's#/bin/activate_this\.py$##' -e "s#^$absdir#$dir#"
}

# Run `lsenv` via both `find` and `locate` in parallel and return
# as soon as the first method yields the results.
function _lsenv_locate_vs_find_race() {
    set +m
    local p_pid_find=$(mkftemp) p_pid_locate=$(mkftemp) p_pid_timer=$(mkftemp)
    { __find_and_return "$@" & echo $! >"$p_pid_find"; } 2>/dev/null
    { __locate_and_return "$@" & echo $! >"$p_pid_locate"; } 2>/dev/null
    { __find_fast_bailout & echo $! >"$p_pid_timer"; } 2>/dev/null
    wait
    rm "$p_pid_find" "$p_pid_locate" "$p_pid_timer"
    set -m
}
function __find_and_return() {
    local result=$(_lsenv_find "$@")
    local pid_locate pid_timer
    read pid_locate <"$p_pid_locate"
    read pid_timer <"$p_pid_timer"
    __kill $pid_locate $pid_timer
    [ "$result" ] && echo "$result"
}
function __locate_and_return() {
    local result=$(_lsenv_locate "$@")
    local pid_find pid_timer
    read pid_find <"$p_pid_find"
    read pid_timer <"$p_pid_timer"
    __kill $pid_find $pid_timer
    [ "$result" ] && echo "$result"
}
function __find_fast_bailout() {
    sleep "$_SHENV_FIND_LIMIT"
    local pid_find
    read pid_find <"$p_pid_find"
    __kill $pid_find
}
function __kill() {
    while [ "$#" -gt 0 ]; do
        rkill -TERM "$1" 1>/dev/null
        shift
    done
}

# Make fastest temporary file: like mktemp, but tries
# to create file in memory (/dev/shm) first.
function mkftemp() {
    [ -d /dev/shm ] && mktemp --tmpdir=/dev/shm || mktemp
}

function lsenv() {
    _db_exists && _lsenv_locate_vs_find_race "$@" || _lsenv_find "$@"
}

# Finds the closest env by first looking down and then dir-by-dir up the tree.
function lsupenv() {
    local list len=0 dir=. prevdir
    while [ "$len" -eq 0 ] && [ "$(readlink -e "$prevdir")" != / ]; do
        list=$(lsenv "$dir" "$prevdir")
        [ "$list" ] && len=$(wc -l <<<"$list") || len=0
        prevdir="$dir"
        dir="$dir/.."
    done
    echo "$list"
}

function cdenv() {
    local OLDIFS envlist env len=0

    envlist=$(lsupenv)
    [ "$envlist" ] && len=$(wc -l <<<"$envlist")
    if [ "$len" -eq 1 ]; then
        _activate "$envlist"
    elif [ "$len" -eq 0 ]; then
        echo "No environments found."
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

alias wkenv=cdenv


# faster shenv, using locate

function _command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function _db_exists() {
    [ -e "$_SHENV_DB_PATH" ]
}

function shenv_install() {
    if ! _command_exists locate || ! _command_exists updatedb; then
        fail "locate/updatedb not installed. Failing-back to find."
        return 1
    fi
    echo -n "Indexing environments in '$_SHENV_INDEX_ROOT'..."
    shenv_updatedb
    echo "Done."
}

function shenv_updatedb() {
    mkdir -p "$_SHENV_CONFIG_DIR"
    updatedb -l 0 -o "$_SHENV_DB_PATH" -U "$_SHENV_INDEX_ROOT"
}
