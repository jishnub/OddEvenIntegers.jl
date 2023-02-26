module HalfOddIntegers

using HalfIntegers

export OddInt

"""
	OddInteger  <: Integer

Abstract superptye of odd integer types.
Currently, only `OddInt <: OddInteger` is implemented.
"""
abstract type OddInteger <: Integer end

"""
	OddInt <: OddInteger

Represent an odd `Int`.
"""
struct OddInt <: OddInteger
	x :: Int

	OddInt(x::Int) = (@assert isodd(x); new(x))
end

OddInt(x::Integer) = OddInt(Int(x))
OddInt(x::OddInt) = x

Base.show(io::IO, o::OddInt) = show(io, o.x)

Base.Int(x::OddInt) = x.x

Base.promote_type(::Type{OddInt}, ::Type{OddInt}) = Int
Base.promote_rule(::Type{OddInt}, ::Type{T}) where {T<:Real} = promote_type(Int, T)

Base.AbstractFloat(x::OddInt) = Float64(x)
Base.Float64(x::OddInt) = Float64(x.x)

for f in (:<, :(<=), :rem)
	@eval Base.$f(x::OddInt, y::OddInt) = $f(x.x, y.x)
end
for f in (:(>>), :(<<))
	@eval Base.$f(x::OddInt, y::UInt) = $f(Int(x), y)
end
for f in (:*,)
	@eval Base.$f(x::OddInt, y::OddInt) = OddInt($f(x.x, y.x))
end
for f in (:-, :checked_abs)
	@eval Base.$f(x::OddInt) = OddInt(Base.$f(x.x))
end
for f in (:zero, :trailing_zeros)
	@eval Base.$f(x::OddInt) = $f(x.x)
end

Base.iseven(x::OddInt) = false
Base.isodd(x::OddInt) = true

Base.iszero(x::OddInt) = false

Base.div(x::OddInt, y::OddInt) = div(x.x, y.x)

"""
	HalfOddInt

Represent `n//2`, where `n` is an odd integer.
"""
const HalfOddInt = HalfIntegers.Half{OddInt}

Base.:(+)(x::HalfOddInt, y::Int) = half(OddInt(twice(x) + 2y))
Base.:(-)(x::HalfOddInt, y::Int) = half(OddInt(twice(x) - 2y))
Base.:(+)(x::Int, y::HalfOddInt) = half(OddInt(2x + twice(y)))
Base.:(-)(x::Int, y::HalfOddInt) = half(OddInt(2x - twice(y)))

Base.isinteger(x::HalfOddInt) = false

Base.:(==)(x::HalfOddInt, y::Integer) = false
Base.:(==)(y::Integer, x::HalfOddInt) = false

end
