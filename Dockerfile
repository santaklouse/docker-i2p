FROM jlesage/baseimage:alpine-3.15-glibc as builder

ENV APP_HOME="/i2p"

WORKDIR /tmp/build
COPY . .

RUN add-pkg --virtual build-base gettext tar bzip2 apache-ant openjdk17 \
    && ant preppkg-linux-only \
    && rm -rf pkg-temp/osid pkg-temp/lib/wrapper pkg-temp/lib/wrapper.* \
    && del-pkg build-base gettext tar bzip2 apache-ant openjdk17

FROM jlesage/baseimage:alpine-3.15-glibc
ENV APP_HOME="/i2p"

RUN add-pkg openjdk17-jre
WORKDIR ${APP_HOME}
COPY --from=builder /tmp/build/pkg-temp .

# "install" i2p by copying over installed files
COPY docker/rootfs/ /



# Metadata.
LABEL \
      org.label-schema.name="i2p" \
      org.label-schema.description="Docker container for I2P" \
      org.label-schema.version="1.0" \
      org.label-schema.vcs-url="https://github.com/i2p/i2p.i2p" \
      org.label-schema.schema-version="1.0"



FROM ubuntu:jammy
MAINTAINER Philip Southam <philip@eml.cc>
ENV DEBIAN_FRONTEND noninteractive

RUN apt update ; apt upgrade -y && \
  apt-get install --quiet --yes i2p procps &&\
  apt-get clean &&\
  rm -rf /var/lib/apt/lists/*

ADD config /root/.i2p

EXPOSE 4444/tcp 4445/tcp 6668/tcp 7657/tcp

CMD ["/usr/bin/i2prouter", "launchdinternal"]



