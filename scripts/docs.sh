#!/bin/env bash
set -e

doxygen Doxyfile
# Github pages expects an index.html at docs/
rm -rf docs
mv html docs
rm -rf html
