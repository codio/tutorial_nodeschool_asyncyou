#!/bin/bash

# Check parameters
if [[ "$#" -ne 3 ]]; then
    echo "3 parameters required"
    exit 0
fi

# Translate lesson name into correct name for Workshopper projects
if [ $2 == "waterfall" ]; then
    STR="WATERFALL"
elif [ $2 == "series_object" ]; then
    STR="SERIES OBJECT"
elif [ $2 == "each" ]; then
    STR="EACH"
elif [ $2 == "map" ]; then
    STR="MAP"
elif [ $2 == "times" ]; then
    STR="TIMES"
elif [ $2 == "reduce" ]; then
    STR="REDUCE"
elif [ $2 == "whilst" ]; then
    STR="WHILST"
else
    echo UNKNOWN: Make sure you have your code file selected before running/verifying
    exit 0
fi
echo SELECTED FILE IS : $STR

#Select the workshopper lesson
async_you select $STR > /dev/null

# Run or Verify?
if [ $1 == "run" ]; then
    async_you run $3/$2.js
elif [ $1 == "verify" ]; then
    async_you verify $3/$2.js
else 
    echo "BAD COMMAND"
fi

