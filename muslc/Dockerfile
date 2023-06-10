# -*- mode: dockerfile; coding: utf-8 -*-
FROM alpine:latest AS build
ARG PREFIX=/usr/local
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache make
WORKDIR /build
COPY ../source-checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum -c checksum
RUN mkdir chicken && tar -C chicken --strip-components 1 -xf chicken.tar.gz
WORKDIR /build/chicken
RUN make PLATFORM=linux PREFIX=${PREFIX}
RUN make PLATFORM=linux PREFIX=${PREFIX} install
RUN ${PREFIX}/bin/chicken-install r7rs

FROM alpine:latest
ARG PREFIX=/usr/local
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
COPY --from=build ${PREFIX} ${PREFIX}
RUN rm -r ${PREFIX}/share/man ${PREFIX}/share/chicken/doc
