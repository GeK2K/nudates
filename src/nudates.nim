##[
=======
nudates
=======
Some useful tools when working with `dates` 
(the prefix `nu` stands for `Nim utils`).

## DateTime vs. Date

In the standard library, dates can be handled with the `DateTime` type 
of the `times <https://nim-lang.org/docs/times.html>`_ module. As its 
name suggests, this type actually allows us to manage dates and times 
at the same time. But sometimes intra-day information (hours, minutes, 
seconds, etc.) is not important to us. Let's give an example. 

`dt1 = dateTime(2025, mDec, 31, 2)` and `dt2 = dateTime(2025, mDec, 31, 4)` 
represent the same date (December 31, 2025) while `dt1 == dt2` is `false`
because the hours are not the same (resp. `2` and `4`). Consequently we 
have defined new comparison operators (`~==`, `!~==`, `<<`, `<<~==`, `>>`, 
`>>~==`) which do the same job as the original comparison operators 
(resp. `==`, `!=`, `<`, `<=`, `>`, `>=`), but which do not take intraday 
information (hours, minutes, seconds, etc.) into account in their processing 
(the reader will find a justification of the notations adopted in the 
respective documentation of these operators).
]##


runnableExamples:
  let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
  let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
  let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

  doAssert:  dt1 == dt1  and  dt1 ~== dt1
  doAssert:  dt1 != dt2  and  dt1 ~== dt2
  doAssert:  dt1  < dt3  and  dt1  << dt3 
  doAssert:  dt3  > dt1  and  dt3  >> dt1


##[
**Notes:**

The user has the possibility to work without the functionalities 
which are made available here. For example by ensuring that all 
intra-day information is systematically created with their default 
values and is never modified; or by setting them to 0 before using 
the default comparison operators of the `times` module. *Personally 
I would not favor any of these choices*.


## MonthMonthday type

Sometimes we deal with special dates which do not vary from 
one year to the next. For example: New Year's Day, January 1st; 
Labour Day, May 1st; Christmas Day, December 25th. 
The `MonthMonthday` type allows special dates to be supported, 
and the operators defined in the previous section are also valid 
here (the year is not taken into account in the calculations).
]##


runnableExamples:
  let dt1 = newMonthMonthday(mMay, 1)  # Labour Day, May 1st
  let dt2 = dateTime(2020, mMay, 1, 3)  # 2020-05-01T:03:00:00
  let dt3 = dateTime(2020, mFeb, 18)  # 2020-02-18T:00:00:00
  let dt4 = dateTime(2011, mOct, 11)  # 2021-10-11T:00:00:00

  doAssert:  dt1 ~== dt2
  doAssert:  dt1  >> dt3
  doAssert:  dt1  << dt4


##[
## Other tools

We encourage the user to browse the documentation to discover 
the few other features that exist. We will only mention here the 
`nthWeekday <#nthWeekday,int,Month,WeekDay,int>`_ `proc`.
]##


# =========================     Imports / Exports     ======================== #

import  std/[options, times]
export  options, times


# ===========================     MonthMonthday     ========================== #

type 
  MonthMonthday* = object of RootObj 
    ##[
    Special dates that do not change from year to year 
    can be represented using this type. For example:
      - New Year's Day, January 1st.
      - Labour Day, May 1st.
      - Christmas Day, December 25th.
    ]##
    month: Month = mJan
    monthday: MonthdayRange = 1.MonthdayRange
    zone: Option[TimeZone] = none(TimeZone)


proc  month*(mmd: MonthMonthday): Month {.inline.} = mmd.month
  ## Returns the `month` of the `mmd` object.

proc  monthday*(mmd: MonthMonthday): MonthdayRange {.inline.} = mmd.monthday
  ## Returns the `monthday` of the `mmd` object.

proc  timeZone*(mmd: MonthMonthday): Option[TimeZone] {.inline.} = mmd.zone
  ## Returns the `time zone` of the `mmd` object.


proc  newMonthMonthday*(month: Month = mJan, monthday: MonthdayRange = 1,
                        zone: Option[TimeZone] = none(TimeZone)): 
                       MonthMonthday =
  ##[
  Returns a new object of type `MonthMonthday <#MonthMonthday>`_.

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:
    ```nim
    (month == mJan and monthday <= 31) or (month == mFeb and monthday <= 29) or 
    (month == mMar and monthday <= 31) or (month == mApr and monthday <= 30) or
    (month == mMay and monthday <= 31) or (month == mJun and monthday <= 30) or
    (month == mJul and monthday <= 31) or (month == mAug and monthday <= 31) or
    (month == mSep and monthday <= 30) or (month == mOct and monthday <= 31) or 
    (month == mNov and monthday <= 30) or (month == mDec and monthday <= 31)
    ```
  ]##
  doAssert:
    (month == mJan and monthday <= 31) or (month == mFeb and monthday <= 29) or 
    (month == mMar and monthday <= 31) or (month == mApr and monthday <= 30) or 
    (month == mMay and monthday <= 31) or (month == mJun and monthday <= 30) or 
    (month == mJul and monthday <= 31) or (month == mAug and monthday <= 31) or 
    (month == mSep and monthday <= 30) or (month == mOct and monthday <= 31) or 
    (month == mNov and monthday <= 30) or (month == mDec and monthday <= 31)
  result = MonthMonthday(month: month, monthday: monthday, zone: zone)


# =========================     Date comparisons     ========================= #

proc  cmpDate*(dt1, dt2: MonthMonthday): int = 
  ##[ 
  Compares `dt1` and `dt2`.

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `dt1.zone.isNone or dt2.zone.isNone or get(dt1.zone) == get(dt2.zone)`
  ]##

  runnableExamples:
    let dt1 = newMonthMonthday(mMay, 15.MonthdayRange)
    let dt2 = newMonthMonthday(mMay, 20.MonthdayRange)
    let dt3 = newMonthMonthday(mOct, 5.MonthdayRange)

    doAssert:  dt1.cmpDate(dt1) ==  0   
    doAssert:  dt1.cmpDate(dt2) == -1
    doAssert:  dt2.cmpDate(dt1) ==  1
    doAssert:  dt2.cmpDate(dt3) == -1
    doAssert:  dt3.cmpDate(dt2) ==  1

  doAssert:  
    dt1.zone.isNone or dt2.zone.isNone or get(dt1.zone) == get(dt2.zone)

  if  dt1.month.ord < dt2.month.ord:  return -1
  elif  dt1.month.ord > dt2.month.ord:  return 1
  # From now on:  dt1.month.ord == dt2.month.ord
  elif dt1.monthday < dt2.monthday:  return  -1
  elif dt1.monthday > dt2.monthday:  return 1
  # From now on:  dt1.monthday == dt2.monthday
  else:  return 0


proc  cmpDate*(dt1, dt2: DateTime): int = 
  ##[
  Compares `dt1` and `dt2` ignoring intraday information 
  (hours, minutes, seconds, etc.).

  **Assertions:**
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_:  
      `dt1.timeZone == dt2.timeZone`
  ]##

  runnableExamples:
    let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
    let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
    let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

    doAssert:  dt1 == dt1  and  dt1.cmpDate(dt1) ==  0
    doAssert:  dt1 != dt2  and  dt1.cmpDate(dt2) ==  0
    doAssert:  dt1  < dt3  and  dt1.cmpDate(dt3) == -1
    doAssert:  dt3  > dt1  and  dt3.cmpDate(dt1) ==  1

  doAssert: dt1.timeZone == dt2.timeZone

  if (dt1.year, dt1.month.ord, dt1.monthday) == 
       (dt2.year, dt2.month.ord, dt2.monthday):  return 0
  elif  dt1 < dt2:  return -1
  else:  return 1


proc  cmpDate*(dt1: DateTime, dt2: MonthMonthday): int {.inline.} = 
  ##[ 
  Compares `dt1` and `dt2` ignoring `dt1.year` and intraday
  information of `dt1` (hours, minutes, seconds, etc.).

  **Implementation:**
    ```nim
    newMonthMonthday(dt1.month, dt1.monthday, some(dt1.timeZone)).cmpDate(dt2)
    ```

  **See also:**
    - `cmpDate <#cmpDate,MonthMonthday,MonthMonthday>`_
  ]##
  newMonthMonthday(dt1.month, dt1.monthday, some(dt1.timeZone)).cmpDate(dt2)


template  cmpDate*(dt1: MonthMonthday, dt2: DateTime): untyped =
  ##[ 
  A shorcut for `-cmpDate(dt2, dt1)`.

  **See also:**
    - `cmpDate <#cmpDate,DateTime,MonthMonthday>`_
  ]##
  -cmpDate(dt2, dt1)


proc  cmpDateNoZero*(dt1: DateTime | MonthMonthday, 
                     dt2: DateTime | MonthMonthday): int = 
  ##[
  **Returns:**
    - `-1` if `dt1.cmpDate(dt2) == -1`
    - `1` else

  **Notes:**
    - By definition this `proc` can only take the values 1 or -1, 
      but never the value 0 as the `cmpDate` `proc` does. 
    - This `proc` can help differentiate sequences of increasing 
      dates from sequences of strictly increasing dates.

  **Assertions:**
  ```nim
  when dt1 is DateTime and dt2 is DateTime:
    doAssert:  
      dt1.timeZone == dt2.timeZone
  elif dt1 is DateTime and dt2 is MonthMonthday:
    doAssert:
      dt2.timeZone.isNone or dt1.timeZone == get(dt2.timeZone)
  elif dt2 is DateTime and dt1 is MonthMonthday:
    doAssert:
      dt1.timeZone.isNone or dt2.timeZone == get(dt1.timeZone)
  else:  # dt1 is MonthMonthday and dt2 is MonthMonthday
    doAssert:
      dt1.zone.isNone or dt2.zone.isNone or get(dt1.zone) == get(dt2.zone)  
  ```

  **See also:**
    - `cmpDate <#cmpDate,DateTime,DateTime>`_
    - `doAssert <https://nim-lang.org/docs/assertions.html#doAssert.t%2Cuntyped%2Cstring>`_
  ]##

  runnableExamples:
    let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
    let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
    let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

    doAssert:  dt1 == dt1  and  dt1.cmpDate(dt1) ==  0  and  dt1.cmpDateNoZero(dt1) ==  1
    doAssert:  dt1 != dt2  and  dt1.cmpDate(dt2) ==  0  and  dt1.cmpDateNoZero(dt2) ==  1
    doAssert:  dt1  < dt3  and  dt1.cmpDate(dt3) == -1  and  dt1.cmpDateNoZero(dt3) == -1
    doAssert:  dt3  > dt1  and  dt3.cmpDate(dt1) ==  1  and  dt3.cmpDateNoZero(dt1) ==  1


    import algorithm
    doAssert:  [dt2].isSorted(cmpDate)  # single element
    doAssert:  [dt2].isSorted(cmpDateNoZero)  # single element
    doAssert:  [dt2, dt2].isSorted(cmpDate)  # duplicates
    doassert:  not [dt2, dt2].isSorted(cmpDateNoZero)  # duplicates
    doAssert:  [dt2, dt3].isSorted(cmpDate)  # strictly ascending array
    doAssert:  [dt2, dt3].isSorted(cmpDateNoZero)  # strictly ascending array
    # [dt1, dt2, dt3] is an ascending array but not strictly ascending
    # since dt1.cmpDate(dt2) == 0
    doAssert:  [dt1, dt2, dt3].isSorted(cmpDate)
    doAssert:  not [dt1, dt2, dt3].isSorted(cmpDateNoZero)

  when dt1 is DateTime and dt2 is DateTime:
    doAssert:  
      dt1.timeZone == dt2.timeZone
  elif dt1 is DateTime and dt2 is MonthMonthday:
    doAssert:
      dt2.timeZone.isNone or dt1.timeZone == get(dt2.timeZone)
  elif dt2 is DateTime and dt1 is MonthMonthday:
    doAssert:
      dt1.timeZone.isNone or dt2.timeZone == get(dt1.timeZone)
  else:  # dt1 is MonthMonthday and dt2 is MonthMonthday
    doAssert:
      dt1.zone.isNone or dt2.zone.isNone or get(dt1.zone) == get(dt2.zone)

  result = if dt1.cmpDate(dt2) == -1: -1 else: 1


template  `~==`*(dt1: DateTime | MonthMonthday, 
                 dt2: DateTime | MonthMonthday): untyped = 
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) == 0`, 
  meaning `dt1` is `equal to` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the 
      relationship `dt1` is `equal to` `dt2`.
        - `dt1.cmpDate(dt2) == 0`
        - `dt1 ~== dt2`
    - Intra-day information (hours, minutes, seconds, etc.) are not taken
      into account. The equality mentioned here is therefore less demanding
      than that of the `DateTime` type (`dt1 == dt2` implies `dt1 ~== dt2` 
      but the opposite is not true). We can speak of quasi-equality, hence 
      the notation chosen: `~==` rather than `==`.
  ]##
  dt1.cmpDate(dt2) == 0


template  `!~==`*(dt1: DateTime | MonthMonthday, 
                  dt2: DateTime | MonthMonthday): untyped = 
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) != 0`, 
  meaning `dt1` is `not equal to` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the
      relationship `dt1` is `not equal to` `dt2`.
        - `dt1.cmpDate(dt2) != 0`
        - `dt1 !~== dt2`
    - The`!~==` operator is the negation of the 
      `~==` operator, hence the notation adopted.

  **See also:**
    - `~==` template
  ]##
  dt1.cmpDate(dt2) != 0


template  `<<`*(dt1: DateTime | MonthMonthday, 
              dt2: DateTime | MonthMonthday): untyped =
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) == -1`,
  meaning `dt1` is `less than` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the 
      relationship `dt1` is `less than` `dt2`.
        - `dt1.cmpDate(dt2) == -1`
        - `dt1 << dt2`
    - Intra-day information (hours, minutes, seconds, etc.) are not taken 
      into account. The inequality mentioned here is therefore more demanding 
      than that of the `DateTime` type (`dt1 << dt2` implies `dt1 < dt2` but 
      the opposite is not true). Hence the notation chosen: `<<` rather than `<`.
  ]##
  dt1.cmpDate(dt2) == -1


template  `>>`*(dt1: DateTime | MonthMonthday, 
                dt2: DateTime | MonthMonthday): untyped =
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) == 1`,
  meaning `dt1` is `greater than` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the
      relationship `dt1` is `greater than` `dt2`.
        - `dt1.cmpDate(dt2) == 1`
        - `dt1.gt(dt2)`
    - Intra-day information (hours, minutes, seconds, etc.) are not taken 
      into account. The inequality mentioned here is therefore more demanding 
      than that of the `DateTime` type (`dt1 >> dt2` implies `dt1 > dt2` but 
      the opposite is not true). Hence the notation chosen: `>>` rather than `>`.
  ]##
  dt1.cmpDate(dt2) == 1


template  `<<~==`*(dt1: DateTime | MonthMonthday, 
               dt2: DateTime | MonthMonthday): untyped =
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) <= 0`,
  meaning `dt1` is `less than or equal to` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the 
      relationship `dt1` is `less than or equal to` `dt2`.
        - `dt1.cmpDate(dt2) <= 0`
        - `dt1 <<~== dt2`
    - The operator `<<~==` is the combination of the operators 
      `<<` (less than) and `~==` (equal to).
  ]##
  dt1.cmpDate(dt2) <= 0


template  `>>~==`*(dt1: DateTime | MonthMonthday, 
               dt2: DateTime | MonthMonthday): untyped =
  ##[ 
  A shortcut for `dt1.cmpDate(dt2) >= 0`,
  meaning `dt1` is `greater than or equal to` `dt2`.

  **Notes:**
    - There are therefore two ways of expressing the
      relationship `dt1` is `greater than or equal to` `dt2`.
        - `dt1.cmpDate(dt2) >= 0`
        - `dt1 >>~== dt2`
        - `dt1.geq(dt2)`
    - The operator `>>~==` is the combination of the operators 
      `>>` (greater than) and `~==` (equal to).
  ]##
  dt1.cmpDate(dt2) >= 0


# ==============================     Useful     ============================== #

func  isLastDayOfFebruary*(dt: DateTime): bool =
  ## Tests if `dt` is the last day of Frebruary.

  runnableExamples:
    let dt1 = dateTime(2023, mFeb, 28)
    let dt2 = dateTime(2024, mFeb, 28)
    let dt3 = dateTime(2024, mFeb, 29)

    doAssert:  dt1.isLastDayOfFebruary
    doAssert:  not dt2.isLastDayOfFebruary
    doAssert:  dt3.isLastDayOfFebruary

  if dt.month != mFeb:  return false
  elif dt.year.isLeapYear:  return (dt.monthday == 29)
  else:  return (dt.monthday == 28)


proc  getDayOfWeek*(dt: DateTime): WeekDay {.inline.} =
  ## Returns the day of the week of `dt`.
  getDayOfWeek(year = dt.year, month = dt.month, monthday = dt.monthday)


proc  isSaturdayOrSunday*(dt: DateTime): bool {.inline.} =
  ## Tests if `dt` is a Saturday or a Sunday.
  getDayOfWeek(dt) in {dSat, dSun}


func  nthWeekday*(year: int, month: Month, weekday: Weekday, 
                  nthOccurrence: int): Option[MonthdayRange] =
  ##[ 
  **Returns:** 
    - The n-th occurence of `<weekday>` in the month  
      that is defined by parameters `month` and `year`.
    - `none(MonthdayRange)` if the search is unsuccessful
      (this is particularly the case if 
      `nthOccurence == 0 or abs(nthOccurrence) > 5`).

  **Notes:**
    - If `nthOccurrence > 0` then counting is performed from the beginning of the month.
    - If `nthOccurrence < 0` then counting is performed from the end of the month.
  ]##
  
  runnableExamples:
    # search from the beginning of the month
    doAssert:  nthWeekday(2023, mAug, dMon, 1).get == 7.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dMon, 3).get == 21.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dMon, 5).isNone
    doAssert:  nthWeekday(2023, mAug, dTue, 5).get == 29.MonthdayRange
    # search from the end of the month
    doAssert:  nthWeekday(2023, mAug, dMon, -1).get == 28.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dMon, -3).get == 14.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dMon, -5).isNone
    doAssert:  nthWeekday(2023, mAug, dWed, -1).get == 30.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dThu, -5).get == 3.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dSat, -1).get == 26.MonthdayRange
    doAssert:  nthWeekday(2023, mAug, dSat, -3).get == 12.MonthdayRange

  if nthOccurrence == 0 or abs(nthOccurrence) > 5:
    return none(MonthdayRange)

  let weekday1st = getDayOfWeek(1.MonthdayRange, month, year)
  let daysInMonth = getDaysInMonth(month, year)
  let weekdayLast = getDayOfWeek(daysInMonth.MonthdayRange, month, year)

  if nthOccurrence > 0:  # counting from the beginning of the month
    let deltaWeekday = weekday.ord - weekday1st.ord
    let monthday = block:
      if deltaWeekday >= 0:  deltaWeekday + 7 * (nthOccurrence - 1) + 1
      else:  deltaWeekday + 7 * nthOccurrence + 1
    if 1 <= monthday and monthday <= daysInMonth:  
      result = some(monthday.MonthdayRange)
    else:  
      result = none(MonthdayRange)
  else:  # counting from the end of the month
    let deltaWeekday = weekdayLast.ord - weekday.ord
    let nthOccurr = -nthOccurrence
    let monthday = block:
      if deltaWeekday >= 0:  daysInMonth - deltaWeekday - 7*(nthOccurr-1)
      else:  daysInMonth - deltaWeekday - 7*nthOccurr
    if 1 <= monthday and monthday <= daysInMonth:  
      result = some(monthday.MonthdayRange)
    else:  
      result = none(MonthdayRange)
