#!/usr/bin/env bash
# damage-sim.sh — จำลองการต่อสู้ระหว่าง 2 ตัวละคร
# ใช้: ./damage-sim.sh [--rounds N] [--max-turns N] [--seed N] [--write-log] [--help]
#
# สอน: ลูปจนถึงเงื่อนไขจบ, ฟังก์ชัน (และ "ผลลัพธ์ผ่านตัวแปร" แทนการ return หลายค่า),
#      การคำนวณทศนิยม, การทำให้ผลซ้ำได้ด้วย seed, ความต่างระหว่าง
#      "ผลลัพธ์ของเกม" กับ "รหัสออกของโปรแกรม" (exit code)
#
# กติกาการคืนค่า (สำคัญ): script นี้ exit 0 = จำลองสำเร็จ
#   ส่วน "แพ้/ชนะ" เป็นผลลัพธ์ของเกม ไม่ใช่ความผิดพลาด
#   (ถ้าใช้ exit code แทนผลเกม จะเอาไปต่อกับ && / || ลำบาก)

set -uo pipefail

SEED=""
ROUNDS=1          # จำนวนการต่อสู้ที่จำลอง
MAX_TURNS=50      # เทิร์นสูงสุดต่อการต่อสู้ 1 ครั้ง
LOG_FILE="${MMA_WORK_DIR:-$HOME}/minecraft-mmo-dev/notes/combat-log.txt"
WRITE_LOG=0

# ---------- ค่าของตัวละคร 2 ฝ่าย ----------
# รูปแบบ: ชื่อ:เลือด:โจมตี:ป้องกัน:โอกาสคริติคอล(%)
HERO="นักรบ:120:18:6:20"
BOSS="โกเลมโบราณ:260:14:10:10"

# ผลลัพธ์ของการต่อสู้ครั้งล่าสุด (ตั้งค่าโดย fight) — ค่า: win | loss | draw
RESULT=""

usage() {
    cat <<'EOF'
damage-sim.sh — จำลองการต่อสู้

วิธีใช้:
  ./damage-sim.sh                      ต่อสู้ 1 รอบ (เทิร์นสูงสุด 50)
  ./damage-sim.sh --rounds 20          จำลอง 20 รอบ แล้วสรุปผล
  ./damage-sim.sh --max-turns 200      เพิ่มเทิร์นสูงสุดต่อรอบ
  ./damage-sim.sh --seed 42            ผลซ้ำได้ทุกครั้ง (ใช้ทดสอบ/แก้บั๊ก)
  ./damage-sim.sh --write-log          บันทึกผลลง notes/combat-log.txt
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --seed) shift; SEED="${1:-}" ;;
        --rounds) shift; ROUNDS="${1:-1}" ;;
        --max-turns) shift; MAX_TURNS="${1:-50}" ;;
        --log) shift; LOG_FILE="${1:-}" ;;
        --write-log) WRITE_LOG=1 ;;
        --help|-h) usage; exit 0 ;;
        *) echo "ไม่รู้จักตัวเลือก: $1"; usage; exit 2 ;;
    esac
    shift
done
case "$ROUNDS" in ''|*[!0-9]*) echo "❌ --rounds ต้องเป็นตัวเลข"; exit 2 ;; esac
case "$MAX_TURNS" in ''|*[!0-9]*) echo "❌ --max-turns ต้องเป็นตัวเลข"; exit 2 ;; esac
[ "$ROUNDS" -lt 1 ] && { echo "❌ --rounds ต้องมากกว่า 0"; exit 2; }
[ "$MAX_TURNS" -lt 1 ] && { echo "❌ --max-turns ต้องมากกว่า 0"; exit 2; }

[ -n "$SEED" ] && RANDOM="$SEED"

# ---------- ฟังก์ชันช่วย ----------
get_field() { echo "$1" | cut -d: -f"$2"; }

# คำนวณดาเมจ: (โจมตี - ป้องกัน/2) ปัดเป็นจำนวนเต็ม, ต่ำสุด 1, ถ้าคริติคอลคูณ 2
# คืนค่าเป็น "ดาเมจ คริติคอล" เช่น "26 1"
calc_damage() {
    local atk="$1" def="$2" crit_chance="$3"
    local base is_crit=0
    base=$(awk -v a="$atk" -v d="$def" 'BEGIN{ v = a - d/2; if (v < 1) v = 1; printf "%d", v }')
    if [ $(( RANDOM % 100 + 1 )) -le "$crit_chance" ]; then
        is_crit=1
        base=$(( base * 2 ))
    fi
    echo "$base $is_crit"
}

# ต่อสู้ 1 ครั้ง — ตั้งค่า RESULT เป็น win/loss/draw และคืนค่า exit code 0 เสมอ
fight() {
    local hero_name hero_hp hero_atk hero_def hero_crit
    local boss_name boss_hp boss_atk boss_def boss_crit
    hero_name=$(get_field "$HERO" 1); hero_hp=$(get_field "$HERO" 2)
    hero_atk=$(get_field "$HERO" 3);  hero_def=$(get_field "$HERO" 4); hero_crit=$(get_field "$HERO" 5)
    boss_name=$(get_field "$BOSS" 1); boss_hp=$(get_field "$BOSS" 2)
    boss_atk=$(get_field "$BOSS" 3);  boss_def=$(get_field "$BOSS" 4); boss_crit=$(get_field "$BOSS" 5)

    echo "=== การต่อสู้: $hero_name (HP $hero_hp) vs $boss_name (HP $boss_hp) ==="
    local turn=0 dmg crit
    while [ "$hero_hp" -gt 0 ] && [ "$boss_hp" -gt 0 ] && [ "$turn" -lt "$MAX_TURNS" ]; do
        turn=$(( turn + 1 ))

        read -r dmg crit <<< "$(calc_damage "$hero_atk" "$boss_def" "$hero_crit")"
        boss_hp=$(( boss_hp - dmg )); [ "$boss_hp" -lt 0 ] && boss_hp=0
        printf "เทิร์น %3d: %s ตี %s ดาเมจ %3d%s → HP บอสเหลือ %d\n" \
            "$turn" "$hero_name" "$boss_name" "$dmg" \
            "$([ "$crit" -eq 1 ] && echo ' (คริติคอล!)' || echo '')" "$boss_hp"
        [ "$boss_hp" -le 0 ] && break

        read -r dmg crit <<< "$(calc_damage "$boss_atk" "$hero_def" "$boss_crit")"
        hero_hp=$(( hero_hp - dmg )); [ "$hero_hp" -lt 0 ] && hero_hp=0
        printf "           %s ตี %s ดาเมจ %3d%s → HP เราเหลือ %d\n" \
            "$boss_name" "$hero_name" "$dmg" \
            "$([ "$crit" -eq 1 ] && echo ' (คริติคอล!)' || echo '')" "$hero_hp"
    done

    if [ "$boss_hp" -le 0 ]; then
        RESULT="win"
        echo "ผลลัพธ์: 🏆 $hero_name ชนะในเทิร์นที่ $turn (เหลือ HP $hero_hp)"
    elif [ "$hero_hp" -le 0 ]; then
        RESULT="loss"
        echo "ผลลัพธ์: ☠️  $hero_name พ่ายแพ้ในเทิร์นที่ $turn"
    else
        RESULT="draw"
        echo "ผลลัพธ์: ⏱️  ครบ $MAX_TURNS เทิร์นแล้วยังไม่จบ — ต้องปรับสมดุล (ดาเมจน้อยเกินไป?)"
    fi
    return 0
}

echo "=========================================="
echo " Damage Simulator — Eclipse MMO RPG Academy"
echo "=========================================="
echo "seed: ${SEED:-(สุ่มเอง)} | จำนวนรอบ: $ROUNDS | เทิร์นสูงสุดต่อรอบ: $MAX_TURNS"
echo

if [ "$ROUNDS" -eq 1 ]; then
    fight
    exit 0        # exit 0 = จำลองสำเร็จ (ผลแพ้/ชนะไม่ใช่ error)
fi

WINS=0; LOSSES=0; DRAWS=0
for (( r=1; r<=ROUNDS; r++ )); do
    echo "--- รอบที่ $r/$ROUNDS ---"
    fight
    case "$RESULT" in
        win)  WINS=$(( WINS + 1 )) ;;
        loss) LOSSES=$(( LOSSES + 1 )) ;;
        *)    DRAWS=$(( DRAWS + 1 )) ;;
    esac
    echo
done

echo "--- สรุป $ROUNDS รอบ ---"
echo "ชนะ: $WINS | แพ้: $LOSSES | ไม่จบเทิร์น: $DRAWS"
awk -v w="$WINS" -v r="$ROUNDS" 'BEGIN{printf "อัตราชนะ: %.1f%%\n", (w/r)*100}'

if [ "$WRITE_LOG" -eq 1 ]; then
    mkdir -p "$(dirname "$LOG_FILE")"
    {
        echo "=== $(date '+%Y-%m-%d %H:%M:%S') seed=${SEED:-random} rounds=$ROUNDS max_turns=$MAX_TURNS ==="
        echo "ชนะ $WINS / แพ้ $LOSSES / ไม่จบเทิร์น $DRAWS"
    } >> "$LOG_FILE"
    echo "📝 บันทึกผลลง $LOG_FILE แล้ว"
fi
exit 0
