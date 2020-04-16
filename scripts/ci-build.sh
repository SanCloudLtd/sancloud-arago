#! /bin/bash

set -e

mkdir images-bbe
OUTDIR=`realpath images-bbe`

################################################################################
# Prepare
################################################################################
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
bzr://.*/.*   https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
cvs://.*/.*   https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
git://.*/.*   https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
gitsm://.*/.* https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
hg://.*/.*    https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
osc://.*/.*   https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
p4://.*/.*    https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
svn://.*/.*   https://cdn.sancloud.info/file/sc-yocto/mirror/ \n"

MIRRORS =+ "\
ftp://.*/.*      https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
http://.*/.*     https://cdn.sancloud.info/file/sc-yocto/mirror/ \n \
https://.*/.*    https://cdn.sancloud.info/file/sc-yocto/mirror/ \n"

SSTATE_MIRRORS =+ "\
file://.* https://cdn.sancloud.info/file/sc-yocto/arago/sstate/PATH \n"
EOF

./patches/apply.py

################################################################################
# Build
################################################################################
source build/conf/setenv
( bitbake --setscene-only core-image-base tisdk-rootfs-image || true ) | \
        tee "${OUTDIR}/build-setscene.log" | \
        sed -e '/^NOTE: .*Started$/d' -e '/^NOTE: Running /d'
bitbake --skip-setscene core-image-base tisdk-rootfs-image | \
        tee "${OUTDIR}/build.log" | \
        sed -e '/^NOTE: .*Started$/d' -e '/^NOTE: Running /d'

# Find the deploy directory
DEPLOY_DIR="`bitbake -e | sed -n -e 's/^DEPLOY_DIR="\(.*\)"$/\1/p'`"

################################################################################
# Capture artifacts
################################################################################
cp "${DEPLOY_DIR}/images/bbe/core-image-base-bbe.wic.xz" "${OUTDIR}/core-image-base.wic.xz"
cp "${DEPLOY_DIR}/images/bbe/core-image-base-bbe.wic.bmap" "${OUTDIR}/core-image-base.wic.bmap"
cp "${DEPLOY_DIR}/images/bbe/tisdk-rootfs-image-bbe.wic.xz" "${OUTDIR}/tisdk-rootfs-image.wic.xz"
cp "${DEPLOY_DIR}/images/bbe/tisdk-rootfs-image-bbe.wic.bmap" "${OUTDIR}/tisdk-rootfs-image.wic.bmap"
tar czf "${OUTDIR}/licenses.tar.gz" -C "${DEPLOY_DIR}" licenses
gzip "${OUTDIR}/build-setscene.log"
gzip "${OUTDIR}/build.log"
