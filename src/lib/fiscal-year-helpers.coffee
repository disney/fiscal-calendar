{ DateTime } = require 'luxon' # https://moment.github.io/luxon/index.html


# Static methods to help in creating FiscalYear objects
module.exports = class FiscalYearHelpers
	@nearestSaturday: (date) ->
		# date is a Luxon DateTime object
		switch date.weekday # 1-indexed, where 1 = Monday and 7 = Sunday
			when 1 then return date.minus days: 2 # Monday
			when 2 then return date.minus days: 3 # Tuesday
			when 3 then return date.plus days: 3 # Wednesday
			when 4 then return date.plus days: 2 # Thursday
			when 5 then return date.plus days: 1 # Friday
			when 6 then return date.set() # Set nothing, to return copy of date (already Saturday)
			when 7 then return date.minus days: 1 # Sunday
