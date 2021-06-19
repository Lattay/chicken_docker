# -*- mode: dockerfile; coding: utf-8 -*-
FROM gcc
WORKDIR /build
COPY checksum checksum
ADD https://code.call-cc.org/releases/5.2.0/chicken-5.2.0.tar.gz chicken.tar.gz
RUN sha256sum chicken.tar.gz && sha256sum -c checksum
RUN mkdir chicken && tar -C chicken --strip-components 1 -xf chicken.tar.gz
WORKDIR /build/chicken
RUN make PLATFORM=linux
RUN make PLATFORM=linux install
RUN chicken-install r7rs
RUN ln -s csi /usr/local/bin/scheme-banner
WORKDIR /
RUN rm -rf /build
CMD ["scheme-banner"]
