#!/bin/env bash

doxygen Doxyfile
# Github pages expects an index.html at docs/
mv html docs
