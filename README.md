# nudates

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## Introduction

This module brings together some useful tools when working 
with `dates` (the prefix `nu` stands for `Nim utils`).


## Compatibility

Nim +2.0.0


## Getting started

Install `nudates` using `nimble`:

```text
nimble install nudates
```

or add a dependency to the `.nimble` file of your project:

```text
requires "nudates >= 0.1.0"
```

and start using it.


## Feature overview

We will limit ourselves here to a few examples but the user 
is invited to browse the module documentation to have an 
overview of all the functionalities made available.

In the standard library, dates can be handled with the `DateTime` 
type of the [times][1] module. As its name suggests, this type 
actually allows us to manage dates and times at the same time. 
But sometimes intra-day information (hours, minutes, seconds, etc.) 
is not important to us. Let's give an example. 

`dt1 = dateTime(2025, mDec, 31, 2)` and `dt2 = dateTime(2025, mDec, 31, 4)` 
represent the same date (December 31, 2025) while `dt1 == dt2` is `false`
because the hours are not the same (resp. `2` and `4`). Consequently we 
have defined new comparison operators (`~==`, `!~==`, `<<`, `<<~==`, `>>`, 
`>>~==`) which do the same job as the original comparison operators 
(resp. `==`, `!=`, `<`, `<=`, `>`, `>=`), but which do not take intraday 
information (hours, minutes, seconds, etc.) into account in their processing 
(the reader will find a justification of the notations adopted in the 
respective documentation of these operators).

We have decided to also make the following alternatives available 
to the user: `eq`, `neq`, `lt`, `leq`, `gt`, `geq`. All these 
possibilities are detailed in the documentation below.

```nim
let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

doAssert:  dt1 == dt1  and  dt1 ~== dt1  # same as: dt1.eq(dt1)
doAssert:  dt1 != dt2  and  dt1 ~== dt2  # same as: dt1.eq(dt2)
doAssert:  dt1  < dt3  and  dt1  << dt3  # same as: dt1.lt(dt2) 
doAssert:  dt3  > dt1  and  dt3  >> dt1  # same as: dt1.gt(dt2)
```

The user has the possibility to work without the functionalities 
which are made available here. For example by ensuring that all 
intra-day information is systematically created with their default 
values and is never modified; or by setting them to 0 before using 
the default comparison operators of the `times` module. *Personally 
I would not favor any of these choices*.


## Documentation

[API Reference](https://gek2k.github.io/nudates/)


[1]: https://nim-lang.org/docs/times.html
