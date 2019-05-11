[<img align=right src="https://www.sancloud.co.uk/wp-content/uploads/2016/09/sancloud_and_address_web.png">](https://www.sancloud.co.uk/)

Pre-integrated Arago distribution for Sancloud Hardware
=======================================================

This repository combines the Arago Distribution and Yocto Project sources
with the Sancloud Board Support Package (BSP) for the BeagleBone Enhanced
(BBE). This is one of our two main test platforms for the Sancloud BSP, the
other being Automotive Grade Linux (AGL).

How to build an Arago image for the BBE
---------------------------------------

To build an Arago distribution image for the Sancloud BBE you simply need to
fetch this repository and all submodules, then run the build script.

    git clone --recurse-submodules -b thud https://github.com/SanCloudLtd/sancloud-arago.git
    cd sancloud-arago
    ./scripts/build.sh

The images will be placed in a top level `images-bbe` directory.
