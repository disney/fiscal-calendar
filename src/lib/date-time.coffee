{ DateTime } = require 'luxon' # https://moment.github.io/luxon/

FiscalYear = require './fiscal-year'


# Cache fiscal years so that we don’t repeat calculations
fiscalYearsCache = {}
getFiscalYear = (year) ->
	year = "#{year}"
	return fiscalYearsCache[year] if fiscalYearsCache[year]
	fiscalYearsCache[year] = new FiscalYear year


# Cache getter values so that we don’t repeat calculations
DateTime.prototype.fiscalDataCache = {}


# For a particular DateTime, what fiscal year is it in?
Object.defineProperty DateTime.prototype, 'fiscalYear',
	get: ->
		return @fiscalDataCache.fiscalYear if @fiscalDataCache.fiscalYear
		if getFiscalYear(@year).contains @ then @year else @year + 1


module.exports = DateTime
