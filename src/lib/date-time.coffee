{ DateTime } = require 'luxon' # https://moment.github.io/luxon/

FiscalYear = require './fiscal-year'
{ normalizeUnit } = require './fiscal-year-helpers'


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


# For a particular DateTime, what fiscal month is it in?
Object.defineProperty DateTime.prototype, 'fiscalMonth',
	get: ->
		return @c.fiscalMonth if @c.fiscalMonth
		fiscalYear = @getFiscalYearClass()
		for month in [1..12]
			if fiscalYear.getFiscalMonthInterval(month).contains(@)
				return @c.fiscalMonth = month


# Extend `startOf` and `endOf` to include fiscal years, quarters and months
originalStartOf = DateTime.prototype.startOf
# Based on https://github.com/moment/luxon/blob/af1c6865ee87156261f31fd488eccb70343c7234/src/datetime.js#L1313-L1354
DateTime.prototype.startOf = (unit) ->
	return @ unless @isValid
	switch normalizeUnit unit
		when 'fiscal years'
			return getFiscalYear(@fiscalYear).getFiscalYearStart()
		when 'fiscal quarters'
			return getFiscalYear(@fiscalYear).getFiscalQuarterStart(@fiscalQuarter)
		when 'fiscal months'
			return getFiscalYear(@fiscalYear).getFiscalMonthStart(@fiscalMonth)
		else
			originalStartOf.call @, unit


originalEndOf = DateTime.prototype.endOf
DateTime.prototype.endOf = (unit) ->
	return @ unless @isValid
	switch normalizeUnit unit
		when 'fiscal years'
			return getFiscalYear(@fiscalYear).getFiscalYearEnd()
		when 'fiscal quarters'
			return getFiscalYear(@fiscalYear).getFiscalQuarterEnd(@fiscalQuarter)
		when 'fiscal months'
			return getFiscalYear(@fiscalYear).getFiscalMonthEnd(@fiscalMonth)
		else
			originalEndOf.call @, unit


module.exports = DateTime
