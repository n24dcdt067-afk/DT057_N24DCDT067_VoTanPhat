# ĐỀ TÀI DT057: CHIA MẢNG THÀNH HAI NHÓM CHÊNH TỔNG ÍT NHẤT

- **Học phần**: Cấu trúc dữ liệu và giải thuật (INT13185 — Nhóm 03)
- **Sinh viên**: Võ Tấn Phát
- **MSSV**: `N24DCDT067`
- **Mã đề**: `DT057`
- **Ngôn ngữ thực hiện**: Julia (phiên bản `>= 1.10`, khuyến nghị `1.12.7`)
- **Thư viện sử dụng**: Thư viện chuẩn (`Test`, `Printf`). Không cần cài package ngoài.

---

## 1. Cấu trúc thư mục

```text
Khung_ma_nguon_ca_nhan/
├── src/
│   └── detai.jl        # Thuật toán Quy hoạch động, kiểm tra đầu vào và truy vết
├── test/
│   └── runtests.jl     # Bộ kiểm thử 12 ca độc lập (A01 - A08, biên, quy mô)
├── docs/
│   └── anh_ket_qua/    # Thư mục lưu 11 ảnh minh chứng A01 - A11
├── demo.jl             # Chương trình chạy tương tác, demo theo ca và in bảng DP
├── Run_all.ps1         # Script tự động chạy toàn bộ demo và test
└── README.md           # Tài liệu hướng dẫn sử dụng
```

---

## 2. Hướng dẫn chạy chương trình

### Cách 1: Chạy tự động toàn bộ bằng PowerShell
```powershell
.\Run_all.ps1
```

### Cách 2: Chạy trực tiếp qua lệnh Julia

1. **Chạy hai ví dụ trên phiếu giao (A01, A02):**
   ```powershell
   julia demo.jl
   ```

2. **Chạy chế độ nhập bàn phím:**
   ```powershell
   julia demo.jl --nhap
   ```
   *(Nhập số phần tử $n$, sau đó nhập các số nguyên cách nhau bởi dấu cách).*

3. **Chạy từng ca cụ thể để chụp ảnh minh chứng (A01 đến A08):**
   - Ca 1 (Ví dụ 1: `[1, 6, 11, 5]`): `julia demo.jl --ca=1`
   - Ca 2 (Ví dụ 2: `[2, 2]`): `julia demo.jl --ca=2`
   - Ca 3 (Tự thiết kế 1: `[3, 1, 1, 2, 2, 1]`): `julia demo.jl --ca=3`
   - Ca 4 (Tự thiết kế 2: `[10, 20, 15, 5, 25]`): `julia demo.jl --ca=4`
   - Ca 5 (Biên 1 - 3 số bằng nhau: `[1, 1, 1]`): `julia demo.jl --ca=5`
   - Ca 6 (Biên 2 - Chứa số 0: `[0, 0, 3]`): `julia demo.jl --ca=6`
   - Ca 7 (Biên 3 - Mảng rỗng: `[]`): `julia demo.jl --ca=7`
   - Ca 8 (Minh họa chặn dữ liệu sai - số âm): `julia demo.jl --ca=8`

4. **Chạy bộ kiểm thử 12 ca độc lập (A09):**
   ```powershell
   julia test/runtests.jl
   ```
