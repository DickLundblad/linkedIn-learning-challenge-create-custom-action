FROM alpine:latest

# Install dependencies
RUN apk add --no-cache jq bash

# Copy the script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
