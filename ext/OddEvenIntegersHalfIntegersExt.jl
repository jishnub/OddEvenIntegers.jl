module OddEvenIntegersHalfIntegersExt

using OddEvenIntegers
import OddEvenIntegers: AbstractOddEvenInteger
using HalfIntegers

# HalfIntegers interface

HalfIntegers.twice(::Type{Even{T}}, x::Integer) where {T} = Even(twice(T, x))::Even{T}

const HalfOddEvenInteger = Half{<:AbstractOddEvenInteger}
const HalfOddInteger{T<:Integer} = Half{Odd{T}}
const HalfEvenInteger{T<:Integer} = Half{Even{T}}

HalfOddInteger(h::Half{T}) where {T<:Integer} = half(Odd(twice(h)))

for f in (:+, :-)
	@eval begin
		Base.$f(x::HalfOddInteger, y::Union{Integer, HalfEvenInteger}) = half(Odd($f(twice(x), twice(y))))
		Base.$f(x::Union{Integer, HalfEvenInteger}, y::HalfOddInteger) = half(Odd($f(twice(x), twice(y))))
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

# hack around the fact that we can't have an odd zero
Base.zero(h::HalfOddInteger{T}) where {T<:Integer} = zero(Half{T})
Base.zero(::Type{HalfOddInteger{T}}) where {T<:Integer} = zero(Half{T})

Base.iszero(::HalfOddInteger) = false
Base.isone(::HalfOddInteger) = false

# We can't have a HalfOddInt 1, as we can't have an Odd 2. We therefore need to work around this
# Ideally, such a range should not be created
Base.step(r::AbstractUnitRange{HalfOddInteger{T}}) where {T<:Integer} = oneunit(T)

if VERSION < v"1.9"
	# work around broadcasting creating UnitRanges on older Julia versions (e.g. v1.6)
	Base.broadcasted(::Broadcast.DefaultArrayStyle{1}, ::typeof(+), r::AbstractUnitRange{<:Integer}, x::HalfOddInteger) =
		range(first(r)+x, step=step(r), length=length(r))
	Base.broadcasted(::Broadcast.DefaultArrayStyle{1}, ::typeof(-), r::AbstractUnitRange{<:Integer}, x::HalfOddInteger) =
		range(first(r)-x, step=step(r), length=length(r))
	Base.broadcasted(::Broadcast.DefaultArrayStyle{1}, ::typeof(+), x::HalfOddInteger, r::AbstractUnitRange{<:Integer}) =
		range(x+first(r), step=step(r), length=length(r))
end

function _unitsteprange_ofeltype(start, stop, ::Type{T}) where {T}
	startT, stopT = convert.(T, promote(start, stop))
	StepRange(startT, Integer(oneunit(stopT-startT)), stopT)
end
function _range_decreasestop(start, stop, T::Type)
	stop_shifted = stop - half(1)
	_unitsteprange_ofeltype(start, stop_shifted, T)
end
Base.:(:)(start::HalfOddInteger, stop::Integer) = _range_decreasestop(start, stop, HalfOddInteger)
Base.:(:)(start::Integer, stop::HalfOddInteger) = _range_decreasestop(start, stop, Integer)
function Base.:(:)(start::HalfOddInteger, stop::HalfOddInteger)
	_unitsteprange_ofeltype(start, stop, HalfOddInteger)
end

function _steprange_ofeltype(start, step::Integer, stop, ::Type{T}) where {T}
	iszero(step) && throw(ArgumentError("step cannot be zero"))
	startstopstep_promoted = promote(start, stop, step)
	startstop_promoted = map(T, startstopstep_promoted[1:2])
	StepRange(startstop_promoted[1], Integer(startstopstep_promoted[3]), startstop_promoted[2])
end

function _range_decreasestop(start, step::Integer, stop, T::Type)
	stop_shifted = stop - sign(step) * half(1)
	_steprange_ofeltype(start, step, stop_shifted, T)
end
Base.:(:)(start::HalfOddInteger, step::Integer, stop::Integer) = _range_decreasestop(start, step, stop, HalfOddInteger)
Base.:(:)(start::Integer, step::Integer, stop::HalfOddInteger) = _range_decreasestop(start, step, stop, Integer)
function Base.:(:)(start::HalfOddInteger, step::Integer, stop::HalfOddInteger)
	_steprange_ofeltype(start, step, stop, HalfOddInteger)
end

end
