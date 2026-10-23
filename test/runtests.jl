using Test
include(joinpath(@__DIR__, "..", "src", "detai.jl"))
using .DeTai

@testset "DT057 - 12 ca kiem thu doc lap - Vo Tan Phat" begin
    # T01 (A01 - Vi du 1 tren phieu): [1, 6, 11, 5] -> Chenh 1
    let kq = chia_hai_nhom([1, 6, 11, 5])
        @test kq.chenh == 1
        @test (kq.tong1 == 11 && kq.tong2 == 12) || (kq.tong1 == 12 && kq.tong2 == 11)
        @test sort(vcat(kq.nhom1, kq.nhom2)) == [1, 2, 3, 4]
    end

    # T02 (A02 - Vi du 2 tren phieu): [2, 2] -> Chenh 0
    let kq = chia_hai_nhom([2, 2])
        @test kq.chenh == 0
        @test kq.tong1 == 2 && kq.tong2 == 2
        @test length(kq.nhom1) == 1 && length(kq.nhom2) == 1
        @test sort(vcat(kq.nhom1, kq.nhom2)) == [1, 2]
    end

    # T03 (A03 - Tu thiet ke 1 - Mang chan tong): [3, 1, 1, 2, 2, 1] -> Tong 10 -> Chenh 0
    let kq = chia_hai_nhom([3, 1, 1, 2, 2, 1])
        @test kq.chenh == 0
        @test kq.tong1 == 5 && kq.tong2 == 5
        @test sort(vcat(kq.nhom1, kq.nhom2)) == collect(1:6)
    end

    # T04 (A04 - Tu thiet ke 2 - Mang boi so cua 5): [10, 20, 15, 5, 25] -> Tong 75 -> Chenh 5 (35 va 40)
    let kq = chia_hai_nhom([10, 20, 15, 5, 25])
        @test kq.chenh == 5
        @test (kq.tong1 == 35 && kq.tong2 == 40) || (kq.tong1 == 40 && kq.tong2 == 35)
        @test sort(vcat(kq.nhom1, kq.nhom2)) == collect(1:5)
    end

    # T05 (A05 - Ca bien 1 - 3 phan tu bang nhau): [1, 1, 1] -> Chenh 1
    let kq = chia_hai_nhom([1, 1, 1])
        @test kq.chenh == 1
        @test sort(vcat(kq.nhom1, kq.nhom2)) == [1, 2, 3]
    end

    # T06 (A06 - Ca bien 2 - Mang chua so 0): [0, 0, 3] -> Du 3 ID, Chenh 3
    let kq = chia_hai_nhom([0, 0, 3])
        @test kq.chenh == 3
        @test length(kq.nhom1) + length(kq.nhom2) == 3
        @test sort(vcat(kq.nhom1, kq.nhom2)) == [1, 2, 3]
    end

    # T07 (A07 - Ca bien 3 - Mang rong): [] -> Chenh 0
    let kq = chia_hai_nhom(Int[])
        @test kq.chenh == 0
        @test kq.tong1 == 0 && kq.tong2 == 0
        @test isempty(kq.nhom1) && isempty(kq.nhom2)
    end

    # T08 (Ca bien 4 - Mang chi 1 phan tu): [7] -> Chenh 7
    let kq = chia_hai_nhom([7])
        @test kq.chenh == 7
        @test sort(vcat(kq.nhom1, kq.nhom2)) == [1]
    end

    # T09 (Ca bien 5 - Mang toan so giong nhau chan): [5, 5, 5, 5] -> Chenh 0
    let kq = chia_hai_nhom([5, 5, 5, 5])
        @test kq.chenh == 0
        @test kq.tong1 == 10 && kq.tong2 == 10
    end

    # T10 (Quy mo nho 7 phan tu): [1, 2, 3, 4, 5, 6, 7] -> Tong 28 -> Chenh 0
    let kq = chia_hai_nhom(collect(1:7))
        @test kq.chenh == 0
        @test kq.tong1 == 14 && kq.tong2 == 14
        @test sort(vcat(kq.nhom1, kq.nhom2)) == collect(1:7)
    end

    # T11 (Quy mo trung binh 20 phan tu):
    let arr = [i % 7 + 1 for i in 1:20]
        kq = chia_hai_nhom(arr)
        @test kq.chenh <= 1
        @test sort(vcat(kq.nhom1, kq.nhom2)) == collect(1:20)
        @test kq.tong1 + kq.tong2 == sum(arr)
    end

    # T12 (A08 - Validator kiem tra phan tu am bi tu choi):
    @test_throws ArgumentError kiem_tra_hop_le([2, -5, 3])
    @test_throws ArgumentError chia_hai_nhom([1, 6, -11, 5])
end
