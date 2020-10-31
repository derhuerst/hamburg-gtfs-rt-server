'use strict'

const createGtfsRtWriter = require('hafas-gtfs-rt-feed/writer')
const differentialToFullDataset = require('gtfs-rt-differential-to-full-dataset')
const computeEtag = require('etag')
const serveBuffer = require('serve-buffer')
const {pipeline} = require('stream')
const {parse} = require('ndjson')
const createCors = require('cors')
const {createServer} = require('http')
const createLogger = require('./lib/logger')
const {POSITION, TRIP} = require('./lib/protocol')

const logger = createLogger('serve')

const onError = (err) => {
	if (!err) return;
	logger.error(err)
	process.exit(1)
}

const {
	out: gtfsRt,
	writeTrip, writePosition,
} = createGtfsRtWriter({
	encodePbf: false, // todo
})

const differentialToFull = differentialToFullDataset({
	ttl: 5 * 60 * 1000, // 5m
})

let feed = Buffer.alloc(0)
let timeModified = new Date()
let etag = computeEtag(feed)
differentialToFull.on('change', () => {
	feed = differentialToFull.asFeedMessage()
	timeModified = new Date()
	etag = computeEtag(feed)
})

const onRequest = (req, res) => {
	const path = new URL(req.url, 'http://localhost').pathname
	if (path === '/') {
		serveBuffer(req, res, feed, {timeModified, etag})
	} else {
		res.statusCode = 404
		res.end('nope')
	}
}

const parser = parse()
pipeline(
	process.stdin,
	parser,
	onError,
)

parser.on('data', (item) => {
	if (item[0] === POSITION) {
		writePosition(item[1], item[2])
	} else if (item[0] === TRIP) {
		writeTrip(item[1])
	} else {
		logger.warn('invalid/unknown item', item)
	}
})

pipeline(
	gtfsRt,
	differentialToFull,
	onError,
)

const cors = createCors()
createServer((req, res) => {
	cors(req, res, (err) => {
		if (err) {
			res.statusCode = err.statusCode || 500
			res.end(err + '')
		} else {
			onRequest(req, res)
		}
	})
})
.listen(process.env.PORT || 3000, onError)
