FROM alpine:3.11 AS installer

ARG RCLONE_VERSION=1.52.0
ARG CRYPTOMATOR_VERSION=0.4.0

RUN apk add --no-cache curl zip && \
    curl -sS -O https://downloads.rclone.org/v$RCLONE_VERSION/rclone-v$RCLONE_VERSION-linux-amd64.zip && \
    curl -sSL https://github.com/cryptomator/cli/releases/download/$CRYPTOMATOR_VERSION/cryptomator-cli-$CRYPTOMATOR_VERSION.jar > /usr/bin/cryptomator.jar && \
    unzip rclone-v$RCLONE_VERSION-linux-amd64.zip && \
    cd rclone-v$RCLONE_VERSION-linux-amd64 && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone;

########## ########## ##########

FROM alpine:3.11

COPY --from=installer /usr/bin/rclone /usr/bin/rclone
COPY --from=installer /usr/bin/cryptomator.jar /usr/bin/cryptomator.jar
COPY rootfs/ /

RUN apk add --no-cache openjdk11-jre-headless && \
    mkdir -p $HOME/.config/rclone && \
    chmod +x /docker-entrypoint.sh

VOLUME ["/export"]

ENTRYPOINT ["/docker-entrypoint.sh"]
