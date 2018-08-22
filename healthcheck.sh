#!/bin/sh

(echo '{"cmd":"ping"}' ; sleep 1 ; ) | ws ws://localhost/events 2>&1 3>&1 | grep '{"cmd":"pong"}' &> /dev/null

if [[ "$?" = "0" ]] ; then

  echo "healthy"
  exit 0;

else

  echo "unhealthy"
  exit 1;

fi
