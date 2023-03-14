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
        @test_throws Exception Odd(2)
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

        if VERSION >= v"1.8"
            @test range(Odd(1), length=2) == 1:2
            @test range(1, length=Odd(3)) == 1:3
            @test range(Odd(1), length=Odd(3)) == 1:3
            @test Odd(1):4 == 1:4
            @test Odd(1):2:Odd(5) == 1:2:5
            @test 1:2:Odd(5) == 1:2:5
        end
    end
    @testset "Even" begin
        @test_throws Exception Even(1)
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
        @test oneunit(x) == 1
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

        if VERSION >= v"1.8"
            @test range(Even(2), length=2) == 2:3
            @test range(2, length=Even(2)) == 2:3
            @test range(Even(2), length=Even(2)) == 2:3
            @test Even(2):10 == 2:10
            @test Even(2):Even(2):10 == 2:2:10
            @test 2:Even(2):10 == 2:2:10
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
    end
    @testset "half integers" begin
        @testset "Odd" begin
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

            @test half(Odd(typemax(Int))) + half(Odd(typemax(Int))) == typemax(Int)
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

            @test half(Even(typemin(Int))) - half(Even(2)) == (typemin(Int) >> 1) - 1
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
        end
    end
end
