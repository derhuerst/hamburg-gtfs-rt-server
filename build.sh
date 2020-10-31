#!/bin/bash

set -e
set -o pipefail
set -x

# todo: find a URL that always points to the latest dataset
wget -O gtfs.zip 'http://daten.transparenz.hamburg.de/Dataport.HmbTG.ZS.Webservice.GetRessource100/GetRessource100.svc/a8f75e6f-84a8-4c12-8cbe-fb3e2c7e9df0/Upload__HVV_Rohdaten_GTFS_Fpl_20201002.zip'
unzip -o -d gtfs -j gtfs.zip

NODE_ENV=production node_modules/.bin/gtfs-to-sql \
	gtfs/agency.txt \
	gtfs/calendar.txt \
	gtfs/calendar_dates.txt \
	gtfs/frequencies.txt \
	gtfs/routes.txt \
	gtfs/stop_times.txt \
	gtfs/stops.txt \
	gtfs/transfers.txt \
	gtfs/trips.txt \
	-d | psql -b

NODE_ENV=production node_modules/.bin/build-gtfs-match-index | psql -b
