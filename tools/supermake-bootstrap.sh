#!/bin/sh

set -x
set -e

SM_DIR=$(dirname $(readlink -fe $0))

test $SM_DIR = $(pwd) && (echo "E: do not run supermake-bootstrap in supermake"; exit 1)

test ! -d .git && git init

test ! -d supermake && git submodule add https://github.com/eagafonov/supermake.git supermake
test ! -f requirements-dev.txt && touch requirements-dev.txt && git add requirements-dev.txt
test ! -f requirements-test.txt && touch requirements-test.txt && git add requirements-test.txt
test ! -f .gitignore && (echo sandbox >> .gitignore && git add .gitignore) || (echo I: .gitignore exists)

test ! -f Makefile && cp $SM_DIR/Makefile.template Makefile && git add Makefile
