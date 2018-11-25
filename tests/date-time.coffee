test = require 'ava'

{ DateTime } = require '../src/index'


test 'fiscal year class', (t) =>
	t.is DateTime.local().getFiscalYearClass().constructor.name, 'FiscalYear'


test 'fiscal year', (t) =>
	t.is DateTime.fromISO('1999-12-31').fiscalYear, 2000
	t.is DateTime.fromISO('2000-01-01').fiscalYear, 2000
	t.is DateTime.fromISO('2000-09-30').fiscalYear, 2000
	t.is DateTime.fromISO('2000-10-01').fiscalYear, 2001
	t.is DateTime.fromISO('2015-10-03').fiscalYear, 2015
	t.is DateTime.fromISO('2015-10-04').fiscalYear, 2016


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


test 'fiscal year short string', (t) =>
	t.is DateTime.fromISO('1999-12-31').fiscalYearShort, 'FY00'
	t.is DateTime.fromISO('2000-01-01').fiscalYearShort, 'FY00'
	t.is DateTime.fromISO('2015-10-03').fiscalYearShort, 'FY15'
	t.is DateTime.fromISO('2015-10-04').fiscalYearShort, 'FY16'


test 'fiscal year long string', (t) =>
	t.is DateTime.fromISO('1999-12-31').fiscalYearLong, 'FY 2000'
	t.is DateTime.fromISO('2000-01-01').fiscalYearLong, 'FY 2000'
	t.is DateTime.fromISO('2015-10-03').fiscalYearLong, 'FY 2015'
	t.is DateTime.fromISO('2015-10-04').fiscalYearLong, 'FY 2016'


test 'fiscal quarter string', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalQuarterString, 'Q1'
	t.is DateTime.fromISO('2000-12-30').fiscalQuarterString, 'Q1'
	t.is DateTime.fromISO('2000-12-31').fiscalQuarterString, 'Q2'
	t.is DateTime.fromISO('2004-06-01').fiscalQuarterString, 'Q3'
	t.is DateTime.fromISO('2004-06-27').fiscalQuarterString, 'Q4'
	t.is DateTime.fromISO('2004-10-02').fiscalQuarterString, 'Q4'
	t.is DateTime.fromISO('2004-10-03').fiscalQuarterString, 'Q1'


test 'fiscal year-quarter short string', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalYearQuarterShort, 'FY01Q1'
	t.is DateTime.fromISO('2000-12-30').fiscalYearQuarterShort, 'FY01Q1'
	t.is DateTime.fromISO('2000-12-31').fiscalYearQuarterShort, 'FY01Q2'
	t.is DateTime.fromISO('2004-06-01').fiscalYearQuarterShort, 'FY04Q3'
	t.is DateTime.fromISO('2004-06-27').fiscalYearQuarterShort, 'FY04Q4'
	t.is DateTime.fromISO('2004-10-02').fiscalYearQuarterShort, 'FY04Q4'
	t.is DateTime.fromISO('2004-10-03').fiscalYearQuarterShort, 'FY05Q1'


test 'fiscal year-quarter long string', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalYearQuarterLong, 'FY 2001-Q1'
	t.is DateTime.fromISO('2000-12-30').fiscalYearQuarterLong, 'FY 2001-Q1'
	t.is DateTime.fromISO('2000-12-31').fiscalYearQuarterLong, 'FY 2001-Q2'
	t.is DateTime.fromISO('2004-06-01').fiscalYearQuarterLong, 'FY 2004-Q3'
	t.is DateTime.fromISO('2004-06-27').fiscalYearQuarterLong, 'FY 2004-Q4'
	t.is DateTime.fromISO('2004-10-02').fiscalYearQuarterLong, 'FY 2004-Q4'
	t.is DateTime.fromISO('2004-10-03').fiscalYearQuarterLong, 'FY 2005-Q1'


test 'fiscal month numeric padded', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalMonthNumericPadded, '01'
	t.is DateTime.fromISO('2000-12-30').fiscalMonthNumericPadded, '03'
	t.is DateTime.fromISO('2000-12-31').fiscalMonthNumericPadded, '04'
	t.is DateTime.fromISO('2004-06-01').fiscalMonthNumericPadded, '09'
	t.is DateTime.fromISO('2004-10-02').fiscalMonthNumericPadded, '12'
	t.is DateTime.fromISO('2004-10-03').fiscalMonthNumericPadded, '01'


test 'fiscal month name short', (t) =>
	t.is DateTime.fromISO('2000-10-01', {locale: 'en-US'}).fiscalMonthNameShort, 'Oct'
	t.is DateTime.fromISO('2000-12-30', {locale: 'en-US'}).fiscalMonthNameShort, 'Dec'
	t.is DateTime.fromISO('2000-12-31', {locale: 'en-US'}).fiscalMonthNameShort, 'Jan'
	t.is DateTime.fromISO('2001-01-01', {locale: 'en-US'}).fiscalMonthNameShort, 'Jan'
	t.is DateTime.fromISO('2004-06-01', {locale: 'en-US'}).fiscalMonthNameShort, 'Jun'
	t.is DateTime.fromISO('2004-09-15', {locale: 'en-US'}).fiscalMonthNameShort, 'Sep'
	t.is DateTime.fromISO('2004-10-02', {locale: 'en-US'}).fiscalMonthNameShort, 'Sep'
	t.is DateTime.fromISO('2004-10-03', {locale: 'en-US'}).fiscalMonthNameShort, 'Oct'


test 'fiscal month name long', (t) =>
	t.is DateTime.fromISO('2000-10-01', {locale: 'en-US'}).fiscalMonthNameLong, 'October'
	t.is DateTime.fromISO('2000-12-30', {locale: 'en-US'}).fiscalMonthNameLong, 'December'
	t.is DateTime.fromISO('2000-12-31', {locale: 'en-US'}).fiscalMonthNameLong, 'January'
	t.is DateTime.fromISO('2001-01-01', {locale: 'en-US'}).fiscalMonthNameLong, 'January'
	t.is DateTime.fromISO('2004-06-01', {locale: 'en-US'}).fiscalMonthNameLong, 'June'
	t.is DateTime.fromISO('2004-09-15', {locale: 'en-US'}).fiscalMonthNameLong, 'September'
	t.is DateTime.fromISO('2004-10-02', {locale: 'en-US'}).fiscalMonthNameLong, 'September'
	t.is DateTime.fromISO('2004-10-03', {locale: 'en-US'}).fiscalMonthNameLong, 'October'


test 'fiscal year-month numeric short', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalYearMonthNumericShort, 'FY01-01'
	t.is DateTime.fromISO('2000-12-30').fiscalYearMonthNumericShort, 'FY01-03'
	t.is DateTime.fromISO('2000-12-31').fiscalYearMonthNumericShort, 'FY01-04'
	t.is DateTime.fromISO('2004-06-01').fiscalYearMonthNumericShort, 'FY04-09'
	t.is DateTime.fromISO('2004-10-02').fiscalYearMonthNumericShort, 'FY04-12'
	t.is DateTime.fromISO('2004-10-03').fiscalYearMonthNumericShort, 'FY05-01'


test 'fiscal year-month numeric long', (t) =>
	t.is DateTime.fromISO('2000-10-01').fiscalYearMonthNumericLong, 'FY 2001-01'
	t.is DateTime.fromISO('2000-12-30').fiscalYearMonthNumericLong, 'FY 2001-03'
	t.is DateTime.fromISO('2000-12-31').fiscalYearMonthNumericLong, 'FY 2001-04'
	t.is DateTime.fromISO('2004-06-01').fiscalYearMonthNumericLong, 'FY 2004-09'
	t.is DateTime.fromISO('2004-10-02').fiscalYearMonthNumericLong, 'FY 2004-12'
	t.is DateTime.fromISO('2004-10-03').fiscalYearMonthNumericLong, 'FY 2005-01'


test 'fiscal year-month name short', (t) =>
	t.is DateTime.fromISO('2000-10-01', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY01-Oct'
	t.is DateTime.fromISO('2000-12-30', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY01-Dec'
	t.is DateTime.fromISO('2000-12-31', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY01-Jan'
	t.is DateTime.fromISO('2001-01-01', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY01-Jan'
	t.is DateTime.fromISO('2004-06-01', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY04-Jun'
	t.is DateTime.fromISO('2004-09-15', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY04-Sep'
	t.is DateTime.fromISO('2004-10-02', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY04-Sep'
	t.is DateTime.fromISO('2004-10-03', {locale: 'en-US'}).fiscalYearMonthNameShort, 'FY05-Oct'


test 'fiscal year-month name long', (t) =>
	t.is DateTime.fromISO('2000-10-01', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2001-October'
	t.is DateTime.fromISO('2000-12-30', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2001-December'
	t.is DateTime.fromISO('2000-12-31', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2001-January'
	t.is DateTime.fromISO('2001-01-01', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2001-January'
	t.is DateTime.fromISO('2004-06-01', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2004-June'
	t.is DateTime.fromISO('2004-09-15', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2004-September'
	t.is DateTime.fromISO('2004-10-02', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2004-September'
	t.is DateTime.fromISO('2004-10-03', {locale: 'en-US'}).fiscalYearMonthNameLong, 'FY 2005-October'


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
