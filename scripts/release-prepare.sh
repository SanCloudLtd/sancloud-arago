#! /bin/bash

set -e

echo "Preparing for release build"

# Enable the archiver and configure it to create a full source mirror
cat > build/conf/local-release.conf << EOF
INHERIT += "archiver"
BB_GENERATE_MIRROR_TARBALLS = "1"
ARCHIVER_MODE[src] = "mirror"
ARCHIVER_MODE[mirror] = "combined"
ARCHIVER_MIRROR_EXCLUDE = "file://"
COPYLEFT_LICENSE_INCLUDE = "*"
EOF

# Start with a clean TMPDIR so we can be sure licenses are deployed correctly
rm -rf build/tmp

# Start with a clean output directory so we don't publish any obsolete files
rm -rf images-bbe
