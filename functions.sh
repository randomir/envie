#!/bin/bash
#
# VirtualEnv shell helpers: easier create, remove, list/find and activate.
# Written by Radomir Stevanovic, Feb 2015.

_SHENV_DEFAULT_ENVNAME=env
_SHENV_DEFAULT_PYTHON=python
_SHENV_CONFIG_DIR="$HOME/.config/shenv"
_SHENV_DB="$_SHENV_CONFIG_DIR/locate.db"

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
        -name .git -o -name .hg -o -name .svn -prune -o -path '*/bin/python' \
        -exec dirname '{}' \; 2>/dev/null | xargs -d'\n' -n1 -r dirname
}

function lsenv() {
    _db_exists && _lsenv_locate "$@" || _lsenv_find "$@"
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
    [ -e "$_SHENV_DB" ]
}

function _shenv_install() {
    if ! _command_exists locate || ! _command_exists updatedb; then
        fail "locate/updatedb not installed. Failing-back to find."
        return 1
    fi
}

function _shenv_db_update() {
    mkdir -p "$_SHENV_CONFIG_DIR"
    updatedb -l 0 -o "$_SHENV_DB" -U "$HOME"
}

# Compatible with: lsenv [<start_dir> [<avoid_subdir>]]
function _lsenv_locate() {
    local dir="${1:-.}" avoid="${2:-}"
    local absdir=$(readlink -e "$dir")
    locate -d "$_SHENV_DB" "$absdir"'*/bin/activate_this.py' \
        | sed -e 's#/bin/activate_this\.py$##' -e "s#^$absdir#$dir#"
}
