using HalfOddIntegers
using HalfIntegers
using Test

using Aqua
@testset "project quality" begin
    Aqua.test_all(HalfOddIntegers)
end

@testset "HalfOddIntegers.jl" begin
    @testset "OddInt" begin
        @test_throws Exception OddInt(2)
        x = OddInt(3)
        @test x isa OddInt
        @test x == 3
        @test isodd(x)
        @test !iseven(x)
        @test !iszero(x)
        @test -x == -3
        @test OddInt(x) == x
        @test x == x == Int(x)
        @test !(x < x)
        @test !(x > x)
        @test x <= x
        @test x >= x
        @test (x >> 1) == 1
        @test (x << 1) == 6
        @test x * x == 9
        @test abs(-x) == abs(x) == 3
        @test Base.checked_abs(-x) == 3
        @test zero(x) == 0
        @test trailing_zeros(x) == 0
        @test rem(x, x) == 0
        @test div(x, x) == 1
        @test x + 2.0 == 5.0
        @test x + big(typemax(Int)) == big(3) + big(typemax(Int))
    end
    @testset "HalfOddInt" begin
        x = half(OddInt(3))
        @test x isa Half{OddInt}
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
        y = half(OddInt(5))
        @test x + y == 4
        @test x - y == -1
        @test x != 1
        @test 1 != x
        @test rem(x, x) == 0
    end
end
