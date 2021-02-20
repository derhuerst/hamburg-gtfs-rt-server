#!/bin/bash

set -e
set -o pipefail
set -x

# todo: find a URL that always points to the latest dataset
wget -O gtfs.zip 'http://daten.transparenz.hamburg.de/Dataport.HmbTG.ZS.Webservice.GetRessource100/GetRessource100.svc/daf903e6-d3f9-4ce7-8880-d11f7252ae30/Upload__HVV_Rohdaten_GTFS_Fpl_20210204.zip'
unzip -o -d gtfs -j gtfs.zip

env | grep '^PG'

NODE_ENV=production node_modules/.bin/gtfs-to-sql \
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
	-d | psql -b

lib="$(dirname $(realpath $0))/lib"
NODE_ENV=production node_modules/.bin/build-gtfs-match-index \
	$lib/hafas-info.js $lib/gtfs-info.js \
	| psql -b
