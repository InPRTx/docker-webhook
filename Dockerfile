FROM        golang:1.16.6-alpine3.14 AS BUILD_IMAGE
RUN         apk add --update --no-cache -t build-deps curl gcc libc-dev libgcc
WORKDIR     /go/src/github.com/adnanh/webhook
COPY        webhook.version .
RUN         curl -#L -o webhook.tar.gz https://api.github.com/repos/adnanh/webhook/tarball/$(cat webhook.version) && \
            tar -xzf webhook.tar.gz --strip 1 &&  \
            go get -d && \
            go build -ldflags="-s -w" -o /usr/local/bin/webhook

FROM        alpine:3.14.0
RUN         apk add --update --no-cache curl tini tzdata openssl
COPY        --from=BUILD_IMAGE /usr/local/bin/webhook /usr/local/bin/webhook
COPY        start.sh /usr/local/bin/start.sh
WORKDIR     /config
EXPOSE      9000
ENTRYPOINT  ["/sbin/tini", "--", "/usr/local/bin/start.sh"]
CMD         ["-verbose", "-hotreload", "-hooks=hooks.yml"]