#!/usr/bin/bash

function error { echo "$1" >&2; exit 1; }

hash travis || error "Missing Travis CLI client."

# Login with GitHub
travis login
# update Travis clone of GitHub repos
travis sync
#  
