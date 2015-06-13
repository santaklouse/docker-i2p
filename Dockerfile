FROM debian:jessie
MAINTAINER Philip Southam <philip@eml.cc>
ENV DEBIAN_FRONTEND noninteractive
COPY debian-repo.pub /
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 &&\
  apt-key add /debian-repo.pub &&\
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list &&\
  echo "deb http://deb.i2p2.no/ stable main" | tee /etc/apt/sources.list.d/i2p.list &&\
  apt-get update &&\
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections &&\
  apt-get install --quiet --yes oracle-java8-installer oracle-java8-set-default i2p procps &&\
  apt-get clean

ADD config /root/.i2p

EXPOSE 4444/tcp 4445/tcp 6668/tcp 7657/tcp

CMD ["/usr/bin/i2prouter", "launchdinternal"]
