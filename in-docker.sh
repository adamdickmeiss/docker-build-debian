#!/bin/sh
# in-docker.sh
# Build Debian package in Docker. Use steps like this:
#  make dist
#  ../git-tools/id-deb-build/id-mk-deb-src.sh
#  docker run -it --rm -v "$PWD:/build" -w /build debian:jessie ./in-docker.sh
#
. /etc/os-release
CODE=`echo $VERSION |awk ' {print $2}'|tr '[:upper:]' '[:lower:]'|tr -d '()'`
echo $CODE
echo $ID
unset NAME VERSION
set -x
DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND
apt-get update && apt-get install -y wget devscripts
wget -q -O - http://ftp.indexdata.dk/${ID}/indexdata.asc|apt-key add -
echo "deb http://ftp.indexdata.dk/${ID} ${CODE} main" >/etc/apt/sources.list.d/indexdata.list
apt-get update
. ./IDMETA
DNAME=`awk '/Source:/ {print $2}' debian/control`
if test "$NAME" -a "$NAME" != "$DNAME"; then
	echo "NAME in IDMETA ($NAME) does not match debian/control ($DNAME)"
	exit 1
fi
NAME=$DNAME
RET=1
if test -d deb-src/${NAME}-${VERSION}; then
	cd deb-src/${NAME}-${VERSION}
	mk-build-deps
	dpkg -i ${NAME}-build-deps_*_all.deb || apt-get install -f -y
	rm ${NAME}-build-deps_*_all.deb 
	dpkg-buildpackage -rfakeroot
 	RET=$?
	cd ..
fi
exit $RET
