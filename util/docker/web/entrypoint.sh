#!/bin/bash
set -e

# If a MYSQL_PASSWORD_FILE is specified, load the password from it
# and export it as the MYSQL_PASSWORD the application expects.
if [ -n "$MYSQL_PASSWORD_FILE" ]; then
    password=$(cat "$MYSQL_PASSWORD_FILE")
    export MYSQL_PASSWORD=$password
    export DB_PASSWORD=$password
fi

# Execute the original command the container was supposed to run.
exec "$@"