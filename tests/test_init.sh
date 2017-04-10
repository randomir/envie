#!/bin/bash

test_envie_is_in_path() {
    which envie
}

test_envie_sourcing_works() {
    . `which envie`
}

test_envie_is_function_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t envie) == "function" ]'
}

test_envie_help() {
    local bin=$(which envie)
    env -i "$bin" help | grep 'Your virtual environments wrangler'
}

test_mkenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t mkenv) == "function" ] '\
                   '&& [ $(type -t mkenv2) == "function" ] '\
                   '&& [ $(type -t mkenv3) == "function" ]'
}

test_rmenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t rmenv) == "function" ]'
}

test_lsenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t lsenv) == "function" ]'
}

test_lsupenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t lsupenv) == "function" ]'
}

test_chenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t chenv) == "function" ]'
}

test_cdenv_present_after_sourcing() {
    env -i bash -c '. $(which envie) && [ $(type -t cdenv) == "function" ]'
}

. unittest.inc && main
