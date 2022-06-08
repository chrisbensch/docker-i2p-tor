FROM alpine:latest

LABEL maintainer="Chris Bensch <chris.bensch@gmail.com>"

COPY data/conf/ /home/i2pd/data/conf/

COPY network/ /home/i2pd/network/
COPY data/certificates/ /home/i2pd/data/certificates/
COPY entrypoint.sh /

# install deps && build i2p binary
RUN mkdir -p /home/i2pd/data/addressbook \
  && mkdir /home/i2pd/bin \
  && apk --no-cache --virtual build-dependendencies add \
    cmake \
    make \
    gcc \
    g++ \
    binutils \
    libtool \
    libev-dev \
    check-dev \
    zlib-dev \
    boost-dev \
    build-base \
    openssl-dev \
    openssl \
    git \
    autoconf \
    automake \
    miniupnpc-dev \
  && cd /tmp \
  && git clone --depth 1 --branch 2.42.1 https://github.com/PurpleI2P/i2pd.git \
  && cd /tmp/i2pd/build \
  && cmake -DWITH_AESNI=ON -DWITH_UPNP=ON . \
  && make \
  && strip i2pd \
  && mv /tmp/i2pd/build/i2pd /home/i2pd/bin/i2pd \
  # clean up /tmp
  && cd /home/i2pd \
  && rm -rf /tmp/i2pd \
  # remove build dependencies
  && apk --no-cache --purge del build-dependendencies \
  # i2p runtime dependencies
  && apk --no-cache add \
    boost-filesystem \
    boost-system \
    boost-program_options \
    boost-date_time \
    openssl \
    musl-utils \
    libstdc++ \
    sed \
    miniupnpc-dev \
  #&& cp /home/i2pd/conf/addresses.csv /home/i2pd/data/addressbook/addresses.csv \
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd \
  && chmod +x /entrypoint.sh 
#USER i2pd
VOLUME [ "/home/i2pd/data/" ]
WORKDIR "/home/i2pd/"
ENTRYPOINT ["/entrypoint.sh"]