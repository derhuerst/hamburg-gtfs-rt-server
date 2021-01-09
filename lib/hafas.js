'use strict'

const transformReq = require('hafas-gtfs-rt-feed/lib/transform-hafas-req')
const hvvProfile = require('hafas-client/p/hvv')
const withThrottling = require('hafas-client/throttle')
const createHafas = require('hafas-client')

const hafas = createHafas({
	...withThrottling(hvvProfile, 25, 1000), // 25 req/s
	transformReq,
}, 'hafas-gtfs-rt-server-example')

module.exports = hafas
