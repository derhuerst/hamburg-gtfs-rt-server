'use strict'

const {
	normalizeStopName,
	normalizeLineName,
} = require('./normalize')

const hafasInfo = {
	endpointName: 'hvv-hafas', // todo?
	normalizeStopName,
	normalizeLineName,
}

module.exports = hafasInfo
