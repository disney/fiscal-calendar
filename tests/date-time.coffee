test = require 'ava'

{ DateTime } = require '../src/index'


test 'fiscal year', (t) =>
	t.is DateTime.fromISO('1999-12-31').fiscalYear, 2000
	t.is DateTime.fromISO('2000-01-01').fiscalYear, 2000
	t.is DateTime.fromISO('2000-09-30').fiscalYear, 2000
	t.is DateTime.fromISO('2000-10-01').fiscalYear, 2001
	t.is DateTime.fromISO('2015-10-03').fiscalYear, 2015
	t.is DateTime.fromISO('2015-10-04').fiscalYear, 2016
