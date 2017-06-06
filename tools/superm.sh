#!/bin/sh

set -x
set -u
set -e

echo $@


SUPERMAKE_HOME=$(readlink -f $(dirname $(readlink -f $0))/..)

make -f ${SUPERMAKE_HOME}/tools/Makefile SUPERMAKE_HOME=${SUPERMAKE_HOME} $@
