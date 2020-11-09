#!/bin/bash

API=https://app.bitrise.io/app/6c06d3a40422d10f/all_stack_info
KEY=available_stacks
OUT=blob.json
local MAJOR=0
local MINOR=0
local PATCH=0
local SPECIAL=""
. ./semver.sh


# jq ' . | keys'
#[
#  "available_stacks",
#  "project_types_with_default_stacks",
#  "running_builds_on_private_cloud"
#]

cleanup_string () {
    TMP=$(echo ${TMP} | tr -d "[]" | tr -d \")
}

get_semvars () {
    pattern="osx-xcode-"
    if [[ "${TMP}" != *"${pattern}"* ]]; then
        TMP=""
    fi
    
    if [[ "${TMP}" =~ [0-9] ]]; then
	TMP="${TMP/$pattern/}"
    else
        TMP=""
    fi
}


curl ${API} > ${OUT} 

TMP=$(cat ${OUT} | jq '.project_types_with_default_stacks.ios.default_stack')
cleanup_string
get_semvars

DEFAULT_STACK=${TMP}

echo
echo "-------------------------"
echo "DEFAULT_STACK"
echo "-------------------------"
echo
echo ${DEFAULT_STACK}
echo
echo

TMP=$(cat ${OUT} | jq '.available_stacks | keys ')
cleanup_string

echo "-------------------------"
echo "AVAILABLE_STACKS"
echo "-------------------------"
echo
 
pattern="osx-xcode-"
IFS=', ' read -r -a array <<< "${TMP}"
for element in "${array[@]}"
do
    TMP=${element}
    get_semvars
        if [[ -n ${TMP} ]]; then
            echo ${TMP}
            SEMVER=${TMP}
            semverParseInto $SEMVER MAJOR MINOR PATCH SPECIAL
            echo "${SEMVER} -> M:$MAJOR m:$MINOR p:$PATCH s:$SPECIAL. Expect M:1 m:3 p:2 s:a"
            D=10.3.2
	    semverLT $A $D
	    echo "$A < $D -> $?. Expect 0."
            
        fi
done




