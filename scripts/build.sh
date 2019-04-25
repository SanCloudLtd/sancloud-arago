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
bitbake core-image-base
if [[ "$BUILD_SDK" == "yes" ]]; then
    bitbake core-image-base -c populate_sdk
fi

################################################################################
# Capture artifacts
################################################################################
cd "${ORIG_WORKDIR}"
mkdir -p "${OUTDIR}"
git show --pretty="format:%H%n%ai%n%an <%ae>%n%s%n" -q > "${OUTDIR}/COMMIT.txt"
if ! git diff-index --quiet HEAD; then
    echo 'DIRTY' >> "${OUTDIR}/COMMIT.txt"
fi
cp "build/tmp/deploy/images/bbe/core-image-base-bbe.wic.xz" "${OUTDIR}/core-image-base.wic.xz"
cp "build/tmp/deploy/images/bbe/core-image-base-bbe.wic.bmap" "${OUTDIR}/core-image-base.wic.bmap"
if [[ "$BUILD_SDK" == "yes" ]]; then
    cp "build/tmp/deploy/sdk/arago-2019.03-toolchain-2019.03.sh" "${OUTDIR}/"
fi
