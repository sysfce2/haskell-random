# 1.3.0

* Add `Seed`, `SeedGen`, `seedSize`, `mkSeed` and `unSeed`:
  [#162](https://github.com/haskell/random/pull/162)
* Add `SplitGen` and `splitGen`: [#160](https://github.com/haskell/random/pull/160)
* Add `shuffleList` and `shuffleListM`: [#140](https://github.com/haskell/random/pull/140)
* Add `mkStdGen64`: [#155](https://github.com/haskell/random/pull/155)
* Add `uniformListRM`, `uniformList`, `uniformListR`, `uniforms` and `uniformRs`:
  [#154](https://github.com/haskell/random/pull/154)
* Add compatibility with recently added `ByteArray` to `base`:
  [#153](https://github.com/haskell/random/pull/153)
  * Switch to using `ByteArray` for type class implementation instead of
    `ShortByteString`
  * Add `unsafeUniformFillMutableByteArray` to `RandomGen` and a helper function
    `defaultUnsafeUniformFillMutableByteArray` that makes implementation
    for most instances easier.
  * Add `uniformByteArray`, `uniformByteString` and `uniformFillMutableByteArray`
  * Add `uniformByteArrayM` to `StatefulGen`
  * Add `uniformByteStringM` and `uniformShortByteStringM`
  * Deprecate `uniformShortByteString` in favor of `uniformShortByteStringM` for
    consistent naming and a future plan of removing it from `StatefulGen`
    type class
  * Expose a helper function `genByteArrayST`, that can be used for
    defining implementation for `uniformByteArrayM`
* Improve `FrozenGen` interface: [#149](https://github.com/haskell/random/pull/149)
  * Move `thawGen` from `FreezeGen` into the new `ThawGen` type class. Fixes an issue with
    an unlawful instance of `StateGen` for `FreezeGen`.
  * Add `modifyGen` and `overwriteGen` to the `FrozenGen` type class
  * Switch `splitGenM` to use `SplitGen` and `FrozenGen` instead of deprecated `RandomGenM`
  * Add `splitMutableGenM`
  * Switch `randomM` and `randomRM` to use `FrozenGen` instead of `RandomGenM`
  * Deprecate `RandomGenM` in favor of a more powerful `FrozenGen`
* Add `isInRangeOrd` and `isInRangeEnum` that can be used for implementing `isInRange`:
  [#148](https://github.com/haskell/random/pull/148)
* Add `isInRange` to `UniformRange`: [#78](https://github.com/haskell/random/pull/78)
* Add default implementation for `uniformRM` using `Generics`:
  [#92](https://github.com/haskell/random/pull/92)

# 1.2.1

* Fix support for ghc-9.2 [#99](https://github.com/haskell/random/pull/99)
* Fix performance regression for ghc-9.0 [#101](https://github.com/haskell/random/pull/101)
* Add `uniformEnumM` and `uniformEnumRM`
* Add `initStdGen` [#103](https://github.com/haskell/random/pull/103)
* Add `globalStdGen` [#117](https://github.com/haskell/random/pull/117)
* Add `runStateGenST_`
* Ensure that default implementation of `ShortByteString` generation uses
  unpinned memory. [#116](https://github.com/haskell/random/pull/116)
* Fix [#54](https://github.com/haskell/random/issues/54) with
  [#68](https://github.com/haskell/random/pull/68) - if exactly one value in the
  range of floating point is infinite, then `uniformRM`/`randomR` returns that
  value.
* Add default implementation of `uniformM` that uses `Generic`
  [#70](https://github.com/haskell/random/pull/70)
* `Random` instance for `CBool` [#77](https://github.com/haskell/random/pull/77)
* Addition of `TGen` and `TGenM` [#95](https://github.com/haskell/random/pull/95)
* Addition of tuple instances for `Random` up to 7-tuple
  [#72](https://github.com/haskell/random/pull/72)

# 1.2.0

1. Breaking change which mostly maintains backwards compatibility, see
   "Breaking Changes" below.
2. Support for monadic generators e.g. [mwc-random](https://hackage.haskell.org/package/mwc-random).
3. Monadic adapters for pure generators (providing a uniform monadic
   interface to pure and monadic generators).
4. Faster in all cases except one by more than x18 (N.B. x18 not 18%) and
   some cases (depending on the type) faster by more than x1000 - see
   below for benchmarks.
5. Passes a large number of random number test suites:
   * [dieharder](http://webhome.phy.duke.edu/~rgb/General/dieharder.php "venerable")
   * [TestU01 (SmallCrush, Crush, BigCrush)](http://simul.iro.umontreal.ca/testu01/tu01.html "venerable")
   * [PractRand](http://pracrand.sourceforge.net/ "active")
   * [gjrand](http://gjrand.sourceforge.net/ "active")
   * See [random-quality](https://github.com/tweag/random-quality)
     for details on how to do this yourself.
6. Better quality split as judged by these
	[tests](https://www.cambridge.org/core/journals/journal-of-functional-programming/article/evaluation-of-splittable-pseudorandom-generators/3EBAA9F14939C5BB5560E32D1A132637). Again
	see [random-quality](https://github.com/tweag/random-quality) for
	details on how to do this yourself.
7. Unbiased generation of ranges.
8. Updated tests and benchmarks.
9. [Continuous integration](https://travis-ci.org/github/haskell/random).

### Breaking Changes

Version 1.2.0 introduces these breaking changes:

* requires `base >= 4.8` (GHC-7.10)
* `StdGen` is no longer an instance of `Read`
* `randomIO` and `randomRIO` were extracted from the `Random` class into
  separate functions

In addition, there may be import clashes with new functions, e.g. `uniform` and
`uniformR`.

### Deprecations

Version 1.2.0 introduces `genWord64`, `genWord32` and similar methods to the
`RandomGen` class. The significantly slower method `next` and its companion
`genRange` are now deprecated.

### Issues Addressed

 Issue Number | Description | Comment
--------------|-------------|--------
 [25](https://github.com/haskell/random/issues/25) | The seeds generated by split are not independent | Fixed: changed algorithm to SplitMix, which provides a robust split operation
 [26](https://github.com/haskell/random/issues/26) | Add Random instances for tuples | Addressed: added `Uniform` instances for up to 6-tuples
 [44](https://github.com/haskell/random/issues/44) | Add Random instance for Natural | Addressed: added UniformRange instance for Natural
 [51](https://github.com/haskell/random/issues/51) | Very low throughput | Fixed: see benchmarks below
 [53](https://github.com/haskell/random/issues/53) | incorrect distribution of randomR for floating-point numbers | (\*)
 [55](https://github.com/haskell/random/issues/55) | System/Random.hs:43:1: warning: [-Wtabs] | Fixed: No more tabs
 [58](https://github.com/haskell/random/issues/58) | Why does random for Float and Double produce exactly 24 or 53 bits? | (\*)
 [59](https://github.com/haskell/random/issues/59) | read :: StdGen fails for strings longer than 6 | Addressed: StdGen is no longer an instance of Read

#### Comments

(\*) 1.2 samples more bits but does not sample every `Float` or
`Double`. There are methods to do this but they have some downsides;
see [here](https://github.com/idontgetoutmuch/random/issues/105) for a
fuller discussion.

## Benchmarks

Here are some benchmarks run on a 3.1 GHz Intel Core i7. The full
benchmarks can be run using e.g. `stack bench`. The benchmarks are
measured in milliseconds per 100,000 generations. In some cases, the
performance is over x1000 times better; the minimum performance
increase for the types listed below is more than x36.

 Name       | 1.1 Mean | 1.2 Mean
------------|----------|----------
 Float      |   27.819 |    0.305
 Double     |   50.644 |    0.328
 Integer    |   42.332 |    0.332
 Word       |   40.739 |    0.027
 Int        |   43.847 |    0.028
 Char       |   17.009 |    0.462
 Bool       |   17.542 |    0.027

# 1.1
  * breaking change to `randomIValInteger` to improve RNG quality and performance
    see https://github.com/haskell/random/pull/4 and
    ghc https://ghc.haskell.org/trac/ghc/ticket/8898
  * correct documentation about generated range of Int32 sized values of type Int
    https://github.com/haskell/random/pull/7
  * fix memory leaks by using strict fields and strict atomicModifyIORef'
    https://github.com/haskell/random/pull/8
    related to ghc trac tickets  #7936 and #4218
  * support for base < 4.6 (which doesnt provide strict atomicModifyIORef')
    and integrating Travis CI support.
    https://github.com/haskell/random/pull/12
  * fix C type in test suite https://github.com/haskell/random/pull/9

# 1.0.1.1
bump for overflow bug fixes

# 1.0.1.2
bump for ticket 8704, build fusion

# 1.0.1.0
bump for bug fixes,

# 1.0.0.4
bumped version for float/double range bugfix
