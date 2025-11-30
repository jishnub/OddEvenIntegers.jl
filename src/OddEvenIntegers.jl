module OddEvenIntegers

export Odd, Even

"""
	AbstractOddEvenInteger  <: Integer

Abstract superptye of odd and even integer types.

# Examples
```jldoctest; setup=:(using OddEvenIntegers)
julia> Odd <: OddEvenIntegers.AbstractOddEvenInteger
true

julia> Even <: OddEvenIntegers.AbstractOddEvenInteger
true
```
"""
abstract type AbstractOddEvenInteger <: Integer end

Base.:(==)(a::AbstractOddEvenInteger, b::AbstractOddEvenInteger) = a.x == b.x

"""
	Odd{T<:Integer} <: AbstractOddEvenInteger

Represent an odd integer.

# Examples
```jldoctest; setup=:(using OddEvenIntegers)
julia> Odd(3)
3

julia> isodd(Odd(3))
true
```
"""
struct Odd{T<:Integer} <: AbstractOddEvenInteger
	x :: T

	function Odd{T}(x::T) where {T<:Integer}
		isodd(x) || throw(DomainError(x, "arguments to Odd must be odd"))
		new(x)
	end
end

Odd(x::Integer) = Odd{typeof(x)}(x)
Odd(x::Odd) = x

Odd{T}(x::Odd) where {T<:Integer} = Odd(T(x.x))

"""
	Even{T<:Integer} <: AbstractOddEvenInteger

Represent an even integer.

# Examples
```jldoctest; setup=:(using OddEvenIntegers)
julia> Even(4)
4

julia> iseven(Even(4))
true
```
"""
struct Even{T<:Integer} <: AbstractOddEvenInteger
	x :: T

	function Even{T}(x::T) where {T<:Integer}
		iseven(x) || throw(DomainError(x, "arguments to Even must be even"))
		new(x)
	end
end
Even(x::Integer) = Even{typeof(x)}(x)
Even(x::Even) = x

Even{T}(x::Even) where {T<:Integer} = Even(T(x.x))

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

for f in (:+, :-)
	@eval Base.$f(x::Odd, y::Odd) = Even($f(x.x, y.x))
	@eval Base.$f(x::Even, y::Even) = Even($f(x.x, y.x))
	@eval Base.$f(x::Even, y::Odd) = Odd($f(x.x, y.x))
	@eval Base.$f(x::Odd, y::Even) = Odd($f(x.x, y.x))
end

for f in (:*,)
	@eval Base.$f(x::Odd, y::Odd) = Odd($f(x.x, y.x))
	@eval Base.$f(x::Union{Odd,Even}, y::Union{Odd,Even}) = Even($f(x.x, y.x))
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
Base.zero(::Type{Odd{T}}) where {T<:Integer} = zero(T)

Base.one(x::Even) = one(x.x)
Base.one(::Type{Even{T}}) where {T} = one(T)

Base.show(io::IO, @nospecialize(x::AbstractOddEvenInteger)) = print(io, x.x)

Base.promote_rule(::Type{Odd{T}}, ::Type{S}) where {T<:Integer, S<:Number} = promote_type(T, S)
Base.promote_rule(::Type{Even{T}}, ::Type{S}) where {T<:Integer, S<:Number} = promote_type(T, S)

end
