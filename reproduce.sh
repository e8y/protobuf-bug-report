#!/bin/bash

set -e

build_type="${1:-Debug}"

cmake -DCMAKE_BUILD_TYPE="$build_type" -S . -B work -G Ninja
cd work
ninja

