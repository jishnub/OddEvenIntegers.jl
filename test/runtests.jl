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
        @test x == 3
        @test isodd(x)
        @test !iseven(x)
        @test !iszero(x)
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
        @test trailing_zeros(x) == 0
        @test rem(x, x) == 0
        @test div(x, x) == 1
        @test x + 2.0 == 5.0
        @test x + big(typemax(Int)) == big(3) + big(typemax(Int))
        @test twice(x) == 6

        @test Odd(big(typemax(Int))) + 1 == big(typemax(Int)) + 1
    end
    @testset "Even" begin
        @test_throws Exception Even(1)
        x = Even(4)
        @test x isa Even{Int}
        @test x == 4
        @test !isodd(x)
        @test iseven(x)
        @test !iszero(x)
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
        @test trailing_zeros(x) == 2
        @test rem(x, x) == 0
        @test div(x, x) == 1
        @test x + 2.0 == 6.0
        @test x + big(typemax(Int)) == big(4) + big(typemax(Int))
        @test twice(x) == 8

        @test Even(big(typemin(Int))) - 1 == big(typemin(Int)) - 1
    end
    @testset "Odd and Even" begin
        @test Odd(1) + Even(2) == Even(2) + Odd(1) == 3
        @test isodd(Odd(1) + Even(2))
        @test iseven(Odd(1) * Even(2))
        @test Odd(1) * Even(2) == 2
    end
    @testset "HalfOddInt" begin
        x = half(Odd(3))
        @test x isa Half{Odd{Int}}
        @test x == 3/2
        @test !isinteger(x)
        @test -x == -3/2
        @test x + 1 == 5/2
        @test x - 1 == 1/2
        @test 1 + x == 5/2
        @test 1 - x == -1/2
        @test x + x == 3
        @test x - x == 0
        @test x * x == (3/2)^2
        @test x / x ≈ 1
        y = half(Odd(5))
        @test x + y == 4
        @test x - y == -1
        @test x != 1
        @test 1 != x
        @test rem(x, x) == 0
    end
end
