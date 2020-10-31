# Inofficial [GTFS Realtime](https://gtfs.org/reference/realtime/v2/) feed for Hamburg

**This endpoint provides realtime transit data for Hamburg in the [GTFS Realtime (GTFS-RT)](https://gtfs.org/reference/realtime/v2/) format.**

[![API status](https://badgen.net/uptime-robot/status/m786241281-20b657adafa29b96eef65372)](https://stats.uptimerobot.com/57wNLs39M/786241281)

Underneath, it works by polling the [HVV](https://en.wikipedia.org/wiki/Hamburger_Verkehrsverbund) [HAFAS endpoint](https://github.com/public-transport/hafas-client/tree/5/p/hvv) underneath. Those interested in delays of *all* vehicles, instead of a particular one, don't have to poll HVV's API brute-force: They're able to fetch the data efficiently from here.

*Note:* This feed is run by people *not related* to [HVV](https://en.wikipedia.org/wiki/Hamburger_Verkehrsverbund) and the government.


## Why use this API?

- **Realtime Data** – This API returns realtime data whenever the underlying [API for HVV's mobile app](https://github.com/public-transport/hafas-client/tree/5/p/hvv) provides it.
- **No API Key** – You can just use the API without authentication.
- **CORS** – This API has [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS) enabled, so you can query it from any webpage.
- **Caching-friendly** – This API sends [`ETag`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag) & [`Date`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date) headers, allowing clients to cache responses properly.


## Getting Started

*Note:* This project is work-in-progress, the feed might go offline at any time! I'm happy to receive any kind of feedback via the [`hamburg-gtfs-rt-server` GitHub Issues](https://github.com/derhuerst/hamburg-gtfs-rt-server/issues).

**The URL of the GTFS-RT feed is [`https://v0.hamburg-gtfs-rt.transport.rest/feed`](https://v0.hamburg-gtfs-rt.transport.rest/feed).**

As an example, let's use [`print-gtfs-rt-cli`](https://github.com/derhuerst/print-gtfs-rt-cli) and [`jq`](https://stedolan.github.io/jq/) to inspect it:

```shell
curl 'https://v0.hamburg-gtfs-rt.transport.rest/feed' -s | print-gtfs-rt --json | head -n 1 | jq
```

```json
{
	"id": "10989100",
	"is_deleted": false,
	"trip_update": null,
	"vehicle": {
		"trip": {
			"trip_id": "143651102",
			"route_id": "17453_700",
			"direction_id": 0,
			"start_time": "",
			"start_date": "",
			"schedule_relationship": 0
		},
		"vehicle": {
			"id": "m41",
			"label": "U Hermannplatz",
			"license_plate": ""
		},
		"position": {
			"latitude": 52.48768997192383,
			"longitude": 13.42607307434082,
			"bearing": 0,
			"odometer": 0,
			"speed": 0
		},
		"current_stop_sequence": 0,
		"stop_id": "900000078105",
		"current_status": 1,
		"timestamp": 0,
		"congestion_level": 0,
		"occupancy_status": 0
	},
	"alert": null
}
```
