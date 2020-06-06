FROM alpine:3.11 AS installer

RUN apk add --no-cache curl zip && \
    curl -sS -O https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    curl -sSL https://github.com/cryptomator/cli/releases/download/0.4.0/cryptomator-cli-0.4.0.jar > '/usr/bin/cryptomator.jar' && \
    unzip rclone-current-linux-amd64.zip && \
    cd rclone-*-linux-amd64 && \
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
