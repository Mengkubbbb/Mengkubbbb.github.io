#!/usr/bin/env bash
# server-start.sh — เปิดเซิร์ฟเวอร์ Paper อย่างปลอดภัย
# ใช้: ./server-start.sh [--test] [--ram <เช่น 2G>] [--detach] [--help]
# ความปลอดภัย: ถ้าไม่พบไฟล์เซิร์ฟเวอร์จะไม่พัง และจะบอกวิธีเตรียมให้
# หมายเหตุ: ตรวจเวอร์ชัน Paper ล่าสุดได้ที่ https://fill.papermc.io/v3/projects/paper/versions/

set -uo pipefail

WORK_DIR="${MMA_WORK_DIR:-$HOME/minecraft-mmo-dev}"
SERVER_DIR="$WORK_DIR/server"
RAM="2G"
TEST_ONLY=0
DETACH=0
REQUIRED_JAVA=25
LOG_FILE="$SERVER_DIR/server-console.log"

usage() {
    cat <<EOF
server-start.sh — เปิดเซิร์ฟเวอร์ Paper

วิธีใช้:
  ./server-start.sh                  ตรวจทุกอย่างแล้วเปิดเซิร์ฟเวอร์ (แบบเห็นข้อความสด ๆ)
  ./server-start.sh --test           ตรวจสภาพแวดล้อมเท่านั้น ไม่เปิดเซิร์ฟเวอร์
  ./server-start.sh --ram 4G         กำหนด RAM ที่ให้เซิร์ฟเวอร์
  ./server-start.sh --detach         เปิดแบบเบื้องหลัง แล้วเก็บ log ไว้ที่ server-console.log
  ./server-start.sh --help           แสดงข้อความนี้

โฟลเดอร์เซิร์ฟเวอร์: $SERVER_DIR
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

fail() { echo "❌ $1"; FAILED=1; }
FAILED=0

echo "=========================================="
echo " Server Start — Eclipse MMO RPG Academy"
echo "=========================================="
echo "โฟลเดอร์: $SERVER_DIR"
echo "RAM ที่จัดสรร: $RAM"
echo

# 1) ตรวจโฟลเดอร์
if [ ! -d "$SERVER_DIR" ]; then
    echo "⚠️  ยังไม่มีโฟลเดอร์เซิร์ฟเวอร์: $SERVER_DIR"
    echo "    สร้างด้วย: mkdir -p \"$SERVER_DIR\""
    exit 1
fi

# 2) ตรวจไฟล์ paper-*.jar
JAR_FILE=""
if compgen -G "$SERVER_DIR/paper-*.jar" >/dev/null; then
    JAR_FILE="$(ls -1 "$SERVER_DIR"/paper-*.jar | sort | tail -1)"
    echo "✅ พบไฟล์เซิร์ฟเวอร์: $(basename "$JAR_FILE")"
else
    fail "ไม่พบไฟล์ paper-*.jar ใน $SERVER_DIR"
    cat <<'EOF'

    วิธีเตรียมไฟล์เซิร์ฟเวอร์ (ทำใน Month 5, Day 181):
      1) เปิด https://fill.papermc.io/v3/projects/paper/versions/ แล้วเลือกเวอร์ชัน (เช่น 26.3)
      2) เลือก build ที่ channel = STABLE แล้วดาวน์โหลดไฟล์ .jar
      3) ย้ายไปไว้ที่โฟลเดอร์เซิร์ฟเวอร์ เช่น
         mv ~/Downloads/paper-26.3-*.jar "$SERVER_DIR/"
      4) ดาวน์โหลดแล้วตรวจไฟล์ไม่เสียหาย: unzip -t paper-*.jar | tail -1
EOF
fi

# 3) ตรวจ Java
if command -v java >/dev/null 2>&1; then
    JAVA_MAJOR=$(java -version 2>&1 | head -1 | sed -E 's/.*version "([0-9]+).*/\1/')
    if [ "$JAVA_MAJOR" = "$REQUIRED_JAVA" ]; then
        echo "✅ Java $JAVA_MAJOR ตรงกับที่ Paper 26.x ต้องการ"
    else
        fail "Java ที่พบคือ ${JAVA_MAJOR:-ไม่ทราบ} แต่ Paper 26.x ต้องใช้ Java $REQUIRED_JAVA"
    fi
else
    fail "ไม่พบคำสั่ง java"
fi

# 4) ตรวจ EULA
if [ -f "$SERVER_DIR/eula.txt" ] && grep -qi '^eula=true' "$SERVER_DIR/eula.txt"; then
    echo "✅ ยอมรับ EULA แล้ว (eula.txt = true)"
else
    echo "⚠️  ยังไม่ได้ยอมรับ EULA"
    echo "    ต้องอ่าน https://aka.ms/MinecraftEULA ก่อน แล้วสร้างไฟล์ eula.txt ที่มีบรรทัด: eula=true"
    echo "    (เซิร์ฟเวอร์จะปิดตัวเองทันทีถ้าไม่ตั้งค่านี้)"
fi

# 5) ตรวจพอร์ต
if command -v ss >/dev/null 2>&1; then
    if ss -tuln 2>/dev/null | grep -q ":25565 "; then
        fail "พอร์ต 25565 ถูกใช้อยู่ — ปิดเซิร์ฟเวอร์ตัวเก่าก่อน (อย่าเปิดซ้อน)"
    else
        echo "✅ พอร์ต 25565 ว่าง"
    fi
else
    echo "ℹ️  ไม่พบคำสั่ง ss — ข้ามการตรวจพอร์ต"
fi

# 6) ตรวจพื้นที่ดิสก์ขั้นต่ำ
AVAIL_GB=$(df -Pk "$SERVER_DIR" | awk 'NR==2 {printf "%.1f", $4/1024/1024}')
if awk -v a="$AVAIL_GB" 'BEGIN{exit !(a >= 5)}'; then
    echo "✅ พื้นที่ว่างเพียงพอ (${AVAIL_GB} GB)"
else
    fail "พื้นที่ว่างเหลือ ${AVAIL_GB} GB — ควรมีอย่างน้อย 5 GB"
fi

echo
if [ "$FAILED" -ne 0 ]; then
    echo "⛔ ยังเปิดเซิร์ฟเวอร์ไม่ได้ — แก้ปัญหาข้างบนก่อน"
    exit 1
fi

if [ "$TEST_ONLY" -eq 1 ]; then
    echo "✅ ตรวจสภาพแวดล้อมผ่านทั้งหมด (โหมด --test: ไม่เปิดเซิร์ฟเวอร์)"
    exit 0
fi

echo "▶️  กำลังเปิดเซิร์ฟเวอร์ (ปิดอย่างปลอดภัยด้วยคำสั่ง stop ในคอนโซล)"
echo "    ห้ามใช้ kill -9 กับเซิร์ฟเวอร์ เพราะโลก/ข้อมูลอาจเสียหาย"
echo
JVM_ARGS=(-Xms512M "-Xmx$RAM" -XX:+UseG1GC)

if [ "$DETACH" -eq 1 ]; then
    nohup java "${JVM_ARGS[@]}" -jar "$JAR_FILE" nogui > "$LOG_FILE" 2>&1 &
    PID=$!
    echo "เปิดแบบเบื้องหลัง: PID $PID"
    echo "ดู log ด้วย: tail -f \"$LOG_FILE\""
    echo "ปิดอย่างปลอดภัย: พิมพ์ stop ในคอนโซลไม่ได้ในโหมดนี้ → ให้ใช้ tmux/screen แทนในงานจริง"
    exit 0
fi

cd "$SERVER_DIR" || exit 1
exec java "${JVM_ARGS[@]}" -jar "$JAR_FILE" nogui
