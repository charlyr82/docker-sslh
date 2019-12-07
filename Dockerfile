FROM alpine:latest

ENV LISTEN_IP 0.0.0.0
ENV LISTEN_PORT 443
ENV SSH_HOST localhost
ENV SSH_PORT 22
ENV OPENVPN_HOST localhost
ENV OPENVPN_PORT 1194
ENV HTTPS_HOST localhost
ENV HTTPS_PORT 8443
ENV SHADOWSOCKS_HOST localhost
ENV SHADOWSOCKS_PORT 8388

RUN BUILD_DEPS="gcc pcre-dev musl-dev make libconfig-dev"; \
    VERSION=1.20; \
    apk --no-cache add pcre openssl libconfig $BUILD_DEPS && \
    cd /tmp && \
    wget -O sslh.zip https://github.com/yrutschle/sslh/archive/v$VERSION.zip && \
    unzip sslh.zip && \
    cd sslh-$VERSION && \
    sed -i 's/^USELIBPCRE=.*/USELIBPCRE=1/' Makefile && \
    make sslh && \
    cp ./sslh-fork ./sslh-select /usr/local/bin && \
    cp COPYING / && \
    ln /usr/local/bin/sslh-fork /usr/local/bin/sslh && \
    apk del $BUILD_DEPS && \
    cd / && rm -rf /tmp/sshl*

ADD entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

ENTRYPOINT ["/usr/local/bin/entry.sh"]
