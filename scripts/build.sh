#! /bin/bash

set -e

ORIG_WORKDIR="`pwd`"
OUTDIR="images-bbe"

################################################################################
# Parse arguments
################################################################################
while [[ $# -gt 0 ]]; do
    case "$1" in
        --sdk)
            BUILD_SDK=yes
            ;;
        --rt)
            export BBE_RT_KERNEL=1
            OUTDIR="${OUTDIR}-rt"
            ;;
        *)
            break;
            ;;
    esac
    shift
done

################################################################################
# Build
################################################################################
source build/conf/setenv
bitbake core-image-base tisdk-rootfs-image
if [[ "$BUILD_SDK" == "yes" ]]; then
    bitbake tisdk-rootfs-image -c populate_sdk
fi

# Find the deploy directory
DEPLOY_DIR="`bitbake -e | sed -n -e 's/^DEPLOY_DIR="\(.*\)"$/\1/p'`"

################################################################################
# Capture artifacts
################################################################################
cd "${ORIG_WORKDIR}"
mkdir -p "${OUTDIR}"
cp "${DEPLOY_DIR}/images/bbe/core-image-base-bbe.wic.xz" "${OUTDIR}/core-image-base.wic.xz"
cp "${DEPLOY_DIR}/images/bbe/core-image-base-bbe.wic.bmap" "${OUTDIR}/core-image-base.wic.bmap"
cp "${DEPLOY_DIR}/images/bbe/tisdk-rootfs-image-bbe.wic.xz" "${OUTDIR}/tisdk-rootfs-image.wic.xz"
cp "${DEPLOY_DIR}/images/bbe/tisdk-rootfs-image-bbe.wic.bmap" "${OUTDIR}/tisdk-rootfs-image.wic.bmap"
if [[ "$BUILD_SDK" == "yes" ]]; then
    cp "${DEPLOY_DIR}/sdk/arago-2019.03-toolchain-2019.03.sh" "${OUTDIR}/"
fi
