module DeTai

export kiem_tra_hop_le, lap_bang_dp, chia_hai_nhom, in_bang_dp

"""
    kiem_tra_hop_le(A)

Kiểm tra tính hợp lệ của mảng đầu vào theo yêu cầu phiếu DT057:
- Các phần tử phải là số nguyên không âm.
- Mảng rỗng hoặc chứa số 0 là hợp lệ theo ca biên.
"""
function kiem_tra_hop_le(A)
    for (idx, x) in enumerate(A)
        x isa Integer || throw(ArgumentError("Phan tu tai vi tri $idx phai la so nguyen, nhan duoc: $x"))
        x >= 0 || throw(ArgumentError("Phan tu tai vi tri $idx khong duoc am: $x"))
    end
    return true
end

"""
    lap_bang_dp(A, W)

Xây dựng bảng Quy hoạch động dp kích thước (n+1) x (W+1).
dp[i+1, j+1] = true nếu có thể tạo tổng j từ tập con của i phần tử đầu tiên A[1:i].
Cơ sở: dp[1, 1] = true (tổng 0 từ 0 phần tử).
"""
function lap_bang_dp(A::Vector{Int}, W::Int)
    n = length(A)
    dp = fill(false, n + 1, W + 1)
    dp[1, 1] = true # i=0, j=0

    for i in 1:n
        val = A[i]
        for j in 0:W
            # Không chọn phần tử thứ i
            dp[i + 1, j + 1] = dp[i, j + 1]
            # Có chọn phần tử thứ i (nếu j >= val)
            if j >= val && dp[i, j - val + 1]
                dp[i + 1, j + 1] = true
            end
        end
    end
    return dp
end

"""
    chia_hai_nhom(A)

Giải bài toán chia mảng A thành hai nhóm chênh tổng ít nhất (DT057).
Trả về named tuple chứa:
- n: số phần tử
- A: mảng đầu vào
- S: tổng mảng
- W: nửa tổng floor(S/2)
- best_sum: tổng nhóm 1 (tổng con <= W lớn nhất)
- chenh: |tong1 - tong2|
- tong1: tổng các giá trị nhóm 1
- tong2: tổng các giá trị nhóm 2
- nhom1: danh sách chỉ số (1-based) thuộc nhóm 1
- nhom2: danh sách chỉ số (1-based) thuộc nhóm 2
- dp: bảng quy hoạch động
"""
function chia_hai_nhom(A::AbstractVector)
    kiem_tra_hop_le(A)
    A_int = Int.(A)
    n = length(A_int)

    # Ca biên mảng rỗng
    if n == 0
        dp_rong = fill(true, 1, 1)
        return (; n=0, A=A_int, S=0, W=0, best_sum=0, chenh=0,
                  tong1=0, tong2=0, nhom1=Int[], nhom2=Int[], dp=dp_rong)
    end

    S = sum(A_int)
    W = div(S, 2)
    dp = lap_bang_dp(A_int, W)

    # Tìm tổng lớn nhất j <= W sao cho dp[n+1, j+1] == true
    best_sum = 0
    for j in W:-1:0
        if dp[n + 1, j + 1]
            best_sum = j
            break
        end
    end

    # Truy vết tìm các chỉ số (ID) thuộc Nhóm 1 từ n về 1
    nhom1 = Int[]
    nhom2 = Int[]
    curr_j = best_sum

    for i in n:-1:1
        val = A_int[i]
        # Nếu không thể tạo curr_j từ i-1 phần tử đầu, thì bắt buộc phần tử i đã được chọn
        if curr_j >= val && dp[i, curr_j - val + 1] && !dp[i, curr_j + 1]
            push!(nhom1, i)
            curr_j -= val
        elseif curr_j >= val && dp[i, curr_j - val + 1] && dp[i, curr_j + 1]
            # Nếu cả hai nhánh đều đạt, ưu tiên nhánh lấy phần tử nếu curr_j > 0
            if val > 0 && curr_j >= val
                push!(nhom1, i)
                curr_j -= val
            else
                push!(nhom2, i)
            end
        else
            push!(nhom2, i)
        end
    end

    # Sắp xếp lại chỉ số tăng dần
    sort!(nhom1)
    sort!(nhom2)

    tong1 = isempty(nhom1) ? 0 : sum(A_int[nhom1])
    tong2 = isempty(nhom2) ? 0 : sum(A_int[nhom2])
    chenh = abs(tong1 - tong2)

    # Kiểm tra bất biến Rubric C2, C3, C4
    @assert sort(vcat(nhom1, nhom2)) == collect(1:n) "Moi ID phai thuoc dung mot nhom"
    @assert tong1 + tong2 == S "Tong hai nhom phai bang tong mang"
    @assert chenh == abs(tong1 - tong2) "Do chenh phai dung bang tri tuyet doi"

    return (; n, A=A_int, S, W, best_sum, chenh, tong1, tong2, nhom1, nhom2, dp)
end

"""
    in_bang_dp(kq; max_w=20)

In bảng Quy hoạch động và đường truy vết (dùng cho báo cáo và minh họa).
"""
function in_bang_dp(kq; max_w=20)
    dp = kq.dp
    n, W = kq.n, kq.W
    if W > max_w
        println("Bang DP qua lon de in day du (W=$W > $max_w). Chi hien thi tom tat.")
        return
    end
    println("--- BANG QUY HOACH DONG DP (Hang: i tu 0..n, Cot: j tu 0..W) ---")
    print(" i | A[i] |")
    for j in 0:W
        print(lpad(j, 4))
    end
    println()
    println("-" ^ (10 + (W + 1) * 4))

    for i in 0:n
        val_str = i == 0 ? "-" : string(kq.A[i])
        print(lpad(i, 2), " | ", lpad(val_str, 4), " |")
        for j in 0:W
            cell = dp[i + 1, j + 1] ? "  T " : "  . "
            print(cell)
        end
        println()
    end
    println("-" ^ (10 + (W + 1) * 4))
end

end # module DeTai

if abspath(PROGRAM_FILE) == @__FILE__
    using .DeTai
    println("================================================================")
    println("DT057 - CHIA MANG THANH HAI NHOM CHENH TONG IT NHAT")
    println("Sinh vien: Vo Tan Phat | MSSV: N24DCDT067")
    println("================================================================")

    println("\n>>> CHAY VI DU 1: A = [1, 6, 11, 5]")
    kq1 = chia_hai_nhom([1, 6, 11, 5])
    println("Tong mang S = $(kq1.S), Nua tong W = $(kq1.W)")
    in_bang_dp(kq1)
    println("Nhom 1 (ID): ", kq1.nhom1, " => Gia tri: ", kq1.A[kq1.nhom1], " => Tong: ", kq1.tong1)
    println("Nhom 2 (ID): ", kq1.nhom2, " => Gia tri: ", kq1.A[kq1.nhom2], " => Tong: ", kq1.tong2)
    println("Do chenh lech: |$(kq1.tong1) - $(kq1.tong2)| = $(kq1.chenh)")

    println("\n>>> CHAY VI DU 2: A = [2, 2]")
    kq2 = chia_hai_nhom([2, 2])
    println("Nhom 1 (ID): ", kq2.nhom1, " => Gia tri: ", kq2.A[kq2.nhom1], " => Tong: ", kq2.tong1)
    println("Nhom 2 (ID): ", kq2.nhom2, " => Gia tri: ", kq2.A[kq2.nhom2], " => Tong: ", kq2.tong2)
    println("Do chenh lech: |$(kq2.tong1) - $(kq2.tong2)| = $(kq2.chenh)")
    println("================================================================")
end
