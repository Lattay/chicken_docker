# Build the Chicken Runtime for Windows
FROM debian:stable-slim AS build-rt
ARG PREFIX=/usr/local
ARG PREFIX_RT=/mingw-chicken-rt
RUN apt-get update
RUN apt-get -y --no-install-recommends install make
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
WORKDIR /build
COPY ../source-checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz

COPY runtime.mk config.mk
COPY Makefile.cross-linux-mingw Makefile.cross-linux-mingw
RUN mkdir /mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=${PREFIX_RT}
RUN make CONFIG=config.mk \
         PREFIX=${PREFIX_RT} \
         install

# Build the Chicken Cross compiler
FROM debian:stable-slim AS build-comp
ARG PREFIX=/usr/local
ARG PREFIX_RT=/mingw-chicken-rt
RUN apt-get update
RUN apt-get -y --no-install-recommends install make
RUN apt-get -y --no-install-recommends install gcc libc-dev
WORKDIR /build
COPY ../source-checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz
COPY compiler.mk config.mk
RUN make CONFIG=config.mk \
         PREFIX=${PREFIX} \
         TARGET_PREFIX=${PREFIX_RT}
RUN make CONFIG=config.mk \
         PREFIX=${PREFIX} \
         TARGET_PREFIX=${PREFIX_RT} \
         install

FROM debian:stable-slim
ARG PREFIX=/usr/local
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install g++-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install gcc libc-dev
RUN apt-get clean
COPY --from=build-comp ${PREFIX} ${PREFIX}
COPY --from=build-rt ${PREFIX_RT} ${PREFIX_RT}
RUN ${PREFIX}/bin/win32-chicken-install r7rs
