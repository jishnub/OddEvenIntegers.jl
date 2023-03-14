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
for f in (:trailing_zeros, :count_ones)
	@eval Base.$f(x::AbstractOddEvenInteger) = $f(x.x)
end
for f in (:(>>), :(<<))
	@eval Base.$f(x::AbstractOddEvenInteger, y::UInt) = $f(x.x, y)
end

for f in (:*,)
	@eval Base.$f(x::Odd, y::Odd) = Odd($f(x.x, y.x))
	@eval Base.$f(x::AbstractOddEvenInteger, y::AbstractOddEvenInteger) = Even($f(x.x, y.x))
end
for f in (:-, :checked_abs)
	@eval Base.$f(x::Odd) = Odd(Base.$f(x.x))
	@eval Base.$f(x::Even) = Even(Base.$f(x.x))
end

for f in (:(==), :(≈))
	@eval Base.$f(::Odd, ::Even) = false
	@eval Base.$f(::Even, ::Odd) = false
end

Base.iseven(x::Odd) = false
Base.isodd(x::Odd) = true
Base.ispow2(x::Odd) = false
Base.iszero(x::Odd) = false

Base.iseven(x::Even) = true
Base.isodd(x::Even) = false

Base.zero(x::Odd) = zero(x.x)

Base.one(x::Even) = one(x.x)
# this definition arises from practicality
Base.oneunit(x::Even) = oneunit(x.x)

Base.show(io::IO, @nospecialize(x::AbstractOddEvenInteger)) = print(io, x.x)

# HalfIntegers interface

HalfIntegers.twice(::Type{Even{T}}, x::Integer) where {T} = Even(twice(T, x))::Even{T}

const HalfOddEvenInteger = Half{<:AbstractOddEvenInteger}
const HalfOddInteger = Half{<:Odd}
const HalfEvenInteger = Half{<:Even}

for f in (:+, :-)
	@eval begin
		Base.$f(x::HalfOddInteger, y::Integer) = half(Odd($f(twice(x), twice(y))))
		Base.$f(x::Integer, y::HalfOddInteger) = half(Odd($f(twice(x), twice(y))))
		Base.$f(x::HalfEvenInteger, y::Integer) = half(Even($f(twice(x), twice(y))))
		Base.$f(x::Integer, y::HalfEvenInteger) = half(Even($f(twice(x), twice(y))))
	end
end

function addsubhalf(f, xx, yy)
	f(xx >> 1, yy >> 1)
end
function Base.:(+)(x::HalfOddInteger, y::HalfOddInteger)
	z = addsubhalf(+, twice(x), twice(y))
	z + oneunit(z)
end
function Base.:(+)(x::HalfEvenInteger, y::HalfEvenInteger)
	addsubhalf(+, twice(x), twice(y))
end
function Base.:(-)(x::HalfOddInteger, y::HalfOddInteger)
	addsubhalf(-, twice(x), twice(y))
end
function Base.:(-)(x::HalfEvenInteger, y::HalfEvenInteger)
	addsubhalf(-, twice(x), twice(y))
end

for f in (:(==), :(≈))
	@eval Base.$f(x::HalfOddInteger, y::Integer) = false
	@eval Base.$f(y::Integer, x::HalfOddInteger) = false
end

Base.isapprox(x::HalfOddEvenInteger, y::HalfOddEvenInteger) = isapprox(twice(x), twice(y))

Base.iszero(::HalfOddInteger) = false
Base.isone(::HalfOddInteger) = false

end
