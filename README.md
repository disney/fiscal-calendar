# Fiscal Calendar

This is a Node module for working with dates and intervals related to the Disney fiscal calendar. It extends the JavaScript date library [Luxon](https://moment.github.io/luxon/).

## Quickstart

Install the package from npm:

```bash
npm install https://github.com/disney/fiscal-calendar
```

The `DateTime` class exported by this package is a Luxon [DateTime](https://moment.github.io/luxon/docs/class/src/datetime.js~DateTime.html) with a few extensions for fiscal years, quarters and months:

```js
import { DateTime } from 'disney-fiscal-calendar'

const dt = DateTime.fromISO('2001-01-01')

dt.fiscalYear // 2001
dt.fiscalQuarter // 2
dt.fiscalMonth // 4

dt.fiscalYearShort // 'FY01'
dt.fiscalYearLong // 'FY 2001'
dt.fiscalQuarterString // 'Q2'
dt.fiscalYearQuarterShort // 'FY01Q2'
dt.fiscalYearQuarterLong // 'FY 2001-Q2'
dt.fiscalMonthNumericPadded // '04'
dt.fiscalMonthNameShort // 'Jan'
dt.fiscalMonthNameLong // 'January'
dt.fiscalYearMonthNumericShort // 'FY01-04'
dt.fiscalYearMonthNumericLong // 'FY 2001-04'
dt.fiscalYearMonthNameShort // 'FY01-Jan'
dt.fiscalYearMonthNameLong // 'FY 2001-January'

// .startOf returns a DateTime
dt.startOf('fiscal year').toISODate() // '2000-10-01'
dt.startOf('fiscal quarter').toISODate() // '2000-12-31'
dt.startOf('fiscal month').toISODate() // '2000-12-31'

// .endOf returns a DateTime
dt.endOf('fiscal year').toISODate() // '2001-09-29'
dt.endOf('fiscal quarter').toISODate() // '2001-03-31'
dt.endOf('fiscal month').toISODate() // '2001-01-27'
```

You can also use the `FiscalYear` class to work with the fiscal calendar. The `*Interval` methods return Luxon [Interval](https://moment.github.io/luxon/docs/class/src/interval.js~Interval.html) objects.

```js
import { FiscalYear } from 'disney-fiscal-calendar'

const fy = new FiscalYear(2020)

// *Start/End returns a DateTime
fy.getFiscalYearStart().toISODate() // '2019-09-29'
fy.getFiscalYearEnd().toISODate() // '2020-10-03'
fy.getFiscalQuarterStart(4).toISODate() // '2020-06-28'
fy.getFiscalQuarterEnd(4).toISODate() // '2020-10-03'
fy.getFiscalMonthStart(6).toISODate() // '2020-02-23'
fy.getFiscalMonthEnd(6).toISODate() // '2020-03-28'

// *Interval returns an Interval
fy.getFiscalYearInterval().start.toISODate() // '2019-09-29'
fy.getFiscalYearInterval().end.toISODate() // '2020-10-03'
fy.getFiscalQuarterInterval(4).start.toISODate() // '2020-06-28'
fy.getFiscalQuarterInterval(4).end.toISODate() // '2020-10-03'
fy.getFiscalMonthInterval(6).start.toISODate() // '2020-02-23'
fy.getFiscalMonthInterval(6).end.toISODate() // '2020-03-28'

// getFiscalQuarters and getFiscalMonths return arrays of Intervals
fy.getFiscalQuarters()[3].start.toISODate() // '2020-06-28'
fy.getFiscalMonths()[6].start.toISODate() // '2020-03-29'

fy.getNumberOfWeeks() // 53

// getHolidays returns an array of DateTimes
fy.getHolidays().map(holiday => holiday.toISODate())
// ['2020-01-01', '2020-01-20', '2020-02-17', '2020-05-25', '2020-07-03', '2020-09-07', '2020-11-26', '2020-11-27', '2020-12-25' ]
```

## About Disney’s fiscal calendar

Per The Walt Disney Company’s [2020 annual report to the SEC](https://thewaltdisneycompany.com/app/uploads/2021/01/2020-Annual-Report.pdf):

> The Company’s fiscal year ends on the Saturday closest to September 30 and consists of fifty-two weeks with the exception that approximately every six years, we have a fifty-three week year. When a fifty-three week year occurs, the Company reports the additional week in the fourth quarter. Fiscal 2019 and 2018 were fifty-two week years. Fiscal 2020 is a fifty-three week year, which began on September 29, 2019 and ended on October 3, 2020.

For example, here are relevant dates for Fiscal Year 2020:

- `2019-09-29`: Start Fiscal Year 2020
- `2019-10-26`: End FY 2020 1st Month
- `2019-11-30`: End FY 2020 2nd Month
- `2019-12-28`: End FY 2020 3rd Month and 1st Quarter
- `2020-01-25`: End FY 2020 4th Month
- `2020-02-22`: End FY 2020 5th Month
- `2020-03-28`: End FY 2020 6th Month and 2nd Quarter
- `2020-04-25`: End FY 2020 7th Month
- `2020-05-23`: End FY 2020 8th Month
- `2020-06-27`: End FY 2020 9th Month and 3rd Quarter
- `2020-07-25`: End FY 2020 10th Month
- `2020-08-22`: End FY 2020 11th Month
- `2020-10-03`: End FY 2020 12th Month and 4th Quarter and Year


While fiscal years end on the Saturday closest to September 30, fiscal months have fixed lengths based on a set number of weeks:

- Month 1, mostly overlapping with October, is always 4 weeks long
- Month 2, mostly overlapping with November, is always 5 weeks long
- Month 3, mostly overlapping with December, is always 4 weeks long
- Month 4, mostly overlapping with January, is always 4 weeks long
- Month 5, mostly overlapping with February, is always 4 weeks long
- Month 6, mostly overlapping with March, is always 5 weeks long
- Month 7, mostly overlapping with April, is always 4 weeks long
- Month 8, mostly overlapping with May, is always 4 weeks long
- Month 9, mostly overlapping with June, is always 5 weeks long
- Month 10, mostly overlapping with July, is always 4 weeks long
- Month 11, mostly overlapping with August, is always 4 weeks long
- Month 12, mostly overlapping with September, is 5 weeks long in a 52-week fiscal year or 6 weeks long in a 53-week fiscal year

To determine the number of weeks in a fiscal year, take the number of days in the fiscal year (found by subtracting last year’s fiscal year end date from this year’s fiscal year end date) and divide by 7. For example:

- FY 2004 ended on 2004-10-02 and FY 2003 ended on 2003-09-27, so 2004-10-02 minus 2003-09-27 = 371 days divided by 7 = 53 weeks.
- FY 2005 ended on 2005-10-01 and FY 2004 ended on 2004-10-02, so 2005-10-01 minus 2004-10-02 = 364 days divided by 7 = 52 weeks.

Per HR, the company Core Holidays are:

- New Year’s Day
- Martin Luther King, Jr. Day
- President’s Day
- Memorial Day
- Independence Day
- Labor Day
- Thanksgiving Day
- Day after Thanksgiving
- Christmas Day

Holidays that fall on a weekend are observed on the closest weekday. The dates of these holidays are defined by the U.S. Government, plus the day after Thanksgiving which is always the fourth Friday in November. Note that different business units may celebrate different holidays.

## Contributing

To develop this library, check out this repo and run the following:

```bash
npm ci      # Install dependencies
npm run dev # Run build and unit tests in parallel, in watch mode
```

## Why is this library open source?

You may be wondering why Disney has open-sourced a library that seems to have little utility outside of Disney. We have done so for a few reasons:

- There’s nothing secret about Disney’s fiscal calendar, so why keep it private?
- It’s easier to find by Disney developers, since it appears in public internet search results.
- It’s easier to install, since it’s available via the public npm registry.
- Disney is not the only company with a quirky fiscal calendar. Developers can use this library as a starting point for making similar libraries for other such companies.
