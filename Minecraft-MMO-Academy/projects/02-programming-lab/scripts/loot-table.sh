#!/usr/bin/env bash
# loot-table.sh — ระบบสุ่มรางวัลแบบมีน้ำหนัก (weighted random)
# ใช้: ./loot-table.sh [จำนวนครั้ง] [--seed N] [--summary] [--help]
# สอน: ตัวแปร, อาร์เรย์คู่กัน, ลูป, เงื่อนไข, ฟังก์ชัน, การตรวจสอบข้อมูล, ความน่าเชื่อถือของผลทดสอบ

set -uo pipefail

# ---------- ตารางไอเทม (น้ำหนักรวมควรเป็น 100 แต่ script ทำงานกับผลรวมเท่าไรก็ได้) ----------
ITEMS=("เหล็ก" "ถ่านหิน" "ทอง" "อัญมณี" "ไอเทม Epic")
WEIGHTS=(40 30 18 9 3)   # ผลรวม = 100

ROLLS=10
SEED=""
SUMMARY=0

usage() {
    cat <<'EOF'
loot-table.sh — สุ่มรางวัลตามน้ำหนัก

วิธีใช้:
  ./loot-table.sh                 สุ่ม 10 ครั้ง
  ./loot-table.sh 1000            สุ่ม 1000 ครั้ง
  ./loot-table.sh 1000 --summary  สุ่มแล้วสรุปสัดส่วนที่ได้
  ./loot-table.sh --seed 42       ใช้ seed คงที่ (ผลซ้ำได้ทุกครั้ง)
EOF
}

# ---------- อ่าน argument ----------
while [ $# -gt 0 ]; do
    case "$1" in
        --seed) shift; SEED="${1:-}" ;;
        --summary) SUMMARY=1 ;;
        --help|-h) usage; exit 0 ;;
        ''|*[!0-9]*) echo "ไม่รู้จักตัวเลือกหรือจำนวนครั้งไม่ถูกต้อง: $1"; usage; exit 2 ;;
        *) ROLLS="$1" ;;
    esac
    shift
done
[ "$ROLLS" -lt 1 ] && { echo "❌ จำนวนครั้งต้องมากกว่า 0"; exit 2; }

# ---------- ตรวจสอบตารางก่อนใช้งาน (สำคัญ: ห้ามใช้ข้อมูลที่ยังไม่ตรวจ) ----------
TOTAL_WEIGHT=0
for w in "${WEIGHTS[@]}"; do
    if [ "$w" -lt 0 ]; then
        echo "❌ น้ำหนักติดลบ ($w) — ตรวจตารางไอเทมก่อนใช้งาน"
        exit 1
    fi
    TOTAL_WEIGHT=$((TOTAL_WEIGHT + w))
done
if [ "$TOTAL_WEIGHT" -le 0 ]; then
    echo "❌ น้ำหนักรวมเป็น 0 — สุ่มไม่ได้ (จะเกิดการหารด้วยศูนย์)"
    exit 1
fi

echo "=========================================="
echo " Loot Table — Eclipse MMO RPG Academy"
echo "=========================================="
echo "ตารางไอเทม (น้ำหนักรวม $TOTAL_WEIGHT):"
for i in "${!ITEMS[@]}"; do
    # คำนวณโอกาสเป็นเปอร์เซ็นต์ (ทศนิยม 1 ตำแหน่ง) ด้วย awk
    PCT=$(awk -v w="${WEIGHTS[$i]}" -v t="$TOTAL_WEIGHT" 'BEGIN{printf "%.1f", (w/t)*100}')
    printf "  - %-12s น้ำหนัก %3s  (%.1f%%)\n" "${ITEMS[$i]}" "${WEIGHTS[$i]}" "$PCT"
done
echo

# ---------- ตัวสุ่ม: ใช้ $RANDOM + seed สำหรับการทดสอบ ----------
if [ -n "$SEED" ]; then
    RANDOM="$SEED"
    echo "โหมดทดสอบ: ใช้ seed = $SEED (ผลจะซ้ำได้)"
    echo
fi

# ตัวนับผลลัพธ์ (index ตรงกับ ITEMS)
COUNTS=()
for _ in "${ITEMS[@]}"; do COUNTS+=(0); done

roll_once() {
    # สุ่ม 1 ครั้ง: ได้หมายเลข 1..TOTAL_WEIGHT แล้วไล่หาช่วงของไอเทม
    local r=$(( RANDOM % TOTAL_WEIGHT + 1 ))
    local cumulative=0
    for i in "${!WEIGHTS[@]}"; do
        cumulative=$(( cumulative + WEIGHTS[i] ))
        if [ "$r" -le "$cumulative" ]; then
            echo "$i"
            return
        fi
    done
    echo $(( ${#ITEMS[@]} - 1 ))   # fallback: กรณีเศษปัด (กันพัง)
}

for (( n=1; n<=ROLLS; n++ )); do
    IDX=$(roll_once)
    COUNTS[IDX]=$(( COUNTS[IDX] + 1 ))
    if [ "$SUMMARY" -eq 0 ] && [ "$ROLLS" -le 30 ]; then
        printf "ครั้งที่ %3d: %s\n" "$n" "${ITEMS[$IDX]}"
    fi
done

if [ "$SUMMARY" -eq 1 ] || [ "$ROLLS" -gt 30 ]; then
    echo "--- สรุปผลการสุ่ม $ROLLS ครั้ง ---"
    printf "%-14s %8s %10s %12s\n" "ไอเทม" "จำนวน" "ได้จริง(%)" "ออกแบบ(%)"
    for i in "${!ITEMS[@]}"; do
        GOT_PCT=$(awk -v c="${COUNTS[$i]}" -v r="$ROLLS" 'BEGIN{printf "%.1f", (c/r)*100}')
        EXP_PCT=$(awk -v w="${WEIGHTS[$i]}" -v t="$TOTAL_WEIGHT" 'BEGIN{printf "%.1f", (w/t)*100}')
        printf "%-14s %8d %10s %12s\n" "${ITEMS[$i]}" "${COUNTS[$i]}" "$GOT_PCT" "$EXP_PCT"
    done
    echo
    echo "💡 ค่า 'ได้จริง' ควรใกล้ 'ออกแบบ' แต่ไม่ต้องเท่ากัน — ถ้าต่างมากเกินไป (เช่น 2 เท่า)"
    echo "   ให้สุ่มจำนวนมากขึ้นแล้วดูใหม่ก่อนสรุปว่าตารางผิด"
fi
