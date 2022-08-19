#!/bin/bash
#
# Assumptions
# - shellcheck is installed `brew install shellcheck`

echo "Testing bootstrap_shells.sh for bash errors..."
shellcheck bootstrap_shell.sh

echo "Testing this script (run_tests.sh) for bash errors..."
shellcheck run_tests.sh

echo "Testing included .rc files for bash errors..."
shellcheck -e SC1090 0- -e SC2148 -e SC2034 ./*.rc
