'use strict'

const {
	normalizeStopName,
	normalizeLineName,
} = require('./normalize')

const gtfsInfo = {
	endpointName: 'hvv-gtfs', // todo?
	normalizeStopName,
	normalizeLineName,
}

module.exports = gtfsInfo
