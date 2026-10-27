#!/usr/bin/env bash
# start.sh — เปิดเซิร์ฟเวอร์ Paper อย่างปลอดภัย (โปรเจกต์ 05-paper-server)
# ใช้: ./start.sh [--test] [--ram 2G] [--detach] [--help]
# หลักการความปลอดภัย: ตรวจให้ครบก่อนเปิด, ไม่เปิดซ้อน, เตือนเรื่องการปิดผิดวิธี

set -uo pipefail

SERVER_DIR="${MMA_SERVER_DIR:-$HOME/minecraft-mmo-dev/server}"
RAM="2G"
TEST_ONLY=0
DETACH=0
REQUIRED_JAVA=25
MC_PORT=25565

usage() {
    cat <<EOF
start.sh — เปิดเซิร์ฟเวอร์ Paper

วิธีใช้:
  ./start.sh               ตรวจสภาพแวดล้อมแล้วเปิดเซิร์ฟเวอร์
  ./start.sh --test        ตรวจเท่านั้น (ไม่เปิดเซิร์ฟเวอร์)
  ./start.sh --ram 4G      กำหนด RAM ให้เซิร์ฟเวอร์
  ./start.sh --detach      เปิดแบบเบื้องหลัง เก็บ log ที่ server-console.log

โฟลเดอร์เซิร์ฟเวอร์: $SERVER_DIR
(เปลี่ยนได้โดยตั้งค่า MMA_SERVER_DIR ก่อนรัน)
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --test) TEST_ONLY=1 ;;
        --detach) DETACH=1 ;;
        --ram) shift; RAM="${1:-2G}" ;;
        --help|-h) usage; exit 0 ;;
        *) echo "ไม่รู้จักตัวเลือก: $1"; usage; exit 2 ;;
    esac
    shift
done

PROBLEMS=0
bad()  { echo "❌ $1"; PROBLEMS=$((PROBLEMS + 1)); }
good() { echo "✅ $1"; }
warn() { echo "⚠️  $1"; }

echo "=========================================="
echo " Paper Start — Eclipse MMO RPG Academy"
echo "=========================================="
echo "โฟลเดอร์: $SERVER_DIR"
echo "RAM: $RAM"
echo

if [ ! -d "$SERVER_DIR" ]; then
    bad "ไม่พบโฟลเดอร์เซิร์ฟเวอร์ — สร้างด้วย: mkdir -p \"$SERVER_DIR\""
    exit 1
fi
cd "$SERVER_DIR" || exit 1

# --- หาไฟล์เซิร์ฟเวอร์ ---
JAR=""
if compgen -G "paper-*.jar" >/dev/null; then
    JAR="$(ls -1 paper-*.jar | sort | tail -1)"
    good "พบไฟล์เซิร์ฟเวอร์: $JAR"
else
    bad "ไม่พบไฟล์ paper-*.jar"
    echo "    ดาวน์โหลดจาก https://fill.papermc.io/v3/projects/paper/versions/26.3/builds"
    echo "    (เลือกช่อง STABLE) แล้ววางไว้ใน $SERVER_DIR"
fi

# --- Java ---
if command -v java >/dev/null 2>&1; then
    MAJOR=$(java -version 2>&1 | head -1 | sed -E 's/.*version "([0-9]+).*/\1/')
    if [ "$MAJOR" = "$REQUIRED_JAVA" ]; then
        good "Java $MAJOR"
    else
        bad "Java ที่พบคือ ${MAJOR:-?} แต่ Paper 26.x ต้องใช้ Java $REQUIRED_JAVA"
    fi
else
    bad "ไม่พบคำสั่ง java"
fi

# --- EULA ---
EULA_OK=0
if [ -f eula.txt ] && grep -qi '^eula=true' eula.txt; then
    good "ยอมรับ EULA แล้ว"
    EULA_OK=1
else
    warn "ยังไม่ยอมรับ EULA — อ่าน https://aka.ms/MinecraftEULA แล้วสร้าง eula.txt ที่มีบรรทัด eula=true"
fi

# --- พอร์ต ---
if command -v ss >/dev/null 2>&1; then
    if ss -tuln 2>/dev/null | grep -q ":${MC_PORT} "; then
        bad "พอร์ต $MC_PORT ถูกใช้อยู่ — ปิดเซิร์ฟเวอร์ตัวเก่าก่อน (ห้ามเปิดซ้อน)"
    else
        good "พอร์ต $MC_PORT ว่าง"
    fi
else
    warn "ไม่พบคำสั่ง ss — ข้ามการตรวจพอร์ต"
fi

# --- พื้นที่ดิสก์ ---
AVAIL_GB=$(df -Pk . | awk 'NR==2 {printf "%.1f", $4/1024/1024}')
if awk -v a="$AVAIL_GB" 'BEGIN{exit !(a >= 5)}'; then
    good "พื้นที่ว่าง ${AVAIL_GB} GB"
else
    bad "พื้นที่ว่างเหลือ ${AVAIL_GB} GB (ควรมีอย่างน้อย 5 GB)"
fi

echo
echo "ℹ️  การปิดเซิร์ฟเวอร์: พิมพ์คำสั่ง  stop  ในคอนโซลเสมอ"
echo "    ห้ามใช้ kill -9 — อาจทำให้โลกและข้อมูลเสียหาย"
echo

# ในโหมด --test ถือว่า EULA ที่ยังไม่ตั้งเป็นเพียงคำเตือน (เพราะยังไม่ได้เปิดจริง)
if [ "$PROBLEMS" -gt 0 ]; then
    echo "⛔ พบปัญหา $PROBLEMS รายการ — แก้ก่อนเปิดเซิร์ฟเวอร์"
    exit 1
fi

if [ "$TEST_ONLY" -eq 1 ]; then
    echo "✅ ตรวจสภาพแวดล้อมผ่านทั้งหมด (โหมด --test: ไม่ได้เปิดเซิร์ฟเวอร์)"
    [ "$EULA_OK" -eq 1 ] || echo "   ⚠️  อย่าลืมตั้ง eula=true ก่อนเปิดจริง"
    exit 0
fi

if [ "$EULA_OK" -eq 0 ]; then
    echo "⛔ ยังไม่ได้ยอมรับ EULA — เซิร์ฟเวอร์จะปิดตัวเองทันทีถ้าเปิดตอนนี้"
    exit 1
fi

JVM_ARGS=(-Xms512M "-Xmx$RAM" -XX:+UseG1GC)

if [ "$DETACH" -eq 1 ]; then
    LOG="server-console.log"
    nohup java "${JVM_ARGS[@]}" -jar "$JAR" nogui >> "$LOG" 2>&1 &
    echo "▶️  เปิดแบบเบื้องหลัง PID $!"
    echo "    ดู log: tail -f \"$SERVER_DIR/$LOG\""
    echo "    ⚠️  โหมดนี้พิมพ์ stop ไม่ได้ — งานจริงให้ใช้ tmux/screen"
    exit 0
fi

echo "▶️  กำลังเปิดเซิร์ฟเวอร์ (พิมพ์ stop เพื่อปิดอย่างปลอดภัย)"
exec java "${JVM_ARGS[@]}" -jar "$JAR" nogui
