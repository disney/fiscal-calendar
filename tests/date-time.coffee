test = require 'ava'

{ DateTime } = require '../src/index'


test 'fiscal year', (t) =>
	t.is DateTime.fromISO('1999-12-31').fiscalYear, 2000
	t.is DateTime.fromISO('2000-01-01').fiscalYear, 2000
	t.is DateTime.fromISO('2000-09-30').fiscalYear, 2000
	t.is DateTime.fromISO('2000-10-01').fiscalYear, 2001
	t.is DateTime.fromISO('2015-10-03').fiscalYear, 2015
	t.is DateTime.fromISO('2015-10-04').fiscalYear, 2016


test 'fiscal year class', (t) =>
	t.is DateTime.local().getFiscalYearClass().constructor.name, 'FiscalYear'


test 'fiscal quarter', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalQuarter, 1
	t.is DateTime.fromISO('2000-12-30').fiscalQuarter, 1
	t.is DateTime.fromISO('2000-12-31').fiscalQuarter, 2
	t.is DateTime.fromISO('2001-01-01').fiscalQuarter, 2
	t.is DateTime.fromISO('2001-03-31').fiscalQuarter, 2
	t.is DateTime.fromISO('2001-04-01').fiscalQuarter, 3
	t.is DateTime.fromISO('2004-06-01').fiscalQuarter, 3
	t.is DateTime.fromISO('2004-06-27').fiscalQuarter, 4
	t.is DateTime.fromISO('2004-10-02').fiscalQuarter, 4
	t.is DateTime.fromISO('2004-10-03').fiscalQuarter, 1


test 'fiscal month', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalMonth, 1
	t.is DateTime.fromISO('2000-12-30').fiscalMonth, 3
	t.is DateTime.fromISO('2000-12-31').fiscalMonth, 4
	t.is DateTime.fromISO('2001-01-01').fiscalMonth, 4
	t.is DateTime.fromISO('2001-03-31').fiscalMonth, 6
	t.is DateTime.fromISO('2001-04-01').fiscalMonth, 7
	t.is DateTime.fromISO('2004-06-01').fiscalMonth, 9
	t.is DateTime.fromISO('2004-06-27').fiscalMonth, 10
	t.is DateTime.fromISO('2004-10-02').fiscalMonth, 12
	t.is DateTime.fromISO('2004-10-03').fiscalMonth, 1


test 'start of', (t) =>
	# First check that the out-of-the-box `startOf` units still work
	t.is DateTime.fromISO('2000-01-03').startOf('month').toISODate(), '2000-01-01'
	t.is DateTime.fromISO('2000-01-03').startOf('quarter').toISODate(), '2000-01-01'
	t.is DateTime.fromISO('2000-01-03').startOf('year').toISODate(), '2000-01-01'

	t.is DateTime.fromISO('2000-01-03').startOf('fiscal year').toISODate(), '1999-10-03'
	t.is DateTime.fromISO('2004-10-02').startOf('fiscal year').toISODate(), '2003-09-28'
	t.is DateTime.fromISO('2001-05-09').startOf('fiscal quarter').toISODate(), '2001-04-01'
	t.is DateTime.fromISO('2004-01-01').startOf('fiscal quarter').toISODate(), '2003-12-28'
	t.is DateTime.fromISO('2004-10-02').startOf('fiscal quarter').toISODate(), '2004-06-27'
	t.is DateTime.fromISO('2004-10-03').startOf('fiscal quarter').toISODate(), '2004-10-03'
	t.is DateTime.fromISO('2000-10-01').startOf('fiscal month').toISODate(), '2000-10-01'
	t.is DateTime.fromISO('2000-10-02').startOf('fiscal month').toISODate(), '2000-10-01'
	t.is DateTime.fromISO('2000-10-30').startOf('fiscal month').toISODate(), '2000-10-29'
	t.is DateTime.fromISO('2001-01-15').startOf('fiscal month').toISODate(), '2000-12-31'
	t.is DateTime.fromISO('2004-06-01').startOf('fiscal month').toISODate(), '2004-05-23'
	t.is DateTime.fromISO('2004-10-01').startOf('fiscal month').toISODate(), '2004-08-22'
	t.is DateTime.fromISO('2004-10-02').startOf('fiscal month').toISODate(), '2004-08-22'
	t.is DateTime.fromISO('2004-10-03').startOf('fiscal month').toISODate(), '2004-10-03'



test 'end of', (t) =>
	# First check that the out-of-the-box `endOf` units still work
	t.is DateTime.fromISO('2000-02-03').endOf('month').toISODate(), '2000-02-29'
	t.is DateTime.fromISO('1900-02-03').endOf('month').toISODate(), '1900-02-28'
	t.is DateTime.fromISO('2000-01-03').endOf('quarter').toISODate(), '2000-03-31'
	t.is DateTime.fromISO('2000-01-03').endOf('year').toISODate(), '2000-12-31'

	t.is DateTime.fromISO('2000-01-03').endOf('fiscal year').toISODate(), '2000-09-30'
	t.is DateTime.fromISO('2004-10-02').endOf('fiscal year').toISODate(), '2004-10-02'
	t.is DateTime.fromISO('2001-05-09').endOf('fiscal quarter').toISODate(), '2001-06-30'
	t.is DateTime.fromISO('2004-04-01').endOf('fiscal quarter').toISODate(), '2004-06-26'
	t.is DateTime.fromISO('2004-10-01').endOf('fiscal quarter').toISODate(), '2004-10-02'
	t.is DateTime.fromISO('2004-10-02').endOf('fiscal quarter').toISODate(), '2004-10-02'
	t.is DateTime.fromISO('2000-10-01').endOf('fiscal month').toISODate(), '2000-10-28'
	t.is DateTime.fromISO('2000-10-28').endOf('fiscal month').toISODate(), '2000-10-28'
	t.is DateTime.fromISO('2000-10-29').endOf('fiscal month').toISODate(), '2000-12-02'
	t.is DateTime.fromISO('2001-01-15').endOf('fiscal month').toISODate(), '2001-01-27'
	t.is DateTime.fromISO('2004-06-01').endOf('fiscal month').toISODate(), '2004-06-26'
	t.is DateTime.fromISO('2004-10-01').endOf('fiscal month').toISODate(), '2004-10-02'
	t.is DateTime.fromISO('2004-10-02').endOf('fiscal month').toISODate(), '2004-10-02'
	t.is DateTime.fromISO('2004-10-03').endOf('fiscal month').toISODate(), '2004-10-30'
