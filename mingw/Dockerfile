# -*- mode: dockerfile; coding: utf-8 -*-
FROM debian:stable-slim AS build-dl
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install make
RUN apt-get -y --no-install-recommends install automake
WORKDIR /build
ADD https://github.com/dlfcn-win32/dlfcn-win32/archive/refs/tags/v1.3.0.tar.gz dlfcn.tar.gz
RUN tar --directory=. -xf dlfcn.tar.gz --strip-components=1
RUN ./configure --prefix=/usr/local --cc=x86_64-w64-mingw32-gcc-win32 --cross-prefix=x86_64-w64-mingw32-
RUN make
RUN make install

FROM debian:stable-slim AS build-rt
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install gcc libc-dev
RUN apt-get -y --no-install-recommends install make
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz
COPY runtime.mk config.mk
COPY Makefile.cross-linux-mingw Makefile.cross-linux-mingw
RUN mkdir /mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/mingw-chicken-rt \
         install

FROM lattay/chicken:5.2.0-amd64 AS build-comp
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install make
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz
COPY compiler.mk config.mk
RUN make CONFIG=config.mk \
         PREFIX=/usr/local \
         TARGET_PREFIX=/mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/usr/local \
         TARGET_PREFIX=/mingw-chicken-rt \
         install


FROM lattay/chicken:5.2.0-amd64
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get clean
COPY --from=build-comp /usr/local /usr/local
COPY --from=build-dl /usr/local /mingw-chicken-rt
COPY --from=build-rt /mingw-chicken-rt /mingw-chicken-rt
RUN win32-chicken-install r7rs
