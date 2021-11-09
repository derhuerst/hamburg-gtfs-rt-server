#!/bin/bash

set -e
set -o pipefail
set -x

>&2 echo "Checking if GTFS was already imported..."
if [[ $(psql -t -c 'SELECT 1 FROM agency LIMIT 1') ]]
then
    >&2 echo "GTFS data already imported, skipping build.sh"
    exit 0
fi

# todo: find a URL that always points to the latest dataset
wget -O gtfs.zip 'http://daten.transparenz.hamburg.de/Dataport.HmbTG.ZS.Webservice.GetRessource100/GetRessource100.svc/f9a0a485-02c4-4bfd-a40e-f084cfda48d0/Upload__HVV_Rohdaten_GTFS_Fpl_20211105.zip'
unzip -o -d gtfs -j gtfs.zip

env | grep '^PG'

NODE_ENV=production node_modules/.bin/gtfs-to-sql -d --trips-without-shape-id --routes-without-agency-id -- \
	gtfs/agency.txt \
	gtfs/calendar.txt \
	gtfs/calendar_dates.txt \
	gtfs/frequencies.txt \
	gtfs/routes.txt \
	gtfs/shapes.txt \
	gtfs/stop_times.txt \
	gtfs/stops.txt \
	gtfs/transfers.txt \
	gtfs/trips.txt \
	| psql -b

lib="$(dirname $(realpath $0))/lib"
NODE_ENV=production node_modules/.bin/build-gtfs-match-index \
	$lib/hafas-info.js $lib/gtfs-info.js \
	| psql -b
