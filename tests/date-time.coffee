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
