#!/bin/bash

# This script authenticates to Azure using az login

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

### Variables ###
declare OPTARG=""
declare OPTIND=1
declare flag=""
declare TENANT=""

### End of Variables ###

### Input Values ###

while getopts "t:" flag
do
    case "${flag}" in
        t)
            TENANT="${OPTARG}"
        ;;
        *)
        ;;
    esac
done

shift "$(( OPTIND - 1 ))"
### End of Input Values ###

### Tests ###
# Is the Az Cli installed?
check_for_executable az

# Is Jq installed?
check_for_executable jq
### End of Tests ###

### Az Cli Global Configuration ###
az config set core.login_experience_v2=off
### End of Global Configuration ###

### Code Flow ###

if [ "$TENANT" ]
then
    echo -e "\033[32mAuthenticating Az Cli against $TENANT \033[0m"
    if az login --tenant "$TENANT" --only-show-errors > /dev/null 2>&1
    then
        _ok "Connected to $(az account show | jq -rc '.tenantDisplayName') as $(az account show | jq -rc '.user.name')"
    fi
else
    echo -e "\033[32mAuthenticating Az Cli \033[0m"
    if az login --only-show-errors > /dev/null 2>&1
    then
        _ok "Connected to $(az account show | jq -rc '.tenantDisplayName') as $(az account show | jq -rc '.user.name')"
    fi
fi

### End of Code Flow ###

### Az Cli Global Configuration ###
az config unset core.login_experience_v2
### End of Global Configuration ###