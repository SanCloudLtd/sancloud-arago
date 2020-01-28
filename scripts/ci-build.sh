#! /bin/bash

set -e

cat >> build/conf/local.conf << EOF
INHERIT += "archiver"
BB_GENERATE_MIRROR_TARBALLS = "1"
BB_GENERATE_SHALLOW_TARBALLS = "1"
BB_GIT_SHALLOW = "1"
ARCHIVER_MODE[src] = "mirror"
ARCHIVER_MODE[mirror] = "combined"
ARCHIVER_MIRROR_EXCLUDE = "file://"
COPYLEFT_LICENSE_INCLUDE = "*"

PREMIRRORS ??= "\
bzr://.*/.*   https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
cvs://.*/.*   https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
git://.*/.*   https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
gitsm://.*/.* https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
hg://.*/.*    https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
osc://.*/.*   https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
p4://.*/.*    https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
svn://.*/.*   https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n"

MIRRORS =+ "\
ftp://.*/.*      https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
http://.*/.*     https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n \
https://.*/.*    https://cdn.archaea.dev/file/sancloud-yocto/mirror/ \n"

SSTATE_MIRRORS =+ "\
file://.* https://cdn.archaea.dev/file/sancloud-yocto/arago/sstate/PATH \n"
EOF

./patches/apply.py
./scripts/build.sh

# Capture licenses
tar czf images-bbe/licenses.tar.gz -C build/tmp/deploy licenses
