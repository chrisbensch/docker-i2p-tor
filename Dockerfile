FROM alpine:latest

LABEL maintainer="Chris Bensch <chris.bensch@gmail.com>"

RUN mkdir -p /home/i2pd/bin && \  
  apk --no-cache --virtual build-dependendencies add \
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
    upx \
  && cd /tmp \
  && I2PD_VERSION=$(wget -qO - https://api.github.com/repos/purplei2p/i2pd/releases/latest | grep 'tag_name'| cut -d'"' -f 4) \
  && git clone --depth 1 --branch $I2PD_VERSION https://github.com/PurpleI2P/i2pd.git \
  && cd /tmp/i2pd/build \
  && cmake -DWITH_AESNI=ON -DWITH_UPNP=ON . \
  && make \
  && strip i2pd \
  # Optimize for size, but slow
  #&& upx --ultra-brute i2pd \
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
  && addgroup -g 1000 i2pd \
  && adduser -u 1000 -G i2pd -s /bin/sh -h "/home/i2pd" -D i2pd \
  && chown -R i2pd:i2pd /home/i2pd \
  && chmod 0700 /home/i2pd/bin/i2pd \
  && chmod +x /entrypoint.sh 

COPY data/ /home/i2pd/data/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]