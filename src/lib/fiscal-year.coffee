import { DateTime, Interval } from 'luxon' # https://moment.github.io/luxon/
import Holidays from '@18f/us-federal-holidays' # https://github.com/18F/us-federal-holidays

import { nearestSaturday } from './fiscal-year-helpers.js'


export class FiscalYear
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
			fiscalQuarterInterval: {}
			fiscalQuarterStart: {}
			fiscalQuarterEnd: {}


	getFiscalYearEnd: ->
		return @cache.fiscalYearEnd if @cache.fiscalYearEnd
		@cache.fiscalYearEnd = nearestSaturday(DateTime.fromObject
			year: @fiscalYear
			month: 9 # September
			day: 30
		).endOf 'day'


	getPreviousFiscalYearEnd: ->
		return @cache.previousFiscalYearEnd if @cache.previousFiscalYearEnd
		@cache.previousFiscalYearEnd = nearestSaturday(DateTime.fromObject
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


	contains: (dateTime) ->
		@getFiscalYearInterval().contains dateTime


	getNumberOfWeeks: ->
		return @cache.numberOfWeeks if @cache.numberOfWeeks
		@cache.numberOfWeeks = Math.round(@getFiscalYearInterval().length('days') / 7)


	_validateMonth: (month) ->
		unless month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
			throw new Error 'Month must be an integer between 1 and 12 (inclusive)'


	getFiscalMonthEnd: (month) ->
		@_validateMonth month
		return @cache.fiscalMonthEnd["#{month}"] if @cache.fiscalMonthEnd["#{month}"]

		# See README.md for an explanation of the fiscal months, which have set numbers of weeks (mostly)
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
				@getFiscalMonthEnd(month - 1).plus milliseconds: 1


	getFiscalMonthInterval: (month) ->
		@_validateMonth month
		return @cache.fiscalMonthInterval["#{month}"] if @cache.fiscalMonthInterval["#{month}"]

		@cache.fiscalMonthInterval["#{month}"] = Interval.fromDateTimes @getFiscalMonthStart(month), @getFiscalMonthEnd(month)


	getFiscalMonths: ->
		[1..12].map (month) => @getFiscalMonthInterval month


	_validateQuarter: (quarter) ->
		unless quarter in [1, 2, 3, 4]
			throw new Error 'Quarter must be an integer: 1 or 2 or 3 or 4'


	getFiscalQuarterEnd: (quarter) ->
		@_validateQuarter quarter
		return @cache.fiscalQuarterEnd["#{quarter}"] if @cache.fiscalQuarterEnd["#{quarter}"]

		# See README.md for an explanation of the fiscal months, which have set numbers of weeks (mostly)
		# Quarters are always three of these fiscal months
		# Fiscal quarters differ from Luxon’s quarters, which follow calendar months
		switch quarter
			when 1
				@cache.fiscalQuarterEnd["#{quarter}"] = @getFiscalMonthEnd 3
			when 2
				@cache.fiscalQuarterEnd["#{quarter}"] = @getFiscalMonthEnd 6
			when 3
				@cache.fiscalQuarterEnd["#{quarter}"] = @getFiscalMonthEnd 9
			when 4
				@cache.fiscalQuarterEnd["#{quarter}"] = @getFiscalYearEnd()


	getFiscalQuarterStart: (quarter) ->
		@_validateQuarter quarter
		return @cache.fiscalQuarterStart["#{quarter}"] if @cache.fiscalQuarterStart["#{quarter}"]

		@cache.fiscalQuarterStart["#{quarter}"] = switch quarter
			when 1
				@getFiscalYearStart()
			else
				@getFiscalQuarterEnd(quarter - 1).plus milliseconds: 1


	getFiscalQuarterInterval: (quarter) ->
		@_validateQuarter quarter
		return @cache.fiscalQuarterInterval["#{quarter}"] if @cache.fiscalQuarterInterval["#{quarter}"]

		@cache.fiscalQuarterInterval["#{quarter}"] = Interval.fromDateTimes @getFiscalQuarterStart(quarter), @getFiscalQuarterEnd(quarter)


	getFiscalQuarters: ->
		[1..4].map (quarter) => @getFiscalQuarterInterval quarter


	getHolidays: ->
		return @cache.holidays if @cache.holidays

		# Company core holidays per HR
		companySupportedUSHolidays = new Set([
			'New Year\'s Day'
			'Birthday of Martin Luther King, Jr.'
			'Washington\'s Birthday'
			'Memorial Day'
			'Juneteenth National Independence Day'
			'Independence Day'
			'Labor Day'
			'Thanksgiving Day'
			# Day after Thanksgiving handled below
			'Christmas Day'
		])

		start = @getFiscalYearStart().toJSDate()
		end = @getFiscalYearEnd().toJSDate()
		usHolidays = Holidays.inRange(start, end, { shiftSaturdayHolidays: yes, shiftSundayHolidays: yes })

		holidays = []
		# https://github.com/18F/us-federal-holidays#readme
		for { name, date } in usHolidays
			holiday = DateTime.fromJSDate date
			holidays.push holiday if companySupportedUSHolidays.has name
			if name is 'Thanksgiving Day'
				holidays.push holiday.plus days: 1

		@cache.holidays = holidays
