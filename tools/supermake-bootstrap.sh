#!/bin/sh

set -x 
set -e

test ! -d supermake && git submodule add https://github.com/eagafonov/supermake.git supermake
touch requirements-dev.txt
touch requirements-test.txt

test ! -f Makefile && echo "include supermake/python-sandbox.mk" > Makefile

