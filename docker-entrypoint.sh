#!/bin/sh

echo ""
echo "Starting up Taiga Events container"
echo ""
echo "Configuring events based on your env vars"

sed -i 's/EVENT_PORT/'"$EVENT_PORT"'/g' /etc/taiga-events/config.json
sed -i 's/EVENT_SECRET/'"$EVENT_SECRET"'/g' /etc/taiga-events/config.json
sed -i 's/EVENT_USER/'"$EVENT_USER"'/g' /etc/taiga-events/config.json
sed -i 's/EVENT_PW/'"$EVENT_PW"'/g' /etc/taiga-events/config.json
sed -i 's/EVENT_HOST/'"$EVENT_HOST"'/g' /etc/taiga-events/config.json
sed -i 's/EVENT_RABBITPORT/'"$EVENT_RABBITPORT"'/g' /etc/taiga-events/config.json

echo ""
echo "Configuration done. Starting app."
echo ""

# Runs the CMD from dockerfile
exec "$@"
