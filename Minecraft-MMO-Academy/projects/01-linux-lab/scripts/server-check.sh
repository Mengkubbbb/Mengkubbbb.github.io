#!/usr/bin/env bash
# server-check.sh — ตรวจสุขภาพเครื่องสำหรับเซิร์ฟเวอร์ Minecraft
# ใช้: ./server-check.sh [--quiet] [--help]
# หลักการ: "ตรวจเท่านั้น ไม่แก้ไขอะไรในระบบ" จึงรันซ้ำได้อย่างปลอดภัย
# เกณฑ์: Paper 26.x ต้องใช้ Java 25 (ตรวจ 2026-10-27 จาก https://docs.papermc.io/paper/getting-started/)

set -uo pipefail

# ---------- ค่าตั้งต้น (ปรับได้) ----------
REQUIRED_JAVA=25
MIN_DISK_GB=10
MIN_RAM_GB=2
MIN_CPU_CORES=2
MC_PORT=25565
WORK_DIR="${MMA_WORK_DIR:-$HOME/minecraft-mmo-dev}"
SERVER_DIR="$WORK_DIR/server"

QUIET=0
WARN_COUNT=0
FAIL_COUNT=0

# ---------- ตัวช่วย ----------
ok()   { [ "$QUIET" -eq 1 ] || echo "    ✅ $1"; }
warn() { [ "$QUIET" -eq 1 ] || echo "    ⚠️  $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { [ "$QUIET" -eq 1 ] || echo "    ❌ $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
info() { [ "$QUIET" -eq 1 ] || echo "    ℹ️  $1"; }
section() { [ "$QUIET" -eq 1 ] || echo "[$1]"; }

usage() {
    cat <<'EOF'
server-check.sh — ตรวจสุขภาพเครื่องสำหรับเซิร์ฟเวอร์ Minecraft MMO RPG

วิธีใช้:
  ./server-check.sh            ตรวจและแสดงรายงานทั้งหมด
  ./server-check.sh --quiet    แสดงเฉพาะบรรทัดสรุป
  ./server-check.sh --help     แสดงข้อความนี้

ค่า exit:
  0 = ไม่มีปัญหาร้ายแรง   (อาจมีคำเตือน)
  1 = พบปัญหาร้ายแรง      (ต้องแก้ก่อนเปิดเซิร์ฟเวอร์)

ตัวแปรที่ปรับได้ผ่าน environment:
  MMA_WORK_DIR   โฟลเดอร์ทำงาน (ค่าเริ่มต้น: $HOME/minecraft-mmo-dev)
EOF
}

# ---------- อ่าน argument ----------
for arg in "$@"; do
    case "$arg" in
        --quiet) QUIET=1 ;;
        --help|-h) usage; exit 0 ;;
        *) echo "ไม่รู้จักตัวเลือก: $arg"; usage; exit 2 ;;
    esac
done

# ---------- helper: ตรวจว่าคำสั่งมีอยู่ ----------
has() { command -v "$1" >/dev/null 2>&1; }

# ---------- ตรวจว่าค่าเป็นตัวเลขจำนวนเต็ม ----------
is_int() { case "$1" in ''|*[!0-9]*) return 1 ;; *) return 0 ;; esac; }

# ---------- เปรียบเทียบเลขทศนิยมด้วย awk ----------
ge() { awk -v a="$1" -v b="$2" 'BEGIN{exit !(a >= b)}'; }

# ================= รายงาน =================
[ "$QUIET" -eq 1 ] || {
    echo "=========================================="
    echo " Server Check — Eclipse MMO RPG Academy"
    echo "=========================================="
    echo "วันที่ตรวจ: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "เครื่อง: $(hostname) ($(uname -s) $(uname -m))"
    echo
}

# ---------- [1] ระบบปฏิบัติการ ----------
section "1] ระบบปฏิบัติการ"
if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    ok "${PRETTY_NAME:-ไม่ทราบชื่อระบบ}"
else
    warn "ไม่พบไฟล์ /etc/os-release (ตรวจชื่อระบบไม่ได้)"
fi
if has uptime; then
    info "uptime: $(uptime -p 2>/dev/null || uptime)"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- [2] Java ----------
section "2] Java (Paper 26.x ต้องใช้ Java $REQUIRED_JAVA)"
if has java; then
    JAVA_RAW=$(java -version 2>&1 | head -1)
    JAVA_MAJOR=$(echo "$JAVA_RAW" | sed -E 's/.*version "([0-9]+).*/\1/')
    if is_int "$JAVA_MAJOR" && [ "$JAVA_MAJOR" = "$REQUIRED_JAVA" ]; then
        ok "java: $JAVA_MAJOR (ตรงกับที่ Paper $REQUIRED_JAVA ต้องการ)"
    else
        fail "java: ${JAVA_MAJOR:-ไม่ทราบเวอร์ชัน} แต่ต้องใช้ $REQUIRED_JAVA"
    fi
    if has javac; then
        ok "javac: $(javac -version 2>&1 | sed -E 's/^javac //')"
    else
        warn "ไม่พบ javac (อาจติดตั้งแค่ JRE — ต้องใช้ JDK สำหรับเขียนปลั๊กอิน)"
    fi
    if [ -n "${JAVA_HOME:-}" ]; then
        ok "JAVA_HOME = $JAVA_HOME"
        if [ -x "$JAVA_HOME/bin/java" ]; then
            ok "JAVA_HOME/bin/java ใช้งานได้ ($("$JAVA_HOME/bin/java" -version 2>&1 | head -1))"
        else
            warn "JAVA_HOME ชี้ไปที่โฟลเดอร์ที่ไม่มี bin/java"
        fi
    else
        warn "JAVA_HOME ไม่ได้ตั้งค่า (เครื่องมืออื่นอาจหา Java ไม่เจอ)"
    fi
else
    fail "ไม่พบคำสั่ง java — ติดตั้ง JDK $REQUIRED_JAVA ก่อน (ดู Day 04)"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- [3] ดิสก์ ----------
section "3] พื้นที่ดิสก์ (ต้องการว่างอย่างน้อย ${MIN_DISK_GB} GB)"
if has df; then
    DISK_AVAIL_GB=$(df -Pk "$HOME" | awk 'NR==2 {printf "%.1f", $4/1024/1024}')
    DISK_USED_PCT=$(df -Pk "$HOME" | awk 'NR==2 {print $5}')
    if ge "$DISK_AVAIL_GB" "$MIN_DISK_GB"; then
        ok "เหลือ ${DISK_AVAIL_GB} GB (ใช้ไป ${DISK_USED_PCT})"
    else
        fail "เหลือ ${DISK_AVAIL_GB} GB — ลบไฟล์ log/build เก่าก่อน"
    fi
else
    warn "ไม่พบคำสั่ง df — ข้ามการตรวจดิสก์"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- [4] RAM ----------
section "4] หน่วยความจำ"
if has free; then
    TOTAL_GB=$(free -m | awk '/^Mem:/ {printf "%.1f", $2/1024}')
    AVAIL_GB=$(free -m | awk '/^Mem:/ {printf "%.1f", $7/1024}')
    if ge "$AVAIL_GB" "$MIN_RAM_GB"; then
        ok "RAM รวม ${TOTAL_GB} GB | ว่าง ${AVAIL_GB} GB"
    else
        warn "RAM ว่างเพียง ${AVAIL_GB} GB (เกณฑ์ ${MIN_RAM_GB} GB) — ปิดโปรแกรมอื่นก่อนเปิดเซิร์ฟเวอร์"
    fi
    if ge "$TOTAL_GB" "4"; then
        info "สามารถจัดสรรให้เซิร์ฟเวอร์ได้ประมาณ 2-3 GB (ไม่ควรเกินครึ่งของ RAM ทั้งหมด)"
    else
        warn "RAM ทั้งเครื่องน้อยกว่า 4 GB — ควรใช้ผู้เล่นทดสอบไม่เกิน 5 คน"
    fi
else
    warn "ไม่พบคำสั่ง free — ข้ามการตรวจ RAM"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- [5] CPU ----------
section "5] CPU"
CPU_CORES=$( (nproc 2>/dev/null) || echo "")
if is_int "$CPU_CORES"; then
    if [ "$CPU_CORES" -ge "$MIN_CPU_CORES" ]; then
        ok "${CPU_CORES} คอร์"
    else
        warn "${CPU_CORES} คอร์ (แนะนำอย่างน้อย ${MIN_CPU_CORES} คอร์)"
    fi
else
    warn "ตรวจจำนวน CPU ไม่ได้ (ไม่พบ nproc)"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- [6] พอร์ต ----------
section "6] พอร์ต $MC_PORT"
PORT_BUSY="unknown"
if has ss; then
    if ss -tuln 2>/dev/null | grep -q ":${MC_PORT} "; then PORT_BUSY="yes"; else PORT_BUSY="no"; fi
elif has netstat; then
    if netstat -tuln 2>/dev/null | grep -q ":${MC_PORT} "; then PORT_BUSY="yes"; else PORT_BUSY="no"; fi
fi
case "$PORT_BUSY" in
    no)   ok "พอร์ต $MC_PORT ว่าง (พร้อมให้เซิร์ฟเวอร์ใช้)" ;;
    yes)  warn "พอร์ต $MC_PORT ถูกใช้อยู่ (มีเซิร์ฟเวอร์รันอยู่แล้ว?)" ;;
    *)    warn "ตรวจพอร์ตไม่ได้ (ไม่พบ ss/netstat)" ;;
esac
[ "$QUIET" -eq 1 ] || echo

# ---------- [7] โครงสร้างโปรเจกต์ ----------
section "7] โครงสร้างโปรเจกต์ ($WORK_DIR)"
MISSING=0
for dir in server scripts notes backups lab; do
    if [ -d "$WORK_DIR/$dir" ]; then
        ok "พบโฟลเดอร์ $dir"
    else
        warn "ไม่พบโฟลเดอร์ $dir"
        MISSING=$((MISSING + 1))
    fi
done
if [ -d "$SERVER_DIR" ]; then
    SERVER_FILES=$(find "$SERVER_DIR" -type f 2>/dev/null | wc -l | tr -d ' ')
    info "โฟลเดอร์เซิร์ฟเวอร์มี $SERVER_FILES ไฟล์"
    if compgen -G "$SERVER_DIR/paper-*.jar" >/dev/null; then
        info "พบไฟล์เซิร์ฟเวอร์: $(basename "$(ls -1 "$SERVER_DIR"/paper-*.jar | head -1)")"
    else
        info "ยังไม่มีไฟล์ paper-*.jar (จะดาวน์โหลดใน Month 5)"
    fi
else
    info "ยังไม่มีโฟลเดอร์เซิร์ฟเวอร์ (จะสร้างใน Month 5)"
fi
[ "$QUIET" -eq 1 ] || echo

# ---------- สรุป ----------
echo "------------------------------------------"
if [ "$FAIL_COUNT" -eq 0 ] && [ "$WARN_COUNT" -eq 0 ]; then
    echo "สรุป: ✅ ผ่านทุกหมวด ไม่มีคำเตือน"
    exit 0
elif [ "$FAIL_COUNT" -eq 0 ]; then
    echo "สรุป: ⚠️ ผ่านทุกหมวด แต่มีคำเตือน $WARN_COUNT รายการ"
    exit 0
else
    echo "สรุป: ❌ มีปัญหาต้องแก้ $FAIL_COUNT รายการ (คำเตือน $WARN_COUNT รายการ)"
    exit 1
fi
