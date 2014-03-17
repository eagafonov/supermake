#!/bin/bash
P=''
F=''

PYTHON=python

PYTHONPATH=$PYTHONPATH:`pwd`/smpp.twisted:`pwd`/smpp.pdu
export PYTHONPATH
TRIAL=`which trial`
COVERAGE=`which python-coverage`

if [ ! -x "$COVERAGE" ]; then
    echo "W: Coverate tool is not installed. Report will not be generated"
fi

TESTS=$@

if [ -z "$TESTS" ]; then
    TESTS=`find tests -name 'test_*.py'`
fi

for tc in $TESTS; do
    echo "I: Execute $tc"
    if [ -x "$COVERAGE" ]; then
        $COVERAGE run -p --source `dirname $0` $TRIAL $tc
    else
        $PYTHON $TRIAL $tc
    fi

    if (($?)); then
        F="$F$tc\n"
    else
        P="$P$tc\n"
    fi
done

echo '******************'
echo 'PASSED'
echo -e $P
echo "FAILED"
echo -e $F

if [ -x "$COVERAGE" ]; then
    $COVERAGE combine
    rm -Rf htmlcov
    $COVERAGE html --omit="`pwd`/tests/test_*.py"
    echo "Coveage HTMl report is stored in file://`pwd`/htmlcov/index.html"
else
    echo "No coveage HTMl report is generated"
fi
