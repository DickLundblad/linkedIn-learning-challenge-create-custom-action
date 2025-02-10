#!/bin/bash

set -e  # Exit on any error

JSON_FILE=${INPUT_JSON_FILE:-"default.json"}  # Default to "default.json" if no argument is given
echo "content of current directory: $(ls -la)"
echo "file to use is: $JSON_FILE"

# Check if the JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
    echo "Error: JSON file '$JSON_FILE' not found!"
    exit 1
fi

# Function to export key-value pairs as environment variables
export_key_value_pairs() {
    jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' "$JSON_FILE" | while IFS= read -r line; do
        echo "Exporting key value pairs: $line"
        echo "$line" >> $GITHUB_ENV
    done
}

# Function to process arrays in the JSON file (arrays with JSON objects)
export_array_elements() {
    jq -r 'paths(scalars) as $p | getpath($p) | select(type == "array") | "\($p|join("."))=\(.)"' "$JSON_FILE" | while IFS= read -r line; do
        echo "Exporting array element: $line"
        echo "$line" >> $GITHUB_ENV
    done
}

# Export regular key-value pairs
export_key_value_pairs

# Export array elements (if any)
export_array_elements
