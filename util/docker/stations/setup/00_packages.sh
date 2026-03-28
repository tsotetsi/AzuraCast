#!/bin/bash
set -e
set -x

# Group up several package installations here to reduce overall build time
apt-get update
apt-get install -y --no-install-recommends libxslt1.1

# Refresh the library cache
ldconfig
