#!/bin/bash

if [[ "x$1" = "x" ]]; then
    cat <<EOF
Usage:
    $0 <version>

Example:
    $0 0.9.3
EOF
    exit
else
    VERSION="$1"
fi

TMPDIR=/tmp/thrift-cpan
TARBALL="thrift-${VERSION}.tar.gz"

rm -rf -- "${TMPDIR}"
mkdir -p "${TMPDIR}"

cd "${TMPDIR}"
wget -c "http://apache.stu.edu.tw/thrift/${VERSION}/${TARBALL}"
tar -zxv -f "${TARBALL}"

cd "thrift-${VERSION}/lib/perl"

# patch version
find . -name '*.pm' | xargs grep -HL '^our \$VERSION' | xargs -n1 sed -i -e "/^package /a our \$VERSION='${VERSION}';"

perl Makefile.PL
make
make manifest
make dist
