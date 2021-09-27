'use strict'

const {
	normalizeStopName,
	normalizeLineName,
} = require('./normalize')

const hafasInfo = {
	endpointName: 'hvv-hafas',
	normalizeStopName,
	normalizeLineName,
}

module.exports = hafasInfo
