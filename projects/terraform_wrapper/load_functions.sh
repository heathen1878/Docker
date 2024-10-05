#!/bin/bash

# Load the functions
# shellcheck source-path=functions
if [ -d /tfcli/functions ]
then
    for file in /tfcli/functions/*.sh
    do
        . "$file"
    done
fi