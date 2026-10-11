ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
FROM $BUILD_FROM

RUN apk add --no-cache freeradius freeradius-utils bashio

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
