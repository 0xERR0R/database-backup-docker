FROM alpine

LABEL org.opencontainers.image.source="https://github.com/0xERR0R/database-backup-docker" \
      org.opencontainers.image.url="https://github.com/0xERR0R/database-backup-docker" \
      org.opencontainers.image.title="Docker based MySQL backup"

RUN apk add --no-cache \
        bash \
        mysql-client \
        gzip \
        openssl \
        tzdata

COPY *.sh .
RUN mkdir /backup && chmod u+x /backup.sh
VOLUME ["/backup"]

ENTRYPOINT /backup.sh
