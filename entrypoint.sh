#!/bin/bash

set -e  # Exit on any error

# Function to recursively export variables from JSON
export_json() {
    local prefix=$1
    local json_file=$2

    # Iterate over JSON keys using jq
    jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" "$json_file" | while IFS= read -r line; do
        # If value is an object, recursively handle it
        key=$(echo "$line" | cut -d= -f1)
        value=$(echo "$line" | cut -d= -f2-)

        # If value is a JSON object or array, recurse to handle nested structures
        if [[ "$value" == "{"* || "$value" == "["* ]]; then
            temp_json_file=$(mktemp)
            echo "$value" > "$temp_json_file"  # Create a temp file for the nested structure
            export_json "$key" "$temp_json_file"
            rm -f "$temp_json_file"
        else
            # If key doesn't already have a value, set it in the environment
            if [[ -z "${!key}" ]]; then
                echo "Exporting: $key=$value"
                echo "$key=$value" >> $GITHUB_ENV
            fi
        fi
    done
}

# Main function to load the JSON file
load_json() {
    JSON_FILE=${INPUT_JSON_FILE:-"default.json"}  # Default to "default.json" if no argument is given
    echo "content of current directory: $(ls -la)"
    echo "file to use is: $JSON_FILE"   

    # Check if the JSON file exists
    if [[ ! -f "$JSON_FILE" ]]; then
        echo "Error: JSON file '$JSON_FILE' not found!"
        exit 1
    fi

    # Start exporting from the root level
    export_json "" "$JSON_FILE"
}

# Call the main function
load_json "$1"