# Build the Chicken Runtime for Windows
FROM debian:stable-slim AS build-rt
RUN apt-get update
RUN apt-get -y --no-install-recommends install make
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz

RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
COPY runtime.mk config.mk
COPY Makefile.cross-linux-mingw Makefile.cross-linux-mingw
RUN mkdir /mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/mingw-chicken-rt \
         install

# Build the Chicken Cross compiler
FROM debian:stable-slim AS build-comp
RUN apt-get update
RUN apt-get -y --no-install-recommends install make
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN tar --directory=. --strip-components 1 -xf chicken.tar.gz

RUN apt-get -y --no-install-recommends install gcc libc-dev
COPY compiler.mk config.mk
RUN make CONFIG=config.mk \
         PREFIX=/usr/local \
         TARGET_PREFIX=/mingw-chicken-rt
RUN make CONFIG=config.mk \
         PREFIX=/usr/local \
         TARGET_PREFIX=/mingw-chicken-rt \
         install

FROM debian:stable-slim
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install g++-mingw-w64-x86-64
RUN apt-get -y --no-install-recommends install gcc libc-dev
RUN apt-get clean
COPY --from=build-comp /usr/local /usr/local
COPY --from=build-rt /mingw-chicken-rt /mingw-chicken-rt
RUN win32-chicken-install r7rs
