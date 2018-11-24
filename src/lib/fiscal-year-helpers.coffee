{ DateTime, Duration } = require 'luxon' # https://moment.github.io/luxon/index.html


# Static methods to help in creating FiscalYear objects
module.exports = class FiscalYearHelpers
	@nearestSaturday: (dateTime) ->
		# `dateTime` is a Luxon DateTime object
		switch dateTime.weekday # 1-indexed, where 1 = Monday and 7 = Sunday
			when 1 then return dateTime.minus days: 2 # Monday
			when 2 then return dateTime.minus days: 3 # Tuesday
			when 3 then return dateTime.plus days: 3 # Wednesday
			when 4 then return dateTime.plus days: 2 # Thursday
			when 5 then return dateTime.plus days: 1 # Friday
			when 6 then return dateTime.set() # Set nothing, to return copy of date (already Saturday)
			when 7 then return dateTime.minus days: 1 # Sunday


	# Based on https://github.com/moment/luxon/blob/af1c6865ee87156261f31fd488eccb70343c7234/src/datetime.js#L1313-L1354
	@normalizeUnit: (unit, ignoreUnknown = no) ->
		normalized = {
			fiscalyear: 'fiscal years'
			'fiscal year': 'fiscal years'
			fiscalyears: 'fiscal years'
			'fiscal years': 'fiscal years'
			fyear: 'fiscal years'
			fyears: 'fiscal years'
			fy: 'fiscal years'
			fiscalquarter: 'fiscal quarters'
			'fiscal quarter': 'fiscal quarters'
			fiscalquarters: 'fiscal quarters'
			'fiscal quarters': 'fiscal quarters'
			fiscalmonth: 'fiscal months'
			'fiscal month': 'fiscal months'
			fiscalmonths: 'fiscal months'
			'fiscal months': 'fiscal months'
		}[if unit then unit.toLowerCase() else unit]

		if normalized
			return normalized
		else
			return Duration.normalizeUnit unit, ignoreUnknown
