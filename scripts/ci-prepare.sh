#! /bin/bash

set -e

CI_CACHE_DIR="${HOME}/ci-cache"

echo "Preparing for CI build"
echo "Using '${CI_CACHE_DIR}' as cache directory"

cat > build/conf/auto.conf << EOF
DL_DIR = "${CI_CACHE_DIR}/downloads"
SSTATE_DIR = "${CI_CACHE_DIR}/sstate-cache"
INHERIT += "rm_work"
EOF

mkdir -p "${CI_CACHE_DIR}/downloads"
mkdir -p "${CI_CACHE_DIR}/sstate-cache"
