test = require 'ava'
{ DateTime } = require 'luxon' # https://moment.github.io/luxon/index.html

do ->
	{ nearestSaturday, normalizeUnit } = await import('../dist/lib/fiscal-year-helpers.js')


	test 'nearest Saturday', (t) =>
		# 2000-01-01 and 2000-01-08 were Saturdays
		t.is nearestSaturday(DateTime.fromISO('2000-01-01')).toISODate(), '2000-01-01'
		t.is nearestSaturday(DateTime.fromISO('2000-01-02')).toISODate(), '2000-01-01'
		t.is nearestSaturday(DateTime.fromISO('2000-01-03')).toISODate(), '2000-01-01'
		t.is nearestSaturday(DateTime.fromISO('2000-01-04')).toISODate(), '2000-01-01'
		t.is nearestSaturday(DateTime.fromISO('2000-01-05')).toISODate(), '2000-01-08'
		t.is nearestSaturday(DateTime.fromISO('2000-01-06')).toISODate(), '2000-01-08'
		t.is nearestSaturday(DateTime.fromISO('2000-01-07')).toISODate(), '2000-01-08'


	test 'normalized unit', (t) =>
		t.is normalizeUnit('Fiscal Year'), 'fiscal years'
		t.is normalizeUnit('Fiscal Years'), 'fiscal years'
		t.is normalizeUnit('Fiscal Quarter'), 'fiscal quarters'
		t.is normalizeUnit('Fiscal Month'), 'fiscal months'
		t.throws -> normalizeUnit 'nonexistent unit'
