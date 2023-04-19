#!/bin/sh

TEMPDIR=$(mktemp -d)

cp -r $HOME/.config/qutebrowser/* ${TEMPDIR}/
qutebrowser --basedir=${TEMPDIR}
rm -r ${TEMPDIR}
