#!/usr/bin/env bash
# exp-curve.sh — คำนวณ EXP ที่ต้องใช้ในแต่ละเลเวล และเทียบสูตร 2 แบบ
# ใช้: ./exp-curve.sh [เลเวลเริ่ม] [เลเวลจบ] | ./exp-curve.sh --compare | --help
# สอน: ลูปคำนวณ, ฟังก์ชันคณิตศาสตร์, การใช้ awk คำนวณทศนิยม, การเทียบสูตรเกม

set -uo pipefail

LINEAR_BASE=100     # สูตรเส้นตรง: EXP = 100 × level
POWER_BASE=100      # สูตรทวีคูณ: EXP = 100 × level^1.5

usage() {
    cat <<'EOF'
exp-curve.sh — ตาราง EXP ของแต่ละเลเวล

วิธีใช้:
  ./exp-curve.sh 1 10         แสดงตารางเลเวล 1 ถึง 10
  ./exp-curve.sh 50 60        แสดงตารางเลเวล 50 ถึง 60
  ./exp-curve.sh --compare    เทียบสูตรเส้นตรงกับสูตรทวีคูณ (เลเวล 1-30)
EOF
}

exp_linear() { awk -v l="$1" -v b="$LINEAR_BASE" 'BEGIN{printf "%d", b*l}'; }
exp_power()  { awk -v l="$1" -v b="$POWER_BASE"  'BEGIN{printf "%d", b*(l^1.5)}'; }
cum()        { awk -v e="$1" 'BEGIN{printf "%d", e/1000}'; }   # แปลงเป็น "พัน EXP" แบบคร่าว ๆ

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then usage; exit 0; fi

if [ "${1:-}" = "--compare" ]; then
    echo "=========================================="
    echo " EXP Curve เปรียบเทียบ 2 สูตร"
    echo "=========================================="
    printf "%-8s %14s %14s %10s\n" "เลเวล" "เส้นตรง(EXP)" "ทวีคูณ(EXP)" "ต่างกี่เท่า"
    TOTAL_L=0; TOTAL_P=0
    for lvl in $(seq 1 30); do
        L=$(exp_linear "$lvl"); P=$(exp_power "$lvl")
        TOTAL_L=$(( TOTAL_L + L )); TOTAL_P=$(( TOTAL_P + P ))
        RATIO=$(awk -v l="$L" -v p="$P" 'BEGIN{printf "%.2f", p/l}')
        [ $(( lvl % 5 )) -eq 0 ] || [ "$lvl" -le 10 ] && printf "%-8s %14s %14s %10s\n" "$lvl" "$L" "$P" "$RATIO"
    done
    echo
    echo "EXP รวมถึงเลเวล 30:"
    echo "  สูตรเส้นตรง : $TOTAL_L"
    echo "  สูตรทวีคูณ  : $TOTAL_P"
    echo
    echo "💡 สังเกต: สูตรทวีคูณทำให้เลเวลสูงใช้เวลานานขึ้นมาก — เหมาะกับ MMO"
    echo "   แต่ต้องทดสอบกับผู้เล่นจริงว่าไต่เร็ว/ช้าเกินไปหรือไม่ (Month 9-10)"
    exit 0
fi

START="${1:-1}"
END="${2:-10}"
case "$START" in ''|*[!0-9]*) echo "❌ เลเวลเริ่มต้องเป็นตัวเลข"; exit 2 ;; esac
case "$END"   in ''|*[!0-9]*) echo "❌ เลเวลจบต้องเป็นตัวเลข"; exit 2 ;; esac
[ "$START" -lt 1 ] && { echo "❌ เลเวลเริ่มต้องมากกว่า 0"; exit 2; }
[ "$END" -lt "$START" ] && { echo "❌ เลเวลจบต้องไม่น้อยกว่าเลเวลเริ่ม"; exit 2; }

echo "=========================================="
echo " EXP Curve — Eclipse MMO RPG Academy"
echo "=========================================="
printf "%-8s %14s %14s %16s\n" "เลเวล" "EXP ต่อเลเวล" "EXP สะสม" "เลเวลถัดไปต้องใช้"

TOTAL=0
for lvl in $(seq "$START" "$END"); do
    E=$(exp_power "$lvl")
    TOTAL=$(( TOTAL + E ))
    NEXT=$(exp_power $(( lvl + 1 )))
    printf "%-8s %14s %14s %16s\n" "$lvl" "$E" "$TOTAL" "$NEXT"
done
echo
echo "EXP รวมจากเลเวล $START ถึง $END = $TOTAL"
echo "💡 ตรวจสอบ: ไม่มีค่าติดลบ และค่าสูงขึ้นตามเลเวล (ถ้าลดลง แสดงว่าสูตรผิด)"
