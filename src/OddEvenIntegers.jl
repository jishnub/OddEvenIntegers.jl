module OddEvenIntegers

using HalfIntegers

export Odd, Even

"""
	AbstractOddEvenInteger  <: Integer

Abstract superptye of odd and even integer types.

# Examples
```jldoctest
julia> Odd <: OddEvenIntegers.AbstractOddEvenInteger
true

julia> Even <: OddEvenIntegers.AbstractOddEvenInteger
true
```
"""
abstract type AbstractOddEvenInteger <: Integer end

"""
	Odd{T<:Integer} <: AbstractOddEvenInteger

Represent an odd integer.

# Examples
```jldoctest
julia> Odd(3)
3

julia> isodd(Odd(3))
true
```
"""
struct Odd{T<:Integer} <: AbstractOddEvenInteger
	x :: T

	Odd{T}(x::T) where {T<:Integer} = (@assert isodd(x); new(x))
end

Odd(x::Integer) = Odd{typeof(x)}(x)
Odd(x::Odd) = x

"""
	Even{T<:Integer} <: AbstractOddEvenInteger

Represent an even integer.

# Examples
```jldoctest
julia> Even(4)
4

julia> iseven(Even(4))
true
```
"""
struct Even{T<:Integer} <: AbstractOddEvenInteger
	x :: T

	Even{T}(x::T) where {T<:Integer} = (@assert iseven(x); new(x))
end
Even(x::Integer) = Even{typeof(x)}(x)
Even(x::Even) = x

Base.promote_type(::Type{Odd{A}}, ::Type{Odd{B}}) where {A,B} = promote_type(A,B)
Base.promote_type(::Type{Even{A}}, ::Type{Even{B}}) where {A,B} = promote_type(A,B)
Base.promote_rule(::Type{Odd{A}}, ::Type{T}) where {A,T<:Real} = promote_type(A, T)
Base.promote_rule(::Type{Even{A}}, ::Type{T}) where {A,T<:Real} = promote_type(A, T)

for f in [:AbstractFloat, :Float16, :Float32, :Float64, :BigFloat,
		:Int8, :Int16, :Int32, :Int64, :Int128, :BigInt]
	@eval Base.$f(x::AbstractOddEvenInteger) = $f(x.x)
end

for f in (:<, :(<=), :rem, :div)
	@eval Base.$f(x::AbstractOddEvenInteger, y::AbstractOddEvenInteger) = $f(x.x, y.x)
end
for f in (:trailing_zeros,)
	@eval Base.$f(x::AbstractOddEvenInteger) = $f(x.x)
end
for f in (:(>>), :(<<))
	@eval Base.$f(x::AbstractOddEvenInteger, y::UInt) = $f(x.x, y)
end

for f in (:+, :-)
	@eval Base.$f(x::T, y::T) where {T<:Union{Odd, Even}} = Even($f(x.x, y.x))
	@eval Base.$f(x::AbstractOddEvenInteger, y::AbstractOddEvenInteger) = Odd($f(x.x, y.x))
end
for f in (:*,)
	@eval Base.$f(x::Odd, y::Odd) = Odd($f(x.x, y.x))
	@eval Base.$f(x::AbstractOddEvenInteger, y::AbstractOddEvenInteger) = Even($f(x.x, y.x))
end
for f in (:-, :checked_abs)
	@eval Base.$f(x::Odd) = Odd(Base.$f(x.x))
	@eval Base.$f(x::Even) = Even(Base.$f(x.x))
end

Base.iseven(x::Odd) = false
Base.isodd(x::Odd) = true
Base.iseven(x::Even) = true
Base.isodd(x::Even) = false

Base.zero(x::Odd) = zero(x.x)
Base.iszero(x::Odd) = false

Base.show(io::IO, @nospecialize(x::AbstractOddEvenInteger)) = print(io, x.x)

# HalfIntegers interface

HalfIntegers.twice(x::AbstractOddEvenInteger) = Even(twice(x.x))

const HalfOddInteger = HalfIntegers.Half{<:Odd{<:Integer}}
const HalfEvenInteger = HalfIntegers.Half{<:Even{<:Integer}}

for f in (:+, :-)
	@eval begin
		Base.$f(x::HalfOddInteger, y::Integer) = half(Odd($f(twice(x), twice(y))))
		Base.$f(x::Integer, y::HalfOddInteger) = half(Odd($f(twice(x), twice(y))))
		Base.$f(x::HalfEvenInteger, y::Integer) = half(Even($f(twice(x), twice(y))))
		Base.$f(x::Integer, y::HalfEvenInteger) = half(Even($f(twice(x), twice(y))))
	end
end

Base.:(==)(x::HalfOddInteger, y::Integer) = false
Base.:(==)(y::Integer, x::HalfOddInteger) = false

end
