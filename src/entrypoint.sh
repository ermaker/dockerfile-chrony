#!/bin/sh
set -e

# Run confd to render config file(s)
confd -onetime -backend env

# Grant permissions to /dev/stdout for spawned chrony process
chown chrony:chrony /dev/stdout

# Run application
exec "$@"