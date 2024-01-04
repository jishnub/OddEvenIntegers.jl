using OddEvenIntegers
using HalfIntegers
using Test

using Aqua
@testset "project quality" begin
    Aqua.test_all(OddEvenIntegers)
end

using Documenter
DocMeta.setdocmeta!(OddEvenIntegers, :DocTestSetup, :(using OddEvenIntegers); recursive=true)
@testset "doctests" begin
    doctest(OddEvenIntegers, manual=false)
end

@testset "OddEvenIntegers.jl" begin
    @testset "Odd" begin
        @test_throws DomainError Odd(2)
        x = Odd(3)
        @test x isa Odd{Int}
        @test x == x
        @test x ≈ x
        @test x == 3
        @test x ≈ 3
        @test isodd(x)
        @test !iseven(x)
        @test !iszero(x)
        @test !ispow2(x)
        @test -x == -3
        @test Odd(x) == x
        @test x == x == Int(x)
        @test !(x < x)
        @test !(x > x)
        @test x <= x
        @test x >= x
        @test (x >> 1) == 1
        @test (x << 1) == 6
        @test iseven(x + x)
        @test x + x == 6
        @test x - x == 0
        @test x * x == 9
        @test abs(-x) == abs(x) == 3
        @test Base.checked_abs(-x) == 3
        @test zero(x) == 0
        @test one(x) == 1
        @test trailing_zeros(x) == 0
        @test rem(x, x) == 0
        @test div(x, x) == 1
        @test x + 2.0 == 5.0
        @test x + big(typemax(Int)) == big(3) + big(typemax(Int))
        @test twice(x) == 6

        @test promote(x, x) == promote(x, Int(x)) == (3, 3)

        @test BigInt(Odd(3)) == 3
        @test BigInt(Odd(3)) isa BigInt
        @test Odd(big(typemax(Int))) + 1 == big(typemax(Int)) + 1

        @test Odd{BigInt}(x) == x
        @test Odd{BigInt}(x) isa Odd{BigInt}

        if VERSION >= v"1.8"
            @test range(Odd(1), length=2) == 1:2
            @test range(1, length=Odd(3)) == 1:3
            @test range(Odd(1), length=Odd(3)) == 1:3
            @test Odd(1):4 == 1:4
            @test Odd(1):2:Odd(5) == 1:2:5
            @test 1:2:Odd(5) == 1:2:5
        end

        h = Odd(3)
        @test iszero(zero(h))
        @test iszero(zero(typeof(h)))
        @test typeof(zero(h)) == typeof(zero(typeof(h)))

        @testset "promote_type" begin
            @test promote_type(Odd{Int8}, Odd{Int16}) == promote_type(Int8, Int16)
            @test promote_type(Odd{Int8}, Int16) == promote_type(Int8, Int16)
        end
    end
    @testset "Even" begin
        @test_throws DomainError Even(1)
        x = Even(4)
        @test x isa Even{Int}
        @test x == x
        @test x ≈ x
        @test x == 4
        @test x ≈ 4
        @test !isodd(x)
        @test iseven(x)
        @test !iszero(x)
        @test ispow2(x)
        @test -x == -4
        @test Even(x) == x
        @test x == x == Int(x)
        @test !(x < x)
        @test !(x > x)
        @test x <= x
        @test x >= x
        @test (x >> 1) == 2
        @test (x << 1) == 8
        @test iseven(x + x)
        @test x + x == 8
        @test x - x == 0
        @test x * x isa Even
        @test x * x == 16
        @test abs(-x) == abs(x) == 4
        @test Base.checked_abs(-x) == 4
        @test zero(x) == Even(0) == 0
        @test one(x) == 1
        @test_throws DomainError oneunit(x)
        @test trailing_zeros(x) == 2
        @test rem(x, x) == 0
        @test div(x, x) == 1
        @test x + 2.0 == 6.0
        @test x + big(typemax(Int)) == big(4) + big(typemax(Int))
        @test twice(x) == 8

        @test promote(x, x) == promote(x, Int(x)) == (4, 4)

        @test BigInt(Even(4)) == 4
        @test BigInt(Even(4)) isa BigInt
        @test Even(big(typemin(Int))) - 1 == big(typemin(Int)) - 1

        @test Even{BigInt}(x) == x
        @test Even{BigInt}(x) isa Even{BigInt}

        if VERSION >= v"1.8"
            @test range(Even(2), length=2) == 2:3
            @test Even(2):10 == 2:10
            @test Even(2):Even(2):10 == 2:2:10
            @test 2:Even(2):10 == 2:2:10
        end

        h = Even(4)
        @test isone(one(h))
        @test isone(one(typeof(h)))
        @test typeof(zero(h)) == typeof(zero(typeof(h)))

        @testset "promote_type" begin
            @test promote_type(Even{Int8}, Even{Int16}) == promote_type(Int8, Int16)
            @test promote_type(Even{Int8}, Int16) == promote_type(Int8, Int16)
        end
    end
    @testset "Odd and Even" begin
        @test Odd(1) + Even(2) == Even(2) + Odd(1) == 3
        @test isodd(Odd(1) + Even(2))
        @test iseven(Odd(1) * Even(2))
        @test Odd(1) * Even(2) == 2
        @test promote(Odd(1), Even(2)) == (1, 2)
        if VERSION >= v"1.8"
            @test Odd(1):Even(2):Odd(5) == 1:2:5
        end
        @test Odd(1) != Even(2)
        @test Even(2) != Odd(1)
        @test !(Odd(1) ≈ Even(2))
        @test !(Even(2) ≈ Odd(1))

        @testset "promote_type" begin
            @test promote_type(Even{Int8}, Odd{Int16}) == promote_type(Int8, Int16)
            @test promote_type(Odd{Int8}, Even{Int16}) == promote_type(Int8, Int16)
        end
    end
    @testset "half integers" begin
        @testset "Odd" begin
            HalfOddInteger{T<:Integer} = Half{Odd{T}}
            HalfOddInteger(x::HalfOddInteger) = x
            HalfOddInteger(h::Half{T}) where {T<:Integer} = half(Odd(twice(h)))

            x = half(Odd(3))
            @test x isa Half{Odd{Int}}
            @test x == x
            @test x ≈ x
            @test x == 3/2
            @test 3/2 == x
            @test x ≈ 3/2
            @test 3/2 ≈ x
            @test !(x ≈ 2)
            @test !(2 ≈ x)
            @test !isinteger(x)
            @test !iszero(x)
            @test !isone(x)
            @test -x == -3/2
            @test x + 1 == 5/2
            @test x - 1 == 1/2
            @test 1 + x == 5/2
            @test 1 - x == -1/2
            @test x + x == 3
            @test x - x == 0
            @test isinteger(x + half(Odd(1)))
            @test isinteger(x - half(Odd(1)))
            @test x * x == (3/2)^2
            @test x / x ≈ 1
            y = half(Odd(5))
            @test x + y == 4
            @test x - y == -1
            @test x != 1
            @test 1 != x
            @test HalfOddInteger(x) === x
            @test HalfOddInteger(half(3)) === x

            @test half(Odd(typemax(Int))) + half(Odd(typemax(Int))) == typemax(Int)

            h = half(Odd(3))
            @test iszero(zero(h))
            @test iszero(zero(typeof(h)))
            @test typeof(zero(h)) == typeof(zero(typeof(h)))

            @testset "ranges" begin
                r = half(Odd(1)):half(Odd(5))
                @test isone(step(r))
                @test typeof(r[1] + step(r)) == typeof(r[1])
                @test length(r) == 3
            end

            @testset "BigInt" begin
                @test Odd(big(3)) == Odd(big(3))
            end
        end
        @testset "Even" begin
            x = half(Even(4))
            @test x isa Half{Even{Int}}
            @test x == x
            @test x ≈ x
            @test x == 2
            @test 2 == x
            @test x ≈ 2
            @test 2 ≈ x
            @test isinteger(x)
            @test !iszero(x)
            @test !isone(x)
            @test -x == -2
            @test x + 1 == 3
            @test x - 1 == 1
            @test 1 + x == 3
            @test 1 - x == -1
            @test x + x == 4
            @test x - x == 0
            @test isinteger(x + half(Even(2)))
            @test isinteger(x - half(Even(2)))
            @test x * x == 4
            @test x / x ≈ 1
            y = half(Even(6))
            @test x + y == 5
            @test x - y == -1
            @test x != 1
            @test 1 != x

            y = half(Even(2))
            @test y == 1
            @test 1 == y
            @test isone(y)
            if VERSION >= v"1.7"
                @test isodd(y)
                @test !iseven(y)
            end
            @test !iszero(y)

            y = half(Even(0))
            @test y == 0
            @test 0 == y
            @test iszero(y)
            @test !isone(y)
            if VERSION >= v"1.7"
                @test iseven(y)
                @test !isodd(y)
            end

            h = half(Even(4))
            @test isone(one(h))
            @test isone(one(typeof(h)))
            @test typeof(zero(h)) == typeof(zero(typeof(h)))

            @test half(Even(typemin(Int))) - half(Even(2)) == (typemin(Int) >> 1) - 1

            @testset "ranges" begin
                r = half(Even(2)):half(Even(6))
                @test isone(step(r))
                @test typeof(r[1] + step(r)) == typeof(r[1])
                @test length(r) == 3
            end

            @testset "BigInt" begin
                @test Even(big(4)) == Even(big(4))
            end
        end
        @testset "Odd and Even" begin
            @test half(Odd(1)) != half(Even(2))
            @test half(Even(2)) != half(Odd(1))
            @test !(half(Odd(1)) ≈ half(Even(2)))
            @test !(half(Even(2)) ≈ half(Odd(1)))
            @test !isinteger(half(Odd(1)) + half(Even(2)))
            @test !isinteger(half(Odd(1)) - half(Even(2)))
            @test !isinteger(half(Even(2)) + half(Odd(1)))
            @test !isinteger(half(Even(2)) - half(Odd(1)))

            @test !isinteger(half(Odd(1)) + half(Even(2)))
            @test !isinteger(half(Even(2)) + half(Odd(1)))
            @test !isinteger(half(Odd(1)) - half(Even(2)))
            @test !isinteger(half(Even(2)) - half(Odd(1)))
        end
        @testset "Odd and integer ranges" begin
            _integer_or_halfinteger(x::Integer) = x
            _integer_or_halfinteger(x::Half{Odd{T}}) where {T} = convert(Half{T}, x)
            function test_range(start, stop, T)
                r = @inferred start:stop
                s = (:)(map(_integer_or_halfinteger, (start, stop))...)
                @test r == s
                @test length(r) == length(s) == length(collect(r))
                @test r isa AbstractRange{T}
                @test @inferred(step(r)) == 1
                @test @inferred(first(r)) isa T
                if length(r) > 0
                    @test @inferred(r[1]) isa T
                end
                if length(r) > 1
                    @test @inferred(r[2]) isa T
                end
            end
            @testset "UnitRange" begin
                # this range doesn't conform to the supertype
                # as typeof(step(r)) != eltype(r)
                # however, such ranges are occasionally created,
                # especially on older Julia versions
                r = UnitRange(half(Odd(3)), half(Odd(7)))
                @test step(r) === 1
            end
            @testset "unit step range" begin
                @testset "Odd{Int}" begin
                    test_range(half(Odd(1)), half(Odd(19)), Half{Odd{Int}})

                    test_range(half(Odd(1)), 5, Half{Odd{Int}})

                    test_range(2, half(Odd(7)), Int)

                    @test (1:4) .+ half(Odd(3)) === range(half(Odd(5)), length=4, step=1)
                    @test half(Odd(3)) .+ (1:4) === range(half(Odd(5)), length=4, step=1)
                    @test (1:4) .- half(Odd(3)) === range(half(Odd(-1)), length=4, step=1)
                end

                @testset "Odd{BigInt}" begin
                    test_range(half(Odd(big(1))), half(Odd(big(19))), Half{Odd{BigInt}})

                    test_range(half(Odd(1)), half(Odd(big(19))), Half{Odd{BigInt}})

                    test_range(half(Odd(big(1))), half(Odd(19)), Half{Odd{BigInt}})

                    test_range(half(Odd(1)), big(5), Half{Odd{BigInt}})

                    test_range(half(Odd(big(1))), 5, Half{Odd{BigInt}})

                    test_range(2, half(Odd(big(7))), BigInt)
                end
            end

            function test_range(start, stepsize, stop, T, S)
                r = @inferred start:stepsize:stop
                s = (:)(map(_integer_or_halfinteger, (start, stepsize, stop))...)
                @test r == s
                @test length(r) == length(s) == length(collect(r))
                @test r isa StepRange{T,S}
                @test @inferred(first(r)) isa T
                if length(r) > 0
                    @test @inferred(r[1]) isa T
                end
                if length(r) > 1
                    @test @inferred(r[2]) isa T
                end
                @test @inferred(step(r)) isa S
            end

            @testset "StepRange" begin
                @testset "Odd{Int}" begin
                    for stepsize in [-2:-1; 1:2]
                        test_range(half(Odd(1)), stepsize, half(Odd(19)), Half{Odd{Int}}, Int)
                        test_range(half(Odd(19)), stepsize, half(Odd(1)), Half{Odd{Int}}, Int)

                        test_range(half(Odd(1)), stepsize, 25, Half{Odd{Int}}, Int)

                        test_range(2, stepsize, half(Odd(17)), Int, Int)
                    end
                    @test_throws ArgumentError half(Odd(1)):0:2
                    @test_throws ArgumentError 2:0:half(Odd(3))
                    @test_throws ArgumentError half(Odd(1)):0:half(Odd(3))
                end

                @testset "Odd{BigInt}" begin
                    for stepsize in [-2:-1; 1:2]
                        test_range(half(Odd(big(1))), stepsize, half(Odd(19)), Half{Odd{BigInt}}, BigInt)
                        test_range(half(Odd(1)), big(stepsize), half(Odd(19)), Half{Odd{BigInt}}, BigInt)
                        test_range(half(Odd(1)), stepsize, half(Odd(big(19))), Half{Odd{BigInt}}, BigInt)

                        test_range(half(Odd(19)), stepsize, half(Odd(big(1))), Half{Odd{BigInt}}, BigInt)

                        test_range(half(Odd(big(1))), stepsize, 10, Half{Odd{BigInt}}, BigInt)
                        test_range(half(Odd(1)), big(stepsize), 10, Half{Odd{BigInt}}, BigInt)
                        test_range(half(Odd(1)), stepsize, big(10), Half{Odd{BigInt}}, BigInt)

                        test_range(big(2), stepsize, half(Odd(19)), BigInt, BigInt)
                        test_range(2, big(stepsize), half(Odd(19)), BigInt, BigInt)
                        test_range(2, stepsize, half(Odd(big(19))), BigInt, BigInt)
                    end

                    @test_throws ArgumentError half(Odd(1)):big(0):2
                    @test_throws ArgumentError half(Odd(1)):0:big(2)
                    @test_throws ArgumentError big(2):0:half(Odd(3))
                    @test_throws ArgumentError 2:big(0):half(Odd(3))
                    @test_throws ArgumentError half(Odd(1)):0:half(Odd(big(3)))
                    @test_throws ArgumentError half(Odd(1)):big(0):half(Odd(3))
                end
            end
        end
    end
end
