#!/bin/bash

set -e
set -o pipefail

lib="$(dirname $(realpath $0))/lib"

# kill child processes on exit
# https://stackoverflow.com/questions/360201/how-do-i-kill-background-processes-jobs-when-my-shell-script-exits/2173421#2173421
trap 'exit_code=$?; kill -- $(jobs -p); exit $exit_code' SIGINT SIGTERM EXIT

# Wait until postgres is available  
until psql -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
>&2 echo "Postgres is up - continuing"

>&2 echo "Checking if GTFS was already imported..."
if [[ $(psql -t -c 'SELECT 1 FROM agency LIMIT 1') ]]
then
    >&2 echo "GTFS data already imported, skipping build.sh"
else
    >&2 echo "No GTFS data imported in database, running build.sh ..."
    ./build.sh
fi

NODE_ENV=production node_modules/.bin/monitor-hafas \
	$lib/hafas.js \
	&

NODE_ENV=production node_modules/.bin/match-with-gtfs \
	$lib/hafas-info.js $lib/gtfs-info.js \
	&

NODE_ENV=production node_modules/.bin/serve-as-gtfs-rt \
	&

wait || exit 1 # fail if any child failed
