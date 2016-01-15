FROM debian:jessie
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y wget devscripts autoconf automake libtool 
RUN wget -q -O - http://ftp.indexdata.dk/debian/indexdata.asc|apt-key add -
RUN echo "deb http://ftp.indexdata.dk/debian jessie main" >/etc/apt/sources.list.d/indexdata.list
RUN apt-get update
COPY yaz-5.15.2.tar.gz yaz-5.15.2.tar.gz
RUN tar zxf yaz-5.15.2.tar.gz
COPY debian yaz-5.15.2
RUN cd yaz-5.15.2 && mk-build-deps -i -r
RUN cd yaz-5.15.2 && dpkg-buildpackage -rfakeroot
