'use strict'

const {
	normalizeStopName,
	normalizeLineName,
} = require('./normalize')

const gtfsRtInfo = {
	endpointName: 'hvv-hafas', // todo?
	normalizeStopName,
	normalizeLineName,
}

module.exports = gtfsRtInfo
