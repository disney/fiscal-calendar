{ DateTime, Interval } = require 'luxon' # https://moment.github.io/luxon/index.html
Holidays = require '@date/holidays' # https://github.com/elidoran/node-date-holidays

FiscalYearHelpers = require './fiscal-year-helpers'


module.exports = class FiscalYear
	constructor: (input) ->
		if typeof input is 'string' and /^\d{4}$/.test input # Input like '2001'
			@fiscalYear = Number input
		else if typeof input is 'number' and input >= 1000 and input < 10000
			@fiscalYear = input
		else if input instanceof DateTime
			@fiscalYear = input.year
		else if input instanceof Date
			@fiscalYear = input.getFullYear()
		else if input.format?
			@fiscalYear = Number input.format 'YYYY'
		else
			throw new Error 'FiscalYear expects a year'

		# Rather than calculate all potential dates in this fiscal year now, calculate each property only when it is requested and cache the results
		@cache = {}


	getFiscalYearEnd: ->
		return @cache.fiscalYearEnd if @cache.fiscalYearEnd
		@cache.fiscalYearEnd = FiscalYearHelpers.nearestSaturday(DateTime.fromObject
			year: @fiscalYear
			month: 9 # September
			day: 30
		).endOf 'day'

	getPreviousFiscalYearEnd: ->
		return @cache.previousFiscalYearEnd if @cache.previousFiscalYearEnd
		@cache.previousFiscalYearEnd = FiscalYearHelpers.nearestSaturday(DateTime.fromObject
			year: @fiscalYear - 1
			month: 9 # September
			day: 30
		).endOf 'day'

	getFiscalYearStart: ->
		return @cache.fiscalYearStart if @cache.fiscalYearStart
		@cache.fiscalYearStart = @getPreviousFiscalYearEnd().plus(days: 1).startOf 'day'


	getFiscalYearInterval: ->
		return @cache.fiscalYearInterval if @cache.fiscalYearInterval
		@cache.fiscalYearInterval = Interval.fromDateTimes @getFiscalYearStart(), @getFiscalYearEnd()


	getNumberOfWeeks: ->
		return @cache.numberOfWeeks if @cache.numberOfWeeks
		@cache.numberOfWeeks = Math.round(@getFiscalYearInterval().length('days') / 7)
