#!/bin/bash

# This script grabs variables from GitHub or secrets from Key Vault and exposes them on the command line for Docker Compose to consume;
# useful when setting up environments locally on your workstation.

### Inline Functions ###
function show_usage() {
    _warning "USAGE: source ./create_environment_variables.sh -k key-vault-name -n secret-name"
    _warning "USAGE: source ./create_environment_variables.sh -g github/account/repo -n variable-name"
}

function _warning() {
    _colour="\033[1;33m"
    echo -e "${_colour}$*\e[0m"
}

function _error() {
    _colour="\033[1;31m"
    echo -e "${_colour}$*\e[0m"
}

function _ok() {
    _colour="\033[32m"
    echo -e "${_colour}[ok] $*\e[0m"
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
declare KV=""
declare GH=""
declare SECRET_OR_VARIABLE_NAME=""

### End of Variables ###

### Input Values ###

MY_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

while getopts "g:k:n:r" flag
do
    case "${flag}" in
        g)
            GH="${OPTARG}"
        ;;
        k)
            KV="${OPTARG}"
        ;;
        n)
            SECRET_OR_VARIABLE_NAME="${OPTARG}"
        ;;
        *)
        ;;
    esac
done

shift "$(( OPTIND - 1 ))"
### End of Input Values ###

### Tests ###
# Check the script has been dot sourced...
if [ "$BASH_SOURCE" == "$0" ]
then
    show_usage
    exit 1
fi

# Is the GitHub Cli installed?
check_for_executable gh

# Is the Az Cli installed?
check_for_executable az

# Is Jq installed?
check_for_executable jq

# Check for minimum parameters i.e. GitHub variable name or Key Vault name and secret
if [ ${#KV} == 0 ] && [ ${#GH} == 0 ]
then
    _warning "No parameters detected"
    show_usage
    return 1
fi

# Check a secret name has been passed?
if [ ${#SECRET_OR_VARIABLE_NAME} == 0 ]
then
    _error "Please pass secret name as -n"
    show_usage
    return 1
fi

# Check we can connect to Azure
if [ ${#KV} -gt 0 ]
then
    _ok "Connecting to Azure"
    "$MY_PATH"/auth_az.sh
fi

# Check we can connect to GitHub
if [ ${#GH} -gt 0 ]
then
    _ok "Connecting to GitHub"
    "$MY_PATH"/auth_gh.sh
fi
### End of Tests ###

### Code Flow ###
if [ ${#KV} -gt 0 ]
then
    VALUE=$(az keyvault secret show --name "$SECRET_OR_VARIABLE_NAME" --vault-name "$KV" --only-show-errors 2> /dev/null | jq -rc '.value')
    if [ -z "$VALUE" ]
    then
        _error "Cannot find $SECRET_OR_VARIABLE_NAME in $KV"
    else
        VARIABLE_TO_BE_EXPORTED="${SECRET_OR_VARIABLE_NAME}"
        declare "$VARIABLE_TO_BE_EXPORTED"="${VALUE}"
        export "${VARIABLE_TO_BE_EXPORTED?}"
    fi
fi

if [ ${#GH} -gt 0 ]
then
    VALUE=$(gh variable get "$SECRET_OR_VARIABLE_NAME" --repo "$GH")
    if [ -z "$VALUE" ]
    then
        _error "Cannot find $SECRET_OR_VARIABLE_NAME in repo $GH"
    else
        VARIABLE_TO_BE_EXPORTED="${SECRET_OR_VARIABLE_NAME}"
        declare "$VARIABLE_TO_BE_EXPORTED"="${VALUE}"
        export "${VARIABLE_TO_BE_EXPORTED?}"
    fi
fi
### End of Code Flow ###

### Clean Up ###
if [ ${#KV} -gt 0 ]
then
    az logout
fi

if [ ${#GH} -gt 0 ]
then
    gh auth logout
fi
### End of Clean Up ###