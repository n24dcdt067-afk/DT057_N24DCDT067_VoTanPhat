param(
    [string]$Julia = "julia"
)

$ErrorActionPreference = "Stop"

Write-Host "=== DT057: CHIA MANG THANH HAI NHOM CHENH TONG IT NHAT ===" -ForegroundColor Cyan
Write-Host "Sinh vien: Vo Tan Phat - MSSV: N24DCDT067" -ForegroundColor Cyan
Write-Host "Kiem tra phien ban Julia..."
& $Julia --version

Write-Host "`n1. CHAY DEMO 2 VI DU TREN PHIEU GIAO..." -ForegroundColor Yellow
& $Julia demo.jl

Write-Host "`n2. CHAY BO KIEM THU 12 CA DOC LAP (test/runtests.jl)..." -ForegroundColor Yellow
& $Julia test/runtests.jl

Write-Host "`n=== TAT CA DA HOAN TAT THANH CONG! ===" -ForegroundColor Green
