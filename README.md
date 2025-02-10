# linkedIn-learning-challenge-create-custom-action
# Load JSON as Environment Variables Action

This action loads all values from a JSON file and sets them as environment variables using Bash and Docker.

## Inputs

- `json-file`: The path to the JSON file to load. Default is `config.json`.

## Example Usage

```yaml
name: Load JSON as Environment Variables

on:
  push:
    branches:
      - main

jobs:
  load-json-env:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Load JSON and set environment variables
        uses:  DickLundblad/linkedIn-learning-challenge-create-custom-action@v1
        id: custom-action  # Added an ID to reference it later
        with:
          json-file: 'path/to/data.json'

      - name: Use the environment variables
        run: |
          echo "Variable1: $VAR1"
          echo "Variable2: $VAR2"
