{ DateTime } = require 'luxon' # https://moment.github.io/luxon/

FiscalYear = require './fiscal-year'


# Cache fiscal years so that we don’t repeat calculations
fiscalYearsCache = {}
getFiscalYear = (year) ->
	year = "#{year}"
	return fiscalYearsCache[year] if fiscalYearsCache[year]
	fiscalYearsCache[year] = new FiscalYear year


# For a particular DateTime, what fiscal year is it in?
Object.defineProperty DateTime.prototype, 'fiscalYear',
	get: ->
		return @c.fiscalYear if @c.fiscalYear
		@c.fiscalYear = if getFiscalYear(@year).contains @ then @year else @year + 1


# Provide full access to the methods available for this DateTime’s fiscal year
DateTime.prototype.getFiscalYearClass = ->
	getFiscalYear @fiscalYear


# For a particular DateTime, what fiscal quarter is it in?
Object.defineProperty DateTime.prototype, 'fiscalQuarter',
	get: ->
		return @c.fiscalQuarter if @c.fiscalQuarter
		fiscalYear = @getFiscalYearClass()
		for quarter in [1..4]
			if fiscalYear.getFiscalQuarterInterval(quarter).contains(@)
				return @c.fiscalQuarter = quarter


module.exports = DateTime
