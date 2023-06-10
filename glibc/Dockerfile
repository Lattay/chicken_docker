# -*- mode: dockerfile; coding: utf-8 -*-
FROM debian:stable-slim AS build
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc
RUN apt-get -y --no-install-recommends install libc-dev
RUN apt-get -y --no-install-recommends install make
ARG PREFIX=/usr/local
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum -c checksum
RUN mkdir chicken && tar -C chicken --strip-components 1 -xf chicken.tar.gz
WORKDIR /build/chicken
RUN make PLATFORM=linux PREFIX=${PREFIX}
RUN make PLATFORM=linux PREFIX=${PREFIX} install
RUN ${PREFIX}/bin/chicken-install r7rs

FROM debian:stable-slim
ARG PREFIX=/usr/local
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc
RUN apt-get -y --no-install-recommends install libc-dev
RUN apt-get clean
COPY --from=build ${PREFIX} ${PREFIX}
RUN rm -r ${PREFIX}/share/man ${PREFIX}/share/chicken/doc
