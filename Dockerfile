FROM alpine as builder

#COPY qemu-* /usr/bin/

FROM builder

LABEL maintainer="Jay MOULIN <jaymoulin@gmail.com> <https://twitter.com/MoulinJay>"
ARG VERSION=2.94
LABEL version=${VERSION}

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \ 
apk update --no-cache && \
apk add transmission-daemon
WORKDIR /usr/bin

# Install transmission-web-control (https://github.com/ronggang/transmission-web-control)
ADD https://raw.githubusercontent.com/ronggang/transmission-web-control/master/release/install-tr-control.sh /tmp
RUN echo 1 | sh /tmp/install-tr-control.sh \
    && rm /tmp/install-tr-control.sh

EXPOSE 9091
EXPOSE 51413
EXPOSE 51413/udp

VOLUME /output
VOLUME /to_download
VOLUME /config

ENV USERNAME=admin
ENV PASSWORD=admin
ENV PORT=9091

CMD transmission-daemon -c /to_download -w /output -f -t -a *.*.*.* -u "$USERNAME" -v "$PASSWORD" -p "$PORT" -g /config
