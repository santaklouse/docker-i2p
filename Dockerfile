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
