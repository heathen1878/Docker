#!/bin/bash

# This script authenticates to GitHub using gh auth


### Inline Functions ###
function warning() {
    _colour="\033[1;33m!!"
    echo -e "${_colour} $*\e[0m"
}

function _error() {
    _colour="\033[1;31m✘"
    echo -e "${_colour} $*\e[0m"
}

function _tick() {
    echo -e "\033[32m✔\e[0m"
}

function _ok() {
    _colour="\033[32m✔"
    echo -e "${_colour} $*\e[0m"
}

function check_for_executable() {
    if ! command -v "$1" > /dev/null 2>&1
        then
            _error "$1 doesn't exist"
            exit 1
    fi
}
### End of Inline Functions ###

### Tests ###
# Is the Az Cli installed?
check_for_executable gh

# Is Jq installed?
check_for_executable jq
### End of Tests ###

### Code Flow ###
gh auth login --web --git-protocol ssh --skip-ssh-key
### End of Code Flow ###