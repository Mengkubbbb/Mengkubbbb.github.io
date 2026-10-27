#!/usr/bin/env bash
# backup.sh — สำรองข้อมูลเซิร์ฟเวอร์อย่างปลอดภัย
# ใช้: ./backup.sh [--apply] [--keep N] [--source <โฟลเดอร์>] [--dest <โฟลเดอร์>] [--help]
# ความปลอดภัย: ค่าเริ่มต้นเป็น DRY-RUN (แสดงว่าจะทำอะไร) ต้องใส่ --apply จึงคัดลอกจริง

set -uo pipefail

# ---------- ค่าตั้งต้น ----------
WORK_DIR="${MMA_WORK_DIR:-$HOME/minecraft-mmo-dev}"
SOURCE="$WORK_DIR/server"
DEST="$WORK_DIR/backups"
APPLY=0
KEEP=7
STAMP="$(date '+%Y-%m-%d_%H%M%S')"

usage() {
    cat <<EOF
backup.sh — สำรองโฟลเดอร์เซิร์ฟเวอร์ Minecraft

วิธีใช้:
  ./backup.sh                          แสดงแผนการสำรอง (dry-run, ไม่คัดลอก)
  ./backup.sh --apply                  สำรองจริง
  ./backup.sh --apply --keep 3         สำรองจริงและเก็บไว้ 3 ชุดล่าสุด
  ./backup.sh --source <dir> --dest <dir>   กำหนดเอง

ค่าเริ่มต้น:
  source = $SOURCE
  dest   = $DEST
  เก็บชุดล่าสุด $KEEP ชุด

หมายเหตุ: script นี้จะไม่ลบไฟล์ข้อมูลเดิมนอกโฟลเดอร์ dest
EOF
}

# ---------- อ่าน argument ----------
while [ $# -gt 0 ]; do
    case "$1" in
        --apply) APPLY=1 ;;
        --keep) shift; KEEP="${1:-7}" ;;
        --source) shift; SOURCE="${1:-}" ;;
        --dest) shift; DEST="${1:-}" ;;
        --help|-h) usage; exit 0 ;;
        *) echo "ไม่รู้จักตัวเลือก: $1"; usage; exit 2 ;;
    esac
    shift
done

case "$KEEP" in ''|*[!0-9]*) echo "❌ --keep ต้องเป็นตัวเลข"; exit 2 ;; esac
[ "$KEEP" -lt 1 ] && { echo "❌ --keep ต้องอย่างน้อย 1"; exit 2; }

echo "=========================================="
echo " Backup — Eclipse MMO RPG Academy"
echo "=========================================="
echo "โหมด: $([ "$APPLY" -eq 1 ] && echo 'คัดลอกจริง (--apply)' || echo 'DRY-RUN (แสดงผลเท่านั้น)')"
echo "ต้นทาง: $SOURCE"
echo "ปลายทาง: $DEST/$STAMP/"
echo

if [ ! -d "$SOURCE" ]; then
    echo "⚠️  ไม่พบโฟลเดอร์ต้นทาง: $SOURCE"
    echo "    วิธีแก้: ตรวจพาธ หรือใช้ --source <โฟลเดอร์ที่ถูกต้อง>"
    echo "    (ถ้าเป็นครั้งแรก ให้สร้างก่อน: mkdir -p \"$SOURCE\")"
    exit 1
fi

SRC_SIZE=$(du -sh "$SOURCE" 2>/dev/null | awk '{print $1}')
SRC_COUNT=$(find "$SOURCE" -type f 2>/dev/null | wc -l | tr -d ' ')
echo "ข้อมูลที่จะสำรอง: $SRC_COUNT ไฟล์ (รวม $SRC_SIZE)"

# ตรวจพื้นที่ว่างของปลายทาง (ถ้ามีอยู่แล้ว)
DEST_PARENT="$(dirname "$DEST")"
if [ -d "$DEST_PARENT" ] && command -v df >/dev/null 2>&1; then
    AVAIL_GB=$(df -Pk "$DEST_PARENT" | awk 'NR==2 {printf "%.1f", $4/1024/1024}')
    echo "พื้นที่ว่างที่ปลายทาง: ${AVAIL_GB} GB"
    echo "💡 ตรวจให้แน่ใจว่าพื้นที่เพียงพอก่อนใช้ --apply"
fi
echo

if [ "$APPLY" -eq 0 ]; then
    echo "--- แผนการทำงาน (dry-run) ---"
    echo "1) mkdir -p \"$DEST/$STAMP\""
    echo "2) cp -a \"$SOURCE/.\" \"$DEST/$STAMP/\""
    echo "3) echo \"$STAMP\" > \"$DEST/latest.txt\""
    echo "4) ลบชุดสำรองเก่า ให้เหลือ $KEEP ชุดล่าสุด"
    echo
    echo "✅ ตรวจแผนเรียบร้อย — ถ้าถูกต้องให้รันใหม่ด้วย: ./backup.sh --apply"
    exit 0
fi

mkdir -p "$DEST/$STAMP" || { echo "❌ สร้างโฟลเดอร์ปลายทางไม่สำเร็จ"; exit 1; }
cp -a "$SOURCE/." "$DEST/$STAMP/" || { echo "❌ คัดลอกไม่สำเร็จ (พื้นที่ไม่พอ?)"; exit 1; }
echo "$STAMP" > "$DEST/latest.txt"

echo "✅ สำรองเสร็จ: $DEST/$STAMP"
echo "   ขนาด: $(du -sh "$DEST/$STAMP" 2>/dev/null | awk '{print $1}')"

# เก็บเฉพาะชุดล่าสุด N ชุด
OLD_LIST=$(ls -1d "$DEST"/*/ 2>/dev/null | sort | head -n -"$KEEP")
if [ -n "$OLD_LIST" ]; then
    echo
    echo "--- ลบชุดสำรองเก่า (เก็บ $KEEP ชุดล่าสุด) ---"
    echo "$OLD_LIST" | while read -r old; do
        [ -z "$old" ] && continue
        case "$old" in
            "$DEST/$STAMP/") continue ;;
        esac
        echo "ลบ: $old"
        rm -rf -- "$old"
    done
fi

echo
echo "📌 ขั้นต่อไป: ทดสอบว่ากู้คืนได้จริง (ดู tests/checklists/backup-restore.md)"
