#! /bin/bash

set -e

echo "Finishing release build"

# Capture licenses
tar cJf images-bbe/licenses.tar.gz -C build/tmp/deploy licenses

# Capture full Arago source tree
git archive-all --prefix=sancloud-arago/ images-bbe/sancloud-arago.tar.gz

# Copy source mirror
rsync -a build/tmp/deploy/sources/mirror/ images-bbe/sources/
