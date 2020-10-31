# hamburg-gtfs-rt-server

**Poll the [HVV](https://en.wikipedia.org/wiki/Hamburger_Verkehrsverbund) [HAFAS endpoint](https://github.com/public-transport/hafas-client/tree/5/p/hvv) to provide a [GTFS Realtime (GTFS-RT)](https://gtfs.org/reference/realtime/v2/) feed for Hamburg.**

![ISC-licensed](https://img.shields.io/github/license/derhuerst/hamburg-gtfs-rt-server.svg)
[![chat with me on Gitter](https://img.shields.io/badge/chat%20with%20me-on%20gitter-512e92.svg)](https://gitter.im/derhuerst)
[![support me via GitHub Sponsors](https://img.shields.io/badge/support%20me-donate-fa7664.svg)](https://github.com/sponsors/derhuerst)

This project

1. uses [`hafas-client`](https://github.com/public-transport/hafas-client) & [`hafas-monitor-trips`](https://github.com/derhuerst/hafas-monitor-trips) to fetch live data about all vehicles in the Hamburg & surroundings bounding box,
2. uses [`hafas-gtfs-rt-feed`](https://github.com/derhuerst/hafas-gtfs-rt-feed) & [`gtfs-rt-differential-to-full-dataset`](https://github.com/derhuerst/gtfs-rt-differential-to-full-dataset) to build a live [GTFS Realtime (GTFS-RT)](https://developers.google.com/transit/gtfs-realtime/) feed from the data,
3. uses [`serve-buffer`](https://github.com/derhuerst/serve-buffer) to serve the feed efficiently.


## Installing & running

### Prerequisites

`hamburg-gtfs-rt-server` needs access to a [Redis](https://redis.io/) server, you can configure a custom host/port by setting the `REDIS_URL` environment variable. It also needs a [PostgreSQL](https://www.postgresql.org) 12+ server to work, you can configure access using the [`PG*` environment variables](https://www.postgresql.org/docs/12/libpq-envars.html).

```shell
git clone https://github.com/derhuerst/hamburg-gtfs-rt-server.git
cd hamburg-gtfs-rt-server
npm install --production
```

### Building the matching index

```shell
npm run build
```

The build script will download [the latest HVV GTFS Static data](https://suche.transparenz.hamburg.de/dataset?esq_type=app&esq_type=dataset&esq_type=document&f=PDF&f=HTML&f=ZIP&f=CSV&f=XML&f=xlsx&f=XLS&f=gml&f=wms&f=wfs&f=rar&f=TXT&f=jpg&f=jpeg&f=ascii&f=png&f=dxf&f=web&f=citygml&f=ert&f=docx&f=ov2&f=tiff&f=xsd&l=dl-de-by-2.0&l=dl-de-zero-2.0&esq_not_all_versions=true&esq_coverage_type=publication&e=vergleichbar&g=transport-und-verkehr&change_search=1&sort=publishing_date+desc%2Ctitle_sort+asc&esq_not_all_versions=true) and import it into PostgreSQL. Then, it will add [additional lookup tables to match realtime data with GTFS Static data](https://github.com/derhuerst/match-gtfs-rt-to-gtfs). [`psql`](https://www.postgresql.org/docs/current/app-psql.html) will need to have access to your database.

### Running

Specify the bounding box to be observed as JSON:

```shell
export BBOX='{"north": 53.6744, "west": 9.7559, "south": 53.3660, "east": 10.2909}'
```

`hamburg-gtfs-rt-server` is split into three parts: polling the HAFAS endpoint, matching realtime data & serving a GTFS-RT feed. These parts are implemented as separate processes:

```shell
node monitor.js | node match.js | node serve.js
```

*Note:* I recommend to run them with [`set -o pipefail`](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/). Also, use a tool like [`systemctl`](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units) or [`forever`](https://github.com/foreversd/forever#readme) that restarts them when they crash.
