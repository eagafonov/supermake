#!/bin/sh

set -x
set -e

test $(dirname $(readlink -fe $0)) = $(pwd) && (echo "E: do not run supermake-bootstrap in supermake"; exit 1)

test ! -d supermake && git submodule add https://github.com/eagafonov/supermake.git supermake
touch requirements-dev.txt
touch requirements-test.txt

test ! -f Makefile && echo "include supermake/python-sandbox.mk" > Makefile

