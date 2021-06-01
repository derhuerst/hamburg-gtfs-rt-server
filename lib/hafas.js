'use strict'

const hvvProfile = require('hafas-client/p/hvv')
const withThrottling = require('hafas-client/throttle')
const createHafas = require('hafas-client')

const hafas = createHafas(
	withThrottling(hvvProfile, 25, 1000), // 25 req/s
	'hafas-gtfs-rt-server-example',
)

module.exports = hafas
