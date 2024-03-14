# OddEvenIntegers

[![CI](https://github.com/jishnub/OddEvenIntegers.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/jishnub/OddEvenIntegers.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/jishnub/OddEvenIntegers.jl/branch/main/graph/badge.svg?token=o27ttv0uxp)](https://codecov.io/gh/jishnub/OddEvenIntegers.jl)
[![pkgeval](https://juliahub.com/docs/General/OddEvenIntegers/stable/pkgeval.svg)](https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html)

This package provides the types `Odd` and `Even` that may wrap an integer. Using these types, the result of `isodd` and `iseven` may be evaluated at compile time.
```julia
julia> Odd(3)
3

julia> Even(4)
4

julia> @code_typed isodd(Odd(3))
CodeInfo(
1 ─     return true
) => Bool

julia> @code_typed iseven(Even(4))
CodeInfo(
1 ─     return true
) => Bool
```

This package interfaces with `HalfIntegers`, so that the half of an `Odd` or an `Even` may access the half-integer methods, some of which may be evaluated at compile time. The canonical way to construct and use such a type is:
```julia
julia> using OddEvenIntegers, HalfIntegers

julia> x = half(Odd(3))
3/2

julia> @code_typed isinteger(x)
CodeInfo(
1 ─     return false
) => Bool

julia> x + 1
5/2

julia> @code_typed isinteger(x + 1)
CodeInfo(
1 ─     return false
) => Bool
```
