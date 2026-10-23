include(joinpath(@__DIR__, "src", "detai.jl"))
using .DeTai
using Printf

function in_ket_qua(A)
    kq = chia_hai_nhom(A)
    println("================================================================")
    println("DT057 - CHIA MANG THANH HAI NHOM CHENH TONG IT NHAT")
    println("Sinh vien: Vo Tan Phat | MSSV: N24DCDT067")
    println("================================================================")
    println("Mang dau vao A: ", kq.A)
    println("So phan tu n = $(kq.n), Tong mang S = $(kq.S), Nua tong W = $(kq.W)")
    println("Tong dat duoc tot nhat cho Nhom 1 (<= W): $(kq.best_sum)")
    println("----------------------------------------------------------------")
    
    # In bảng DP nếu kích thước nhỏ
    if kq.W <= 20 && kq.n <= 10
        in_bang_dp(kq)
    end
    
    val1 = isempty(kq.nhom1) ? Int[] : kq.A[kq.nhom1]
    val2 = isempty(kq.nhom2) ? Int[] : kq.A[kq.nhom2]
    
    println("Nhom 1: ")
    println("  - Danh sach chi so (ID): ", kq.nhom1)
    println("  - Cac gia tri tuong ung: ", val1)
    println("  - Tong nhom 1: ", kq.tong1)
    println("Nhom 2: ")
    println("  - Danh sach chi so (ID): ", kq.nhom2)
    println("  - Cac gia tri tuong ung: ", val2)
    println("  - Tong nhom 2: ", kq.tong2)
    println("----------------------------------------------------------------")
    println("DO CHENH LECH: |$(kq.tong1) - $(kq.tong2)| = $(kq.chenh)")
    println("Kiem tra bat bien ID: ", sort(vcat(kq.nhom1, kq.nhom2)) == collect(1:kq.n) ? "DUNG" : "SAI")
    println("Kiem tra bao toan tong: ", kq.tong1 + kq.tong2 == kq.S ? "DUNG" : "SAI")
    println("================================================================\n")
    return kq
end

function nhap_ban_phim()
    println("Nhap so phan tu n:")
    n_str = readline()
    n = parse(Int, strip(n_str))
    n >= 0 || throw(ArgumentError("n phai khong am"))
    if n == 0
        in_ket_qua(Int[])
        return
    end
    println("Nhap $n so nguyen cach nhau boi dau cach (vi du: 1 6 11 5):")
    line = readline()
    A = parse.(Int, split(line))
    length(A) == n || throw(ArgumentError("Can nhap dung $n so"))
    in_ket_qua(A)
end

function minh_hoa_du_lieu_sai()
    println("DT057 - MINH HOA TU CHOI DU LIEU KHONG HOP LE")
    println("Mang thu nghiem A = [2, -5, 3]")
    println("Mong doi: Tu choi vi chua phan tu am -5.")
    try
        chia_hai_nhom([2, -5, 3])
    catch loi
        if loi isa ArgumentError && occursin("khong duoc am", sprint(showerror, loi))
            println("DA TU CHOI DU LIEU: ", sprint(showerror, loi))
            println("KET QUA MINH HOA: DUNG; loi du kien da duoc bat thanh cong.")
            return nothing
        end
        rethrow()
    end
    error("LOI: Chuong trinh da khong bat duoc phan tu am")
end

if "--nhap" in ARGS
    nhap_ban_phim()
elseif any(startswith("--ca="), ARGS)
    ca = only(filter(startswith("--ca="), ARGS))
    if ca == "--ca=1"
        in_ket_qua([1, 6, 11, 5])
    elseif ca == "--ca=2"
        in_ket_qua([2, 2])
    elseif ca == "--ca=3"
        in_ket_qua([3, 1, 1, 2, 2, 1])
    elseif ca == "--ca=4"
        in_ket_qua([10, 20, 15, 5, 25])
    elseif ca == "--ca=5"
        in_ket_qua([1, 1, 1])
    elseif ca == "--ca=6"
        in_ket_qua([0, 0, 3])
    elseif ca == "--ca=7"
        in_ket_qua(Int[])
    elseif ca == "--ca=8"
        minh_hoa_du_lieu_sai()
    else
        throw(ArgumentError("Chon --ca=1 den --ca=8"))
    end
else
    # Mac dinh chay 2 vi du tren phieu DT057
    println("--- VI DU 1 TREN PHIEU DT057 ---")
    in_ket_qua([1, 6, 11, 5])
    println("\n--- VI DU 2 TREN PHIEU DT057 ---")
    in_ket_qua([2, 2])
end
