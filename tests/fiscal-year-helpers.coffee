test = require 'ava'
{ DateTime } = require 'luxon' # https://moment.github.io/luxon/index.html

FiscalYearHelpers = require '../src/lib/fiscal-year-helpers'


test 'nearest Saturday', (t) =>
	# 2000-01-01 and 2000-01-08 were Saturdays
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-01')).toISODate(), '2000-01-01'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-02')).toISODate(), '2000-01-01'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-03')).toISODate(), '2000-01-01'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-04')).toISODate(), '2000-01-01'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-05')).toISODate(), '2000-01-08'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-06')).toISODate(), '2000-01-08'
	t.is FiscalYearHelpers.nearestSaturday(DateTime.fromISO('2000-01-07')).toISODate(), '2000-01-08'


test 'normalized unit', (t) =>
	t.is FiscalYearHelpers.normalizeUnit('Fiscal Year'), 'fiscal years'
	t.is FiscalYearHelpers.normalizeUnit('Fiscal Years'), 'fiscal years'
	t.is FiscalYearHelpers.normalizeUnit('Fiscal Quarter'), 'fiscal quarters'
	t.is FiscalYearHelpers.normalizeUnit('Fiscal Month'), 'fiscal months'
	t.throws -> FiscalYearHelpers.normalizeUnit 'nonexistent unit'
