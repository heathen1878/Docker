#!/bin/bash

# Load the functions
# shellcheck source-path=/root/functions
if [ -d root/tfcli/functions ]
then
    for file in /root/tfcli/functions/*.sh
    do
        source "$file"
    done
fi