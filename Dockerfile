FROM node:8-alpine
MAINTAINER Ben Yanke <ben@benyanke.com>


# Set default settings
ENV EVENT_HOST=4 \
    EVENT_USER=taiga \
    EVENT_PW=3 \
    EVENT_PORT=80 \
    EVENT_SECRET=2 \
    EVENT_RABBITPORT=5

# Copy files in
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

# Install init
# RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["coffee", "/usr/src/taiga-events/index.coffee"]

