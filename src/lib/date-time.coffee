import { DateTime, Info } from 'luxon' # https://moment.github.io/luxon/


import { FiscalYear } from './fiscal-year.js'
import { normalizeUnit } from './fiscal-year-helpers.js'


#
# Helper functions
#

# Cache fiscal years so that we don’t repeat calculations
fiscalYearsCache = {}
getFiscalYear = (year) ->
	year = "#{year}"
	return fiscalYearsCache[year] if fiscalYearsCache[year]
	fiscalYearsCache[year] = new FiscalYear year


# Provide full access to the methods available for this DateTime’s fiscal year
DateTime.prototype.getFiscalYearClass = ->
	getFiscalYear @fiscalYear


#
# Getters for calculated properties
#

# For a particular DateTime, what fiscal year is it in?
Object.defineProperty DateTime.prototype, 'fiscalYear',
	get: ->
		return @c.fiscalYear if @c.fiscalYear
		@c.fiscalYear = if getFiscalYear(@year).contains @ then @year else @year + 1


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
		for month in [1..12] # 1 mostly overlaps with October, 12 with September
			if fiscalYear.getFiscalMonthInterval(month).contains(@)
				return @c.fiscalMonth = month


#
# Getters for formatted string output
#

# String representation of fiscal year in the format 'FY15'
Object.defineProperty DateTime.prototype, 'fiscalYearShort',
	get: ->
		return @c.fiscalYearShort if @c.fiscalYearShort
		@c.fiscalYearShort = "FY#{"#{@fiscalYear}"[2..3]}"


# String representation of fiscal year in the format 'FY 2015'
Object.defineProperty DateTime.prototype, 'fiscalYearLong',
	get: ->
		return @c.fiscalYearLong if @c.fiscalYearLong
		@c.fiscalYearLong = "FY #{@fiscalYear}"


# String representation of fiscal quarter like 'Q3'
Object.defineProperty DateTime.prototype, 'fiscalQuarterString',
	get: ->
		return @c.fiscalQuarterString if @c.fiscalQuarterString
		@c.fiscalQuarterString = "Q#{@fiscalQuarter}"


# String representation of fiscal year and quarter like 'FY15Q3'
Object.defineProperty DateTime.prototype, 'fiscalYearQuarterShort',
	get: ->
		return @c.fiscalYearQuarterShort if @c.fiscalYearQuarterShort
		@c.fiscalYearQuarterShort = "#{@fiscalYearShort}#{@fiscalQuarterString}"


# String representation of fiscal year and quarter like 'FY 2015-Q3'
Object.defineProperty DateTime.prototype, 'fiscalYearQuarterLong',
	get: ->
		return @c.fiscalYearQuarterLong if @c.fiscalYearQuarterLong
		@c.fiscalYearQuarterLong = "#{@fiscalYearLong}-#{@fiscalQuarterString}"


# String representation of fiscal month like '03'
Object.defineProperty DateTime.prototype, 'fiscalMonthNumericPadded',
	get: ->
		return @c.fiscalMonthNumericPadded if @c.fiscalMonthNumericPadded
		@c.fiscalMonthNumericPadded = "#{@fiscalMonth}".padStart 2, '0'


# String representation of the calendar month most aligned with this fiscal month, like 'Aug'
Object.defineProperty DateTime.prototype, 'fiscalMonthNameShort',
	get: ->
		return @c.fiscalMonthNameShort if @c.fiscalMonthNameShort
		@c.fiscalMonthNameShort = Info.months('short')[if @fiscalMonth <= 3 then @fiscalMonth + 8 else @fiscalMonth - 4]


# String representation of the calendar month most aligned with this fiscal month, like 'August'
Object.defineProperty DateTime.prototype, 'fiscalMonthNameLong',
	get: ->
		return @c.fiscalMonthNameLong if @c.fiscalMonthNameLong
		@c.fiscalMonthNameLong = Info.months('long')[if @fiscalMonth <= 3 then @fiscalMonth + 8 else @fiscalMonth - 4]


# String representation of fiscal year and month like 'FY15-10'
Object.defineProperty DateTime.prototype, 'fiscalYearMonthNumericShort',
	get: ->
		return @c.fiscalYearMonthNumericShort if @c.fiscalYearMonthNumericShort
		@c.fiscalYearMonthNumericShort = "#{@fiscalYearShort}-#{@fiscalMonthNumericPadded}"


# String representation of fiscal year and month like 'FY 2015-10'
Object.defineProperty DateTime.prototype, 'fiscalYearMonthNumericLong',
	get: ->
		return @c.fiscalYearMonthNumericLong if @c.fiscalYearMonthNumericLong
		@c.fiscalYearMonthNumericLong = "#{@fiscalYearLong}-#{@fiscalMonthNumericPadded}"


# String representation of fiscal year and month like 'FY15-Oct'
Object.defineProperty DateTime.prototype, 'fiscalYearMonthNameShort',
	get: ->
		return @c.fiscalYearMonthNameShort if @c.fiscalYearMonthNameShort
		@c.fiscalYearMonthNameShort = "#{@fiscalYearShort}-#{@fiscalMonthNameShort}"


# String representation of fiscal year and month like 'FY 2015-Oct'
Object.defineProperty DateTime.prototype, 'fiscalYearMonthNameLong',
	get: ->
		return @c.fiscalYearMonthNameLong if @c.fiscalYearMonthNameLong
		@c.fiscalYearMonthNameLong = "#{@fiscalYearLong}-#{@fiscalMonthNameLong}"


#
# Extended DateTime methods
#

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


export { DateTime }
