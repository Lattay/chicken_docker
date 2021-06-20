# -*- mode: dockerfile; coding: utf-8 -*-
FROM debian:stable-slim AS build
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc
RUN apt-get -y --no-install-recommends install libc-dev
RUN apt-get -y --no-install-recommends install make
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN mkdir chicken && tar -C chicken --strip-components 1 -xf chicken.tar.gz
WORKDIR /build/chicken
RUN make PLATFORM=linux
RUN make PLATFORM=linux install
RUN chicken-install r7rs

FROM debian:stable-slim
RUN apt-get update
RUN apt-get -y --no-install-recommends install gcc
RUN apt-get -y --no-install-recommends install libc-dev
RUN apt-get clean
COPY --from=build /usr/local/ /usr/local/
RUN rm -r /usr/local/share/man /usr/local/share/chicken/doc
