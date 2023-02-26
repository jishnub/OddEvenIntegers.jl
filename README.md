# HalfOddIntegers

This package interfaces with `HalfIntegers` to provide a type `HalfOddInt` that represents the half of an odd `Int`. The canonical way to construct such a type is as:
```julia
julia> using HalfOddIntegers, HalfIntegers

julia> x = half(OddInt(3))
3/2

julia> typeof(x)
Half{OddInt}
```

The advantage of such a type is that adding or subtracting integers doesn't change its type:
```julia
julia> x + 1 isa Half{OddInt}
true
```
and this is statically known to not be an integer.
```julia
julia> @code_typed isinteger(x)
CodeInfo(
1 ─     return false
) => Bool
```
