'use strict'

// todo: adapt this to HVV
const tokenize = require('tokenize-vbb-station-name')
const slugg = require('slugg')
const QuickLRU = require('quick-lru')

const cache = new QuickLRU({maxSize: 300})
const normalizeStopName = (name) => {
	if (cache.has(name)) return cache.get(name)
	const normalizedName = tokenize(name, {meta: 'remove'}).join('-')
	cache.set(name, normalizedName)
	return normalizedName
}

// we match hafas-client here
// https://github.com/public-transport/hafas-client/blob/8ed218f4d62a0c220d453b1b1ffa7ce232f1bb83/parse/line.js#L13
// todo: check that this actually works
const normalizeLineName = (name) => {
	return slugg(name.replace(/([a-zA-Z]+)\s+(\d+)/g, '$1$2'))
}

module.exports = {
	normalizeStopName,
	normalizeLineName,
}
