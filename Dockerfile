# Stage one fetches and builds the 'ws' tool
# go get -u github.com/hashrocket/ws

FROM golang:alpine as wsbuild

RUN apk add git
RUN go get github.com/hashrocket/ws && \
    go install github.com/hashrocket/ws



# Stage 2 is the final container
FROM node:8-alpine
MAINTAINER Ben Yanke <ben@benyanke.com>

# Copy built 'ws' tool from previous run - this enables healthchecks
COPY --from=wsbuild /go/bin/ws /bin/ws

# Set default settings
ENV EVENT_HOST=rabbit \
    EVENT_USER=taiga \
    EVENT_PW= \
    EVENT_PORT=80 \
    EVENT_SECRET= \
    EVENT_RABBITPORT=5672

# Copy files
COPY taiga-events /usr/src/taiga-events
COPY config.json /etc/taiga-events/config.json
RUN rm -f /usr/src/taiga-events/config.json && \
    ln -s "/etc/taiga-events/config.json" "/usr/src/taiga-events/config.json"

WORKDIR /usr/src/taiga-events

RUN npm install --production && \
    npm install -g coffee-script

# Expose port 80
EXPOSE 80

COPY ./docker-entrypoint.sh /

# Add this later - need to test using the cmd:ping -> cmd:pong check
# HEALTHCHECK --interval=10s --timeout=3s \
#  CMD /bin/ws ws://localhost


ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["coffee", "/usr/src/taiga-events/index.coffee"]

