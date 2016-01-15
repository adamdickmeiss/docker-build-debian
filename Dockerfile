FROM debian:jessie
ARG version=5.15.2
ARG product=yaz
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y wget devscripts
RUN wget -q -O - http://ftp.indexdata.dk/debian/indexdata.asc|apt-key add -
RUN echo "deb http://ftp.indexdata.dk/debian jessie main" >/etc/apt/sources.list.d/indexdata.list
RUN apt-get update
RUN mkdir /build
COPY ${product}-${version}.tar.gz /build/${product}-${version}.tar.gz
RUN cd /build && tar zxf ${product}-${version}.tar.gz
RUN mkdir /build/${product}-${version}/debian
COPY debian/* /build/${product}-${version}/debian/
RUN cd /build/${product}-${version} && mk-build-deps
RUN cd /build/${product}-${version} && \
	dpkg -i ${product}-build-deps_${version}-1.indexdata_all.deb || \
	apt-get install -f -y
RUN cd /build/${product}-${version} && dpkg-buildpackage -rfakeroot
