{ DateTime, Interval } = require 'luxon' # https://moment.github.io/luxon/index.html
Holidays = require '@date/holidays-us' # https://github.com/elidoran/node-date-holidays-us

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
		@cache =
			fiscalMonthInterval: {}
			fiscalMonthStart: {}
			fiscalMonthEnd: {}
			quarterInterval: {}
			quarterStart: {}
			quarterEnd: {}


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


	_validateMonth: (month) ->
		unless month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
			throw new Error 'Month must be an integer between 1 and 12 (inclusive)'


	getFiscalMonthEnd: (month) ->
		@_validateMonth month
		return @cache.fiscalMonthEnd["#{month}"] if @cache.fiscalMonthEnd["#{month}"]

		# See README.md for an explanation of Disney’s fiscal months, which have set numbers of weeks (mostly)
		@cache.fiscalMonthEnd["#{month}"] = switch month
			when 1 # Month 1, mostly overlapping with October, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 4
			when 2 # Month 2, mostly overlapping with November, is always 5 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 9
			when 3 # Month 3, mostly overlapping with December, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 13
			when 4 # Month 4, mostly overlapping with January, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 17
			when 5 # Month 5, mostly overlapping with February, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 21
			when 6 # Month 6, mostly overlapping with March, is always 5 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 26
			when 7 # Month 7, mostly overlapping with April, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 30
			when 8 # Month 8, mostly overlapping with May, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 34
			when 9 # Month 9, mostly overlapping with June, is always 5 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 39
			when 10 # Month 10, mostly overlapping with July, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 43
			when 11 # Month 11, mostly overlapping with August, is always 4 weeks long
				@getPreviousFiscalYearEnd().plus weeks: 47
			when 12 # Month 12, mostly overlapping with September, is 5 weeks long in a 52-week fiscal year or 6 weeks long in a 53-week fiscal year
				@getFiscalYearEnd()


	getFiscalMonthStart: (month) ->
		@_validateMonth month
		return @cache.fiscalMonthStart["#{month}"] if @cache.fiscalMonthStart["#{month}"]

		@cache.fiscalMonthStart["#{month}"] = switch month
			when 1
				@getFiscalYearStart()
			else
				@getFiscalMonthEnd(month - 1).plus days: 1


	getFiscalMonthInterval: (month) ->
		@_validateMonth month
		return @cache.fiscalMonthInterval["#{month}"] if @cache.fiscalMonthInterval["#{month}"]

		@cache.fiscalMonthInterval["#{month}"] = Interval.fromDateTimes @getFiscalMonthStart(month), @getFiscalMonthEnd(month)


	getFiscalMonths: ->
		[1..12].map (month) => @getFiscalMonthInterval month


	_validateQuarter: (quarter) ->
		unless quarter in [1, 2, 3, 4]
			throw new Error 'Quarter must be an integer: 1 or 2 or 3 or 4'


	getQuarterEnd: (quarter) ->
		@_validateQuarter quarter
		return @cache.quarterEnd["#{quarter}"] if @cache.quarterEnd["#{quarter}"]

		# See README.md for an explanation of Disney’s fiscal months, which have set numbers of weeks (mostly)
		# Quarters are always three of these fiscal months
		switch quarter
			when 1
				@cache.quarterEnd["#{quarter}"] = @getFiscalMonthEnd 3
			when 2
				@cache.quarterEnd["#{quarter}"] = @getFiscalMonthEnd 6
			when 3
				@cache.quarterEnd["#{quarter}"] = @getFiscalMonthEnd 9
			when 4
				@cache.quarterEnd["#{quarter}"] = @getFiscalYearEnd()


	getQuarterStart: (quarter) ->
		@_validateQuarter quarter
		return @cache.quarterStart["#{quarter}"] if @cache.quarterStart["#{quarter}"]

		@cache.quarterStart["#{quarter}"] = switch quarter
			when 1
				@getFiscalYearStart()
			else
				@getQuarterEnd(quarter - 1).plus days: 1


	getQuarterInterval: (quarter) ->
		@_validateQuarter quarter
		return @cache.quarterInterval["#{quarter}"] if @cache.quarterInterval["#{quarter}"]

		@cache.quarterInterval["#{quarter}"] = Interval.fromDateTimes @getQuarterStart(quarter), @getQuarterEnd(quarter)


	getQuarters: ->
		[1..4].map (quarter) => @getQuarterInterval quarter


	getHolidays: ->
		return @cache.holidays if @cache.holidays

		holidays = []
		# https://github.com/elidoran/node-date-holidays-us#api-generators
		for day in ['newYearsDay', 'martinLutherKingDay', 'presidentsDay', 'memorialDay', 'independenceDay', 'laborDay', 'thanksgiving', 'dayAfterThankgsiving', 'christmas']
			if day is 'dayAfterThankgsiving'
				date = holidays[6].plus days: 1
			else
				date = Holidays[day](@fiscalYear)
				date = date.observed if date.observed
				date = DateTime.fromJSDate date
			holidays.push date
		@cache.holidays = holidays
