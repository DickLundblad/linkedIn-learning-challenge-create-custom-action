#!/bin/bash

set -e  # Exit on any error

JSON_FILE=${1:-"config.json"}  # Default to "config.json" if no argument is given

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
    echo "Error: JSON file '$JSON_FILE' not found!"
    exit 1
fi

# Read JSON and export each key-value as an environment variable
export_variables() {
    jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' "$JSON_FILE" | while IFS= read -r line; do
        echo "Exporting: $line"
        echo "$line" >> $GITHUB_ENV
    done
}

export_variables
