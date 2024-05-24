# nudates

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## Introduction

This module brings together some useful tools when working 
with `dates` (the prefix `nu` stands for `Nim utils`).


## Compatibility

Nim +2.0.0


## Dependencies

Nim standard library only.


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


## Overview

We will limit ourselves here to a few examples but the user 
is invited to browse the module documentation to have an 
overview of all the functionalities made available.

In the standard library, dates can be handled with the `DateTime` 
type of the [times][1] module. As its name suggests, this type 
actually allows us to manage dates and times at the same time. 
But sometimes intraday information (hours, minutes, seconds, etc.) 
is not important to us. 

For example, `dt1 = dateTime(2025, mDec, 25, 2)` and 
`dt2 = dateTime(2025, mDec, 25, 4)` both correspond to Christmas Day 
of the year 2025, while `dt1 == dt2` is `false` because the hours are 
not the same (resp. `2` and `4`). Consequently we have defined new 
comparison operators (`~==`, `!~==`, `<<`, `<<~==`, `>>`, `>>~==`) 
which do the same job as the original comparison operators of the
`DateTime` type (resp. `==`, `!=`, `<`, `<=`, `>`, `>=`), but which 
do not take intraday information (hours, minutes, seconds, etc.) into 
account in their processing (the reader will find a justification of 
the notations adopted in the respective documentation of these operators).


```nim
let dt1 = dateTime(2011, mSep, 18, 2)  # 2011-09-18T:02:00:00
let dt2 = dateTime(2011, mSep, 18, 5)  # 2011-09-18T:05:00:00
let dt3 = dateTime(2011, mOct, 18, 1)  # 2011-10-18T:01:00:00

doAssert:  dt1 == dt1  and  dt1 ~== dt1
doAssert:  dt1 != dt2  and  dt1 ~== dt2
doAssert:  dt1  < dt3  and  dt1  << dt3 
doAssert:  dt3  > dt1  and  dt3  >> dt1
```


## Documentation
  - [businessdays](https://github.com/GeK2K/businessdays)

## Documentation

[API Reference](https://gek2k.github.io/nudates/)


[1]: https://nim-lang.org/docs/times.html
