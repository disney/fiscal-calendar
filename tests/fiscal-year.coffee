test = require 'ava'

{ FiscalYear } = require '../src/index'


test 'fiscal year end dates', (t) =>
	# Dates to compare against are per the PDF in docs/
	fiscalYearEndDates =
		'1950': '1950-09-30'
		'1951': '1951-09-29'
		'1952': '1952-09-27'
		'1953': '1953-10-03'
		'1954': '1954-10-02'
		'1955': '1955-10-01'
		'1956': '1956-09-29'
		'1957': '1957-09-28'
		'1958': '1958-09-27'
		'1959': '1959-10-03'
		'1960': '1960-10-01'
		'2000': '2000-09-30'
		'2001': '2001-09-29'
		'2002': '2002-09-28'
		'2003': '2003-09-27'
		'2004': '2004-10-02'
		'2005': '2005-10-01'
		'2006': '2006-09-30'
		'2007': '2007-09-29'
		'2008': '2008-09-27'
		'2009': '2009-10-03'
		'2010': '2010-10-02'
		'2011': '2011-10-01'
		'2012': '2012-09-29'
		'2013': '2013-09-28'
		'2014': '2014-09-27'
		'2015': '2015-10-03'
		'2016': '2016-10-01'
		'2017': '2017-09-30'
		'2018': '2018-09-29'
		'2019': '2019-09-28'
		'2020': '2020-10-03'
		'2021': '2021-10-02'
		'2022': '2022-10-01'
		'2023': '2023-09-30'
		'2024': '2024-09-28'
		'2025': '2025-09-27'
		'2026': '2026-10-03'
		'2027': '2027-10-02'
		'2028': '2028-09-30'
		'2029': '2029-09-29'

	for year, fiscalYearEndDate of fiscalYearEndDates
		t.is fiscalYearEndDate, new FiscalYear(year).getFiscalYearEnd().toISODate()


test 'fiscal year start dates', (t) =>
	fiscalYearStartDates =
		'1951': '1950-10-01'
		'1952': '1951-09-30'
		'1953': '1952-09-28'
		'1954': '1953-10-04'
		'1955': '1954-10-03'
		'1956': '1955-10-02'
		'1957': '1956-09-30'
		'1958': '1957-09-29'
		'1959': '1958-09-28'
		'1960': '1959-10-04'
		'2000': '1999-10-03'
		'2001': '2000-10-01'
		'2002': '2001-09-30'
		'2003': '2002-09-29'
		'2004': '2003-09-28'
		'2005': '2004-10-03'
		'2006': '2005-10-02'
		'2007': '2006-10-01'
		'2008': '2007-09-30'
		'2009': '2008-09-28'
		'2010': '2009-10-04'
		'2011': '2010-10-03'
		'2012': '2011-10-02'
		'2013': '2012-09-30'
		'2014': '2013-09-29'
		'2015': '2014-09-28'
		'2016': '2015-10-04'
		'2017': '2016-10-02'
		'2018': '2017-10-01'
		'2019': '2018-09-30'
		'2020': '2019-09-29'
		'2021': '2020-10-04'
		'2022': '2021-10-03'
		'2023': '2022-10-02'
		'2024': '2023-10-01'
		'2025': '2024-09-29'
		'2026': '2025-09-28'
		'2027': '2026-10-04'
		'2028': '2027-10-03'
		'2029': '2028-10-01'
		'2030': '2029-09-30'

	for year, fiscalYearStartDate of fiscalYearStartDates
		t.is fiscalYearStartDate, new FiscalYear(year).getFiscalYearStart().toISODate()


test 'fiscal year interval', (t) =>
	fy1951 = new FiscalYear 1951
	fy2004 = new FiscalYear 2004
	t.is fy1951.getFiscalYearInterval().start.toISODate(), '1950-10-01'
	t.is fy1951.getFiscalYearInterval().end.toISODate(), '1951-09-29'
	t.is fy2004.getFiscalYearInterval().start.toISODate(), '2003-09-28'
	t.is fy2004.getFiscalYearInterval().end.toISODate(), '2004-10-02'


test 'fiscal year number of weeks', (t) =>
	# Years with 53 weeks between 1950 and 2049, per the PDF in docs/
	yearsWith53Weeks = [1953, 1959, 1964, 1970, 1976, 1981, 1987, 1992, 1998, 2004, 2009, 2015, 2020, 2026, 2032, 2037, 2043, 2048]

	for year in [1950..2049]
		t.is new FiscalYear(year).getNumberOfWeeks(), (if year in yearsWith53Weeks then 53 else 52)


test 'fiscal month end dates', (t) =>
	# Dates to compare against are per the PDF in docs/
	yearMonthEndDates =
		'2001': ['2000-10-28', '2000-12-02', '2000-12-30', '2001-01-27', '2001-02-24', '2001-03-31', '2001-04-28', '2001-05-26', '2001-06-30', '2001-07-28', '2001-08-25', '2001-09-29']
		'2004': ['2003-10-25', '2003-11-29', '2003-12-27', '2004-01-24', '2004-02-21', '2004-03-27', '2004-04-24', '2004-05-22', '2004-06-26', '2004-07-24', '2004-08-21', '2004-10-02']
		'2020': ['2019-10-26', '2019-11-30', '2019-12-28', '2020-01-25', '2020-02-22', '2020-03-28', '2020-04-25', '2020-05-23', '2020-06-27', '2020-07-25', '2020-08-22', '2020-10-03']

	for year, monthEndDates of yearMonthEndDates
		fy = new FiscalYear Number year
		for date, month in monthEndDates
			t.is fy.getFiscalMonthEnd(month + 1).toISODate(), date


test 'fiscal month start dates', (t) =>
	# Dates to compare against are per the PDF in docs/
	yearMonthStartDates =
		'2001': ['2000-10-01', '2000-10-29', '2000-12-03', '2000-12-31', '2001-01-28', '2001-02-25', '2001-04-01', '2001-04-29', '2001-05-27', '2001-07-01', '2001-07-29', '2001-08-26']
		'2004': ['2003-09-28', '2003-10-26', '2003-11-30', '2003-12-28', '2004-01-25', '2004-02-22', '2004-03-28', '2004-04-25', '2004-05-23', '2004-06-27', '2004-07-25', '2004-08-22']
		'2020': ['2019-09-29', '2019-10-27', '2019-12-01', '2019-12-29', '2020-01-26', '2020-02-23', '2020-03-29', '2020-04-26', '2020-05-24', '2020-06-28', '2020-07-26', '2020-08-23']

	for year, monthStartDates of yearMonthStartDates
		fy = new FiscalYear Number year
		for date, month in monthStartDates
			t.is fy.getFiscalMonthStart(month + 1).toISODate(), date


test 'fiscal month interval', (t) =>
	# Dates to compare against are per the PDF in docs/
	fy2001 = new FiscalYear 2001
	fy2015 = new FiscalYear 2015
	t.is fy2001.getFiscalMonthInterval(1).start.toISODate(), '2000-10-01'
	t.is fy2001.getFiscalMonthInterval(1).end.toISODate(), '2000-10-28'
	t.is fy2001.getFiscalMonthInterval(2).start.toISODate(), '2000-10-29'
	t.is fy2001.getFiscalMonthInterval(2).end.toISODate(), '2000-12-02'
	t.is fy2001.getFiscalMonthInterval(3).start.toISODate(), '2000-12-03'
	t.is fy2001.getFiscalMonthInterval(3).end.toISODate(), '2000-12-30'
	t.is fy2001.getFiscalMonthInterval(12).start.toISODate(), '2001-08-26'
	t.is fy2001.getFiscalMonthInterval(12).end.toISODate(), '2001-09-29'
	t.is fy2015.getFiscalMonthInterval(9).start.toISODate(), '2015-05-24'
	t.is fy2015.getFiscalMonthInterval(9).end.toISODate(), '2015-06-27'
	t.is fy2015.getFiscalMonthInterval(12).start.toISODate(), '2015-08-23'
	t.is fy2015.getFiscalMonthInterval(12).end.toISODate(), '2015-10-03'


test 'fiscal months array', (t) =>
	months = new FiscalYear(2001).getFiscalMonths()
	t.is months[0].start.toISODate(), '2000-10-01'
	t.is months[0].end.toISODate(), '2000-10-28'
	t.is months[11].start.toISODate(), '2001-08-26'
	t.is months[11].end.toISODate(), '2001-09-29'


test 'fiscal quarter end dates', (t) =>
	# Dates to compare against are per the PDF in docs/
	yearQuarterEndDates =
		'2001': ['2000-12-30', '2001-03-31', '2001-06-30', '2001-09-29']
		'2004': ['2003-12-27', '2004-03-27', '2004-06-26', '2004-10-02']
		'2020': ['2019-12-28', '2020-03-28', '2020-06-27', '2020-10-03']

	for year, monthEndDates of yearQuarterEndDates
		fy = new FiscalYear Number year
		for date, month in monthEndDates
			t.is fy.getFiscalQuarterEnd(month + 1).toISODate(), date


test 'fiscal quarter start dates', (t) =>
	# Dates to compare against are per the PDF in docs/
	yearQuarterStartDates =
		'2001': ['2000-10-01', '2000-12-31', '2001-04-01', '2001-07-01']
		'2004': ['2003-09-28', '2003-12-28', '2004-03-28', '2004-06-27']
		'2020': ['2019-09-29', '2019-12-29', '2020-03-29', '2020-06-28']

	for year, monthStartDates of yearQuarterStartDates
		fy = new FiscalYear Number year
		for date, month in monthStartDates
			t.is fy.getFiscalQuarterStart(month + 1).toISODate(), date


test 'fiscal quarter interval', (t) =>
	# Dates to compare against are per the PDF in docs/
	fy2004 = new FiscalYear 2004
	fy2033 = new FiscalYear 2033
	t.is fy2004.getFiscalQuarterInterval(1).start.toISODate(), '2003-09-28'
	t.is fy2004.getFiscalQuarterInterval(1).end.toISODate(), '2003-12-27'
	t.is fy2004.getFiscalQuarterInterval(2).start.toISODate(), '2003-12-28'
	t.is fy2004.getFiscalQuarterInterval(2).end.toISODate(), '2004-03-27'
	t.is fy2004.getFiscalQuarterInterval(4).start.toISODate(), '2004-06-27'
	t.is fy2004.getFiscalQuarterInterval(4).end.toISODate(), '2004-10-02'
	t.is fy2033.getFiscalQuarterInterval(3).start.toISODate(), '2033-04-03'
	t.is fy2033.getFiscalQuarterInterval(3).end.toISODate(), '2033-07-02'
	t.is fy2033.getFiscalQuarterInterval(4).start.toISODate(), '2033-07-03'
	t.is fy2033.getFiscalQuarterInterval(4).end.toISODate(), '2033-10-01'


test 'fiscal quarters array', (t) =>
	quarters = new FiscalYear(2004).getFiscalQuarters()
	t.is quarters[0].start.toISODate(), '2003-09-28'
	t.is quarters[0].end.toISODate(), '2003-12-27'
	t.is quarters[1].start.toISODate(), '2003-12-28'
	t.is quarters[1].end.toISODate(), '2004-03-27'
	t.is quarters[3].start.toISODate(), '2004-06-27'
	t.is quarters[3].end.toISODate(), '2004-10-02'


test 'holidays array', (t) =>
	# Per https://disney.service-now.com/dtoolshramericas?id=dhr_search&tags=Holidays
	yearHolidays =
		'2018': ['2018-01-01', '2018-01-15', '2018-02-19', '2018-05-28', '2018-07-04', '2018-09-03', '2018-11-22', '2018-11-23', '2018-12-25']
		'2019': ['2019-01-01', '2019-01-21', '2019-02-18', '2019-05-27', '2019-07-04', '2019-09-02', '2019-11-28', '2019-11-29', '2019-12-25']
		'2020': ['2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-03', '2020-09-07', '2020-11-26', '2020-11-27', '2020-12-25']

	for year, holidays of yearHolidays
		t.deepEqual new FiscalYear(year).getHolidays().map((date) => date.toISODate()), holidays
