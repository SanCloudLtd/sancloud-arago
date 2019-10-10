#! /bin/bash

set -e

./scripts/release-prepare.sh
./scripts/build.sh
./scripts/release-finish.sh
